# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs xdg

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/joncampbell123/dosbox-x.git"
else
	SRC_URI="https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v${PV}.tar.gz"
	S="${WORKDIR}/${PN}-${PN}-windows-v${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Complete, accurate DOS emulator forked from DOSBox"
HOMEPAGE="https://dosbox-x.com/"

# Stay consistent with games-emulation/dosbox::gentoo even though source file
# headers specify the GPL version to be "either version 2 of the License, or
# (at your option) any later version."  The same header is used in both the
# DOSBox source tree and the DOSBox-X source tree.
LICENSE="GPL-2"
SLOT="0"

IUSE="X debug ffmpeg fluidsynth freetype opengl png slirp"

BDEPEND="
	dev-lang/nasm
	sys-libs/libcap
"

# Unconditionally pulling in automagically-enabled optional dependencies:
# - media-libs/alsa-lib
# - media-libs/sdl2-net
# - net-libs/libpcap
#
# With media-libs/libsdl2[-X,wayland], this package does work on a Wayland
# desktop, but (at least on GNOME) the program does not launch in a movable
# and resizable window; whereas with media-libs/libsdl2[X], it does.  Thus,
# unconditionally require media-libs/libsdl2[X] for better user experience.
RDEPEND="
	media-libs/alsa-lib
	media-libs/libsdl2[X,opengl?,sound,threads,video]
	media-libs/sdl2-net
	net-libs/libpcap
	sys-libs/zlib
	X? (
		x11-libs/libX11
		x11-libs/libXrandr
		x11-libs/libxkbfile
	)
	debug? ( sys-libs/ncurses:= )
	ffmpeg? ( media-video/ffmpeg:= )
	fluidsynth? ( media-sound/fluidsynth:= )
	freetype? ( media-libs/freetype )
	opengl? ( media-libs/libglvnd[X] )
	png? ( media-libs/libpng:= )
	slirp? ( net-libs/libslirp )
"

DEPEND="
	${RDEPEND}
"

PATCHES=(
    "${FILESDIR}/sys-perm.patch"
    "${FILESDIR}/cmath.patch"
    "${FILESDIR}/z_of_fix.patch"
    "${FILESDIR}/fcntl.patch"
    "${FILESDIR}/fix.patch"
)

pkg_pretend() {
	if use ffmpeg && use !png; then
		ewarn "Setting the 'ffmpeg' USE flag when the 'png' USE flag is"
		ewarn "unset does not have any effect.  Unsetting the 'png' USE"
		ewarn "flag disables the video capture feature, so additional"
		ewarn "video capture formats enabled by the 'ffmpeg' USE flag"
		ewarn "will end up being unused."
	fi
}

src_prepare() {
	default

	# Patch command lines like the following in Makefile.am:
	#   -test -x /usr/sbin/setcap && setcap cap_net_raw=ep $(DESTDIR)$(bindir)/dosbox-x
	#
	# The purpose of these commands is, if the 'setcap' program exists and is
	# executable, then invoke it to set capabilities required by the PCAP
	# networking back-end for better out-of-box user experience; otherwise,
	# ignore unsatisfied preconditions or 'setcap' errors since they are not
	# critical, which is achieved by having a '-' in front of each line.
	#
	# Unfortunately, 'test -x /usr/sbin/setcap' does not always work as
	# expected on Gentoo because it ignores the fact that some distributions,
	# including Gentoo, may still have split /sbin and /usr/sbin and install
	# 'setcap' to /sbin.
	#
	# As long as sys-libs/libcap is declared in BDEPEND of this ebuild, the
	# availability of 'setcap' can be assumed, rendering the test redundant.
	# However, successfully setting capabilities via 'setcap' usually requires
	# the root account (which is not guaranteed on Prefix) and xattr support
	# for the file system being used, so the '-' in front of each line is
	# preserved to tolerate the expected 'setcap' failures.
	sed -i -e 's|test -x /usr/sbin/setcap && ||' Makefile.am ||
		die "Failed to remove check for setcap in Makefile.am"

	eautoreconf
}

src_configure() {
	local myconf=(
		# --disable-core-inline could cause compiler errors
		# as of v2022.08.0, so enable it unconditionally
		--enable-core-inline

		# Always use SDL 2, even though the package provides the option to
		# build with SDL 1.x, because this package is expected to be built
		# with the bundled, heavily-modified version of SDL 1.x if that
		# branch is used.  Compiler errors are likely to occur if the
		# bundled version of SDL 1.x is not used.  Bundled dependencies
		# should be avoided on Gentoo, so SDL 2 is more preferable.
		--enable-sdl2

		# Explicitly enable ALSA MIDI support, same as default.  As of
		# v2022.08.0, even when it is disabled, media-libs/alsa-lib will
		# still be automagically linked if it is present in the build
		# environment (presumably for other components of this package),
		# so the dependency cannot be made optional by disabling this
		# option.  Plus, disabling this option has no observable effect
		# on build time, build size, or the program's functionality, as
		# 'mididevice=alsa' still works with '--disable-alsa-midi'.
		--enable-alsa-midi

		$(use_enable debug '' heavy)

		$(use_enable X x11)
		$(use_enable ffmpeg avcodec)
		$(use_enable fluidsynth libfluidsynth)
		$(use_enable freetype)
		$(use_enable opengl)
		$(use_enable png screenshots)
		$(use_enable slirp libslirp)
	)

	econf "${myconf[@]}"
}

src_compile() {
	# https://bugs.gentoo.org/856352
	emake AR="$(tc-getAR)"
}

pkg_preinst() {
	xdg_pkg_preinst

	# Returns whether or not the USE flag specified with the first positional
	# argument is newly enabled for this installation of the package.
	newuse() {
		local flag="${1}"

		# The 'has_version' call tests if any USE flags are newly enabled.
		# It is to extract information about any existing copy of this
		# package installed on the system, which is why it should be made
		# before the new copy of this package just built is merged.
		use "${flag}" && ! has_version "${CATEGORY}/${PN}[${flag}]"
	}

	newuse debug && PRINT_NOTES_FOR_DEBUGGER=1
	newuse fluidsynth && PRINT_NOTES_FOR_FLUIDSYNTH=1
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ "${PRINT_NOTES_FOR_DEBUGGER}" ]]; then
		elog
		elog "Note on the Debugger"
		elog
		elog "The debugger can only be started when DOSBox-X is launched"
		elog "from a terminal.  Otherwise, the \"Start DOSBox-X Debugger\""
		elog "option in the \"Debug\" drop-down menu would be unavailable."
		elog
		elog "For more information about the debugger, please consult:"
		elog "  ${EPREFIX}/usr/share/doc/${PF}/README.debugger*"
	fi

	if [[ "${PRINT_NOTES_FOR_FLUIDSYNTH}" ]]; then
		elog
		elog "Note on FluidSynth"
		elog
		elog "To use FluidSynth as the MIDI device for DOSBox-X, a soundfont"
		elog "is required.  If no existing soundfont is available, a new one"
		elog "can be installed and configured for DOSBox-X very easily:"
		elog
		elog "1. Install the following package:"
		elog "     media-sound/fluid-soundfont"
		elog "2. Add the following lines to DOSBox-X's configuration file:"
		elog "     [midi]"
		elog "     mididevice=fluidsynth"
		elog
		elog "Usually, there is no need to explicitly specify the soundfont"
		elog "file's path because the package mentioned in step 1 installs"
		elog "soundfont files to a standard location, allowing them to be"
		elog "detected and selected automatically."
		elog
		elog "For advanced FluidSynth configuration, please consult:"
		elog "  https://dosbox-x.com/wiki/Guide%3ASetting-up-MIDI-in-DOSBox%E2%80%90X#_fluidsynth"
	fi
}
