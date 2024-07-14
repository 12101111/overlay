# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Offline documentation browser inspired by Dash"
HOMEPAGE="https://zealdocs.org/"
SRC_URI="https://github.com/zealdocs/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64 ~amd64 ~x86"
IUSE=""

DEPEND="
	app-arch/libarchive:=
	dev-db/sqlite:3
	dev-qt/qtbase:6[concurrent,gui,network,sql,widgets]
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6[widgets]
	x11-libs/libX11
	x11-libs/libxcb:=
	>=x11-libs/xcb-util-keysyms-0.3.9
"
RDEPEND="${DEPEND}
	x11-themes/hicolor-icon-theme
"
BDEPEND="kde-frameworks/extra-cmake-modules:0"

PATCHES=(
	"${FILESDIR}/0002-settings-disable-checking-for-updates-by-default.patch"
)

src_prepare() {
	# use qt6
	sed -i -e 's/Qt5//g' CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DZEAL_RELEASE_BUILD=ON
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
