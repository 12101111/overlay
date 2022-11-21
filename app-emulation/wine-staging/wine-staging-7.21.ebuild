# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs wrapper

WINE_GECKO=2.47.3
WINE_MONO=7.4.0

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wine-staging/wine-staging.git"
	WINE_EGIT_REPO_URI="https://gitlab.winehq.org/wine/wine.git"
else
	(( $(ver_cut 2) )) && WINE_SDIR=$(ver_cut 1).x || WINE_SDIR=$(ver_cut 1).0
	SRC_URI="
		https://dl.winehq.org/wine/source/${WINE_SDIR}/wine-${PV}.tar.xz
		https://github.com/wine-staging/wine-staging/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64 ~x86"
fi
S="${WORKDIR}/wine-${PV}"

DESCRIPTION="Free implementation of Windows(tm) on Unix, with Wine-Staging patchset"
HOMEPAGE="https://wiki.winehq.org/Wine-Staging"

LICENSE="LGPL-2.1+ BSD-2 IJG MIT ZLIB gsm libpng2 libtiff"
SLOT="${PV}"
IUSE="
	+X +alsa capi crossdev-mingw cups dos
	llvm-libunwind debug custom-cflags +fontconfig +gecko gphoto2
	+gstreamer kerberos ldap +mingw +mono netapi nls odbc opencl
	+opengl osmesa pcap perl pulseaudio samba scanner +sdl selinux
	+ssl +truetype udev udisks +unwind usb v4l +vulkan +xcomposite
	xinerama wayland"
REQUIRED_USE="
	X? ( truetype )
	crossdev-mingw? ( mingw )" # bug #551124 for truetype

# tests are non-trivial to run, can hang easily, don't play well with
# sandbox, and several need real opengl/vulkan or network access
RESTRICT="test"

# `grep WINE_CHECK_SONAME configure.ac` + if not directly linked
WINE_DLOPEN_DEPEND="
	X? (
		x11-libs/libXcursor
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXxf86vm
		opengl? (
			media-libs/libglvnd[X]
			osmesa? ( media-libs/mesa[osmesa] )
		)
		xcomposite? ( x11-libs/libXcomposite )
		xinerama? ( x11-libs/libXinerama )
	)
	cups? ( net-print/cups )
	fontconfig? ( media-libs/fontconfig )
	kerberos? ( virtual/krb5 )
	netapi? ( net-fs/samba )
	odbc? ( dev-db/unixODBC )
	sdl? ( media-libs/libsdl2[haptic,joystick] )
	ssl? ( net-libs/gnutls:= )
	truetype? ( media-libs/freetype )
	udisks? ( sys-apps/dbus )
	v4l? ( media-libs/libv4l )
	vulkan? ( media-libs/vulkan-loader )"
WINE_COMMON_DEPEND="
	${WINE_DLOPEN_DEPEND}
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	wayland? ( dev-libs/wayland )
	alsa? ( media-libs/alsa-lib )
	capi? ( net-libs/libcapi:= )
	gphoto2? ( media-libs/libgphoto2:= )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gst-plugins-base:1.0
		media-libs/gstreamer:1.0
	)
	ldap? ( net-nds/openldap:= )
	opencl? ( virtual/opencl )
	pcap? ( net-libs/libpcap )
	pulseaudio? ( media-libs/libpulse )
	scanner? ( media-gfx/sane-backends )
	udev? ( virtual/libudev:= )
	unwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind )
		!llvm-libunwind? ( sys-libs/libunwind:= )
	)
	usb? ( dev-libs/libusb:1 )"
RDEPEND="
	${WINE_COMMON_DEPEND}
	app-emulation/wine-desktop-common
	dos? ( games-emulation/dosbox )
	gecko? ( app-emulation/wine-gecko:${WINE_GECKO} )
	gstreamer? ( media-plugins/gst-plugins-meta:1.0 )
	mono? ( app-emulation/wine-mono:${WINE_MONO} )
	perl? (
		dev-lang/perl
		dev-perl/XML-LibXML
	)
	samba? ( net-fs/samba[winbind] )
	selinux? ( sec-policy/selinux-wine )
	udisks? ( sys-fs/udisks:2 )"
DEPEND="
	${WINE_COMMON_DEPEND}
	sys-kernel/linux-headers
	X? ( x11-base/xorg-proto )"
BDEPEND="
	dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	mingw? ( !crossdev-mingw? (
		>=dev-util/mingw64-toolchain-10.0.0_p1-r2
	) )
	nls? ( sys-devel/gettext )"
IDEPEND="app-eselect/eselect-wine"

QA_TEXTRELS="usr/lib/*/wine/i386-unix/*.so" # uses -fno-PIC -Wl,-z,notext

PATCHES=(
	"${FILESDIR}"/${PN}-7.17-noexecstack.patch
	"${FILESDIR}"/${PN}-7.20-unwind.patch
	"${FILESDIR}"/${PN}-7.21-crossflags.patch
	"${FILESDIR}"/wayland-${PV}.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if use crossdev-mingw && [[ ! -v MINGW_BYPASS ]]; then
		local mingw=-w64-mingw32
		for mingw in x86_64${mingw} i686${mingw}; do
			if ! type -P ${mingw}-gcc >/dev/null; then
				eerror "With USE=crossdev-mingw, you must prepare the MinGW toolchain"
				eerror "yourself by installing sys-devel/crossdev then running:"
				eerror
				eerror "    crossdev --target ${mingw}"
				eerror
				eerror "For more information, please see: https://wiki.gentoo.org/wiki/Mingw"
				die "USE=crossdev-mingw is enabled, but ${mingw}-gcc was not found"
			fi
		done
	fi
}

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		EGIT_CHECKOUT_DIR=${WORKDIR}/${P}
		git-r3_src_unpack

		EGIT_COMMIT=$(<"${EGIT_CHECKOUT_DIR}"/staging/upstream-commit) || die
		EGIT_REPO_URI=${WINE_EGIT_REPO_URI}
		EGIT_CHECKOUT_DIR=${S}
		einfo "Fetching Wine commit matching the current patchset by default (${EGIT_COMMIT})"
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	local staging=(
		./patchinstall.sh DESTDIR="${S}"
		--all
		--backend=eapply
		--no-autoconf
		-W winemenubuilder-Desktop_Icon_Path #652176
		${MY_WINE_STAGING_CONF}
	)

	# source patcher in a subshell so can use eapply as a backend
	ebegin "Running ${staging[*]}"
	( cd ../${P}/patches && . "${staging[@]}" )
	eend ${?} || die "Failed to apply the patchset"

	# sanity check, bumping these has a history of oversights
	local geckomono=$(sed -En '/^#define (GECKO|MONO)_VER/{s/[^0-9.]//gp}' \
		dlls/appwiz.cpl/addons.c || die)
	if [[ ${WINE_GECKO}$'\n'${WINE_MONO} != "${geckomono}" ]]; then
		local gmfatal=
		[[ ${PV} == *9999 ]] && gmfatal=nonfatal
		${gmfatal} die -n "gecko/mono mismatch in ebuild, has: " ${geckomono} " (please file a bug)"
	fi

	if use elibc_musl; then
		PATCHES+=(
			"${FILESDIR}"/pthread.patch
			"${FILESDIR}"/rpath.patch
		)
	fi

	tc-ld-is-lld && eapply "${FILESDIR}"/lld.patch

	default

	# ensure .desktop calls this variant + slot
	sed -i "/^Exec=/s/wine /${P} /" loader/wine.desktop || die

	# always update for patches (including user's wrt #432348)
	eautoreconf
	tools/make_requests || die # perl
}

src_configure() {
	WINE_PREFIX=/usr/lib/${P}
	WINE_DATADIR=/usr/share/${P}

	local conf=(
		--prefix="${EPREFIX}"${WINE_PREFIX}
		--datadir="${EPREFIX}"${WINE_DATADIR}
		--includedir="${EPREFIX}"/usr/include/${P}
		--libdir="${EPREFIX}"${WINE_PREFIX}
		--mandir="${EPREFIX}"${WINE_DATADIR}/man
		$(use_enable gecko mshtml)
		$(use_enable mono mscoree)
		--disable-tests
		$(use_with X x)
		$(use_with wayland)
		$(use_with alsa)
		$(use_with capi)
		$(use_with cups)
		$(use_with fontconfig)
		$(use_with gphoto2 gphoto)
		$(use_with gstreamer)
		$(use_with kerberos gssapi)
		$(use_with kerberos krb5)
		$(use_with ldap)
		$(use_with mingw)
		$(use_with netapi)
		$(use_with nls gettext)
		$(use_with opencl)
		$(use_with opengl)
		$(use_with osmesa)
		--without-oss # media-sound/oss is not packaged (OSSv4)
		$(use_with pcap)
		$(use_with pulseaudio pulse)
		$(use_with scanner sane)
		$(use_with sdl)
		$(use_with ssl gnutls)
		$(use_with truetype freetype)
		$(use_with udev)
		$(use_with udisks dbus) # dbus is only used for udisks
		$(use_with unwind)
		$(use_with usb)
		$(use_with v4l v4l2)
		$(use_with vulkan)
		$(use_with xcomposite)
		$(use_with xinerama)
		$(usev !odbc ac_cv_lib_soname_odbc=)
	)

	use custom-cflags || strip-flags # can break in obscure ways, also no lto
	use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

	local -i bits
	mkdir ../build || die
	cd ../build || die

	conf+=( --enable-win64 )
	conf+=( --enable-archs=i386,x86_64 )
	conf+=( ac_cv_prog_i386_CC=i686-w64-mingw32-gcc )
	conf+=( ac_cv_prog_x86_64_CC=x86_64-w64-mingw32-gcc )

	if use mingw; then
		# use *FLAGS for mingw, but strip unsupported
		: "${CROSSCFLAGS:=$(
			filter-flags '-fstack-clash-protection' #758914
			filter-flags '-fstack-protector*' #870136
			filter-flags '-mfunction-return=thunk*' #878849
			CC=x86_64-w64-mingw32-gcc test-flags-CC ${CFLAGS:--O2})}"
		: "${CROSSLDFLAGS:=$(
			filter-flags '-fuse-ld=*'
			CC=x86_64-w64-mingw32-gcc} test-flags-CCLD ${LDFLAGS})}"
		export CROSS{C,LD}FLAGS
	fi

	ECONF_SOURCE=${S} econf "${conf[@]}"
}

src_compile() {
	emake -C ../build
}

src_install() {
	emake DESTDIR="${D}" -C ../build install

	dosym wine64 ${WINE_PREFIX}/bin/wine
	dosym wine64-preloader ${WINE_PREFIX}/bin/wine-preloader
	local man
	for man in ../build/loader/wine.*man; do
		: "${man##*/wine}"
		: "${_%.*}"
		insinto ${WINE_DATADIR}/man/${_:+${_#.}/}man1
		newins ${man} wine.1
	done

	use perl || rm "${ED}"${WINE_DATADIR}/man/man1/wine{dump,maker}.1 \
		"${ED}"${WINE_PREFIX}/bin/{function_grep.pl,wine{dump,maker}} || die

	# create variant wrappers for eselect-wine
	local bin
	for bin in "${ED}"${WINE_PREFIX}/bin/*; do
		make_wrapper "${bin##*/}-${P#wine-}" "${bin#"${ED}"}"
	done

	# don't let portage try to strip PE files with the wrong
	# strip executable and instead handle it here (saves ~120MB)
	if use mingw; then
		dostrip -x ${WINE_PREFIX}/wine/{i386,x86_64}-windows
		use debug ||
			find "${ED}"${WINE_PREFIX}/wine/*-windows -regex '.*\.\(a\|dll\|exe\)' \
				-exec x86_64-w64-mingw32-strip --strip-unneeded {} + || die
	fi

	dodoc ANNOUNCE AUTHORS README* documentation/README*
}

wine-eselect() {
	ebegin "${1^}ing ${P} using eselect-wine"
	eselect wine ${1} ${P} &&
		eselect wine ${1} --${PN#wine-} ${P} &&
		eselect wine update --if-unset &&
		eselect wine update --${PN#wine-} --if-unset
	eend ${?} || die -n "eselect failed, may need to manually handle ${P}"
}

pkg_postinst() {
	wine-eselect register
}

pkg_prerm() {
	if [[ ${REPLACED_BY_VERSION%-r*} != ${PV} ]]; then #881035
		nonfatal wine-eselect deregister
	fi
}
