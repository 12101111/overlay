# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

RESTRICT="mirror"

DESCRIPTION="Hotspot - the Linux perf GUI for performance analysis"
HOMEPAGE="https://github.com/KDAB/hotspot"
SRC_URI="https://github.com/KDAB/hotspot/releases/download/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64 ~amd64 ~x86"

IUSE="rust"
REQUIRE_USE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	dev-qt/qtsvg:5
	dev-libs/elfutils
	sys-devel/gettext
	kde-frameworks/extra-cmake-modules
	kde-frameworks/threadweaver:5
	kde-frameworks/ki18n:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kitemviews:5
	kde-frameworks/kitemmodels:5
	kde-frameworks/kio:5
	kde-frameworks/solid:5
	kde-frameworks/kwindowsystem:5
	kde-frameworks/knotifications:5
	kde-frameworks/kiconthemes:5
	kde-frameworks/kparts:5
	dev-util/perf
	rust? ( dev-libs/rustc-demangle )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
	local mycmakeargs=()
	if use rust; then
		mycmakeargs+=(
			-DRUSTC_DEMANGLE_INCLUDE_DIR=/usr/include
			-DRUSTC_DEMANGLE_LIBRARY=/usr/lib/librustc_demangle.so
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
