# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

RESTRICT="mirror"
QTMIN=6.6.2
KFMIN=6.3.0

DESCRIPTION="The Linux perf GUI for performance analysis."
HOMEPAGE="https://github.com/KDAB/hotspot"
SRC_URI="
	https://github.com/KDAB/hotspot/releases/download/v${PV}/${PN}-v${PV}.tar.gz
	https://github.com/KDAB/hotspot/releases/download/v${PV}/${PN}-perfparser-v${PV}.tar.gz -> ${PN}-v${PV}-perfparser.tar.gz
	https://github.com/KDAB/hotspot/releases/download/v${PV}/${PN}-PrefixTickLabels-v${PV}.tar.gz -> ${PN}-v${PV}-PrefixTickLabels.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64 ~amd64 ~x86"

IUSE="rust"
REQUIRE_USE=""

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[gui,network,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	dev-libs/elfutils[debuginfod]
	sys-devel/gettext
	sys-devel/binutils
	>=kde-frameworks/extra-cmake-modules-${KFMIN}
	>=kde-frameworks/threadweaver-${KFMIN}
	>=kde-frameworks/ki18n-${KFMIN}
	>=kde-frameworks/kconfigwidgets-${KFMIN}
	>=kde-frameworks/kcoreaddons-${KFMIN}
	>=kde-frameworks/kitemviews-${KFMIN}
	>=kde-frameworks/kitemmodels-${KFMIN}
	>=kde-frameworks/kio-${KFMIN}
	>=kde-frameworks/solid-${KFMIN}
	>=kde-frameworks/kwindowsystem-${KFMIN}
	>=kde-frameworks/kparts-${KFMIN}
	dev-util/perf
	>=dev-qt/kddockwidgets-2.1.0
	media-gfx/kgraphviewer
	dev-libs/qcustomplot
	rust? ( dev-libs/rustc-demangle )
	"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/include.patch" )

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${PN}-v${PV}.tar.gz
	tar -xf "${DISTDIR}/${PN}-v${PV}-perfparser.tar.gz" --strip-components=1 -C "${S}/3rdparty/perfparser" || die
	tar -xf "${DISTDIR}/${PN}-v${PV}-PrefixTickLabels.tar.gz" --strip-components=1 -C "${S}/3rdparty/PrefixTickLabels" || die
}

src_configure() {
	local mycmakeargs=(
		-DQT6_BUILD=true
	)
	cmake_src_configure
}
