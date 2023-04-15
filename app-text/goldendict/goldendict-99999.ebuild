# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop git-r3 qmake-utils

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.org/"
EGIT_REPO_URI="https://github.com/xiaoyifang/${PN}.git"
EGIT_BRANCH="staged"
EGIT_SUBMODULES=()

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug ffmpeg opencc zim multimedia wayland"

RDEPEND="
	app-arch/bzip2
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
	media-libs/tiff:0
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
	ffmpeg? (
		media-libs/libao
		media-video/ffmpeg:0=
	)
	opencc? ( app-i18n/opencc )
	zim? ( app-arch/xz-utils )
	multimedia? ( dev-qt/qtmultimedia[gstreamer] )
	elibc_musl? ( sys-libs/libexecinfo )
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

	use elibc_musl && eapply "${FILESDIR}/0001-fix-for-musl.patch"
	use wayland && eapply "${FILESDIR}/0002-remove-X11.patch"

	# add trailing semicolon
	sed -i -e '/^Categories/s/$/;/' redist/org.goldendict.GoldenDict.desktop || die

	# fix flags
	echo "QMAKE_CXXFLAGS_RELEASE = ${CFLAGS}" >> goldendict.pro
	echo "QMAKE_CFLAGS_RELEASE = ${CXXFLAGS}" >> goldendict.pro
}

src_configure() {
	local myconf=()
	use opencc && myconf+=( "CONFIG+=chinese_conversion_support" )
	use zim && myconf+=( "CONFIG+=zim_support" )
	use ffmpeg || myconf+=( "CONFIG+=no_ffmpeg_player" )
	use multimedia || myconf+=( "CONFIG+=no_qtmultimedia_player" )

	# stack overfow & std::bad_alloc on musl
	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

	eqmake5 "${myconf[@]}" PREFIX="/usr" goldendict.pro
}

src_install() {
	dobin ${PN}
	domenu redist/org.${PN}.GoldenDict.desktop
	doicon redist/icons/${PN}.png

	insinto /usr/share/${PN}/help
	doins help/*.qch

	insinto /usr/share/${PN}/locale
	doins .qm/*.qm
}
