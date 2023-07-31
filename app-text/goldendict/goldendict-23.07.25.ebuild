# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop git-r3 qmake-utils flag-o-matic xdg-utils

DESCRIPTION="Feature-rich dictionary lookup program (qtwebengine fork)"
HOMEPAGE="https://github.com/xiaoyifang/goldendict-ng"
EGIT_REPO_URI="https://github.com/xiaoyifang/goldendict-ng.git"
EGIT_BRANCH="staged"
EGIT_COMMIT="v23.07.25-alpha.230729.0585f5da"
EGIT_SUBMODULES=()

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="debug ffmpeg opencc multimedia wayland xapian zim"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	virtual/libiconv
	>=app-text/hunspell-1.2:=
	dev-libs/eb
	dev-libs/lzo
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	dev-qt/qtspeech:5
	media-libs/libvorbis
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
	ffmpeg? (
		media-libs/libao
		media-video/ffmpeg:0=
	)
	opencc? ( app-i18n/opencc )
	multimedia? ( dev-qt/qtmultimedia[gstreamer] )
	xapian? ( dev-libs/xapian )
	zim? ( media-libs/libzim[xapian] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-qtsingleapplication-unbundle.patch"
)

src_prepare() {
	default

	use wayland && eapply "${FILESDIR}/remove-X11.patch"

	# fix flags
	echo "QMAKE_CXXFLAGS_RELEASE = ${CFLAGS}" >> goldendict.pro
	echo "QMAKE_CFLAGS_RELEASE = ${CXXFLAGS}" >> goldendict.pro
}

src_configure() {
	local myconf=( "CONFIG+=use_iconv" )
	use opencc && myconf+=( "CONFIG+=chinese_conversion_support" )
	use ffmpeg || myconf+=( "CONFIG+=no_ffmpeg_player" )
	use multimedia || myconf+=( "CONFIG+=no_qtmultimedia_player" )
	use xapian && myconf+=( "CONFIG+=use_xapian" )
	use zim && myconf+=( "CONFIG+=zim_support" )

	# stack overfow & std::bad_alloc on musl
	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

	eqmake5 "${myconf[@]}" PREFIX="/usr" goldendict.pro
}

src_install() {
	dobin ${PN}
	domenu redist/io.github.xiaoyifang.goldendict_ng.desktop
	doicon redist/icons/${PN}.png

	insinto /usr/share/${PN}/locale
	doins .qm/*.qm
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
