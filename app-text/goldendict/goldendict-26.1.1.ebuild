# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="ar ay be bg crowdin cs de de_CH el en eo es es_AR es_BO fa fi fr hi hu
 ie it ja jbo kab ko lt mk nl pl pt pt_BR qu ru sk sq sr sv tg tk tr uk vi zh_CN zh_TW"

inherit cmake flag-o-matic plocale xdg

MY_PV="26.1.1-Release.5491ffca"

DESCRIPTION="Feature-rich dictionary lookup program (GoldenDict-ng fork)"
HOMEPAGE="https://xiaoyifang.github.io/goldendict-ng/"
SRC_URI="
	https://github.com/xiaoyifang/goldendict-ng/archive/v${MY_PV}.tar.gz -> ${PN}-ng-${MY_PV}.tar.gz
"
S="${WORKDIR}/goldendict-ng-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="ffmpeg +epwing tts wayland zim"

DEPEND="
	app-arch/bzip2
	app-arch/lzma
	app-arch/xz-utils
	app-i18n/opencc
	app-text/hunspell
	dev-libs/eb
	dev-libs/lzo:2
	dev-libs/xapian
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[dbus,concurrent,cups,gui,network,sql,widgets,xml,X]
	dev-qt/qtmultimedia:6
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	dev-qt/qtwebengine:6[widgets]
	epwing? ( dev-libs/eb )
	ffmpeg? (
		media-video/ffmpeg:*
	)
	!ffmpeg? ( dev-qt/qtmultimedia:6[gstreamer] )
	media-libs/libvorbis
	tts? ( dev-qt/qtspeech:6 )
	virtual/zlib:=
	dev-libs/libfmt:=
	dev-cpp/tomlplusplus:=
	virtual/opengl
	virtual/libiconv
	x11-libs/libX11
	x11-libs/libxkbcommon
	x11-libs/libXtst
	zim? ( app-arch/libzim )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/qttools:6[assistant,linguist]
	dev-vcs/git
	virtual/pkgconfig
"

src_prepare() {
	local loc_dir="${S}/locale"
	plocale_find_changes "${loc_dir}" "" ".ts"
	rm_loc() {
		rm -vf "locale/${1}.ts" || die
	}
	plocale_for_each_disabled_locale rm_loc

	use wayland && eapply "${FILESDIR}/remove-X11.patch"
	sed -i "6i#include <sstream>" "${S}/src/metadata.cc" || die

	cmake_src_prepare
}

src_configure() {
	# stack overfow & std::bad_alloc on musl
	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

	local mycmakeargs=(
		-DWITH_X11=$(usex wayland OFF ON)
		-DWITH_FFMPEG_PLAYER=$(usex ffmpeg ON OFF)
		-DWITH_EPWING_SUPPORT=$(usex epwing ON OFF)
		-DUSE_SYSTEM_TOML=ON
		-DWITH_TTS=$(usex tts ON OFF)
		-DWITH_ZIM=$(usex zim ON OFF)
		-DWITH_VCPKG_BREAKPAD=OFF
	)
	cmake_src_configure
}
