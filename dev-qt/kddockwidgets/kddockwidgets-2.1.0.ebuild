# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="KDAB's Dock Widget Framework for Qt"
HOMEPAGE="https://www.kdab.com/development-resources/qt-tools/kddockwidgets/"
SRC_URI="https://github.com/KDAB/KDDockWidgets/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	dev-qt/qtdeclarative:6[widgets]
	dev-libs/spdlog:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}/fmt11.patch" )

src_configure() {
	local mycmakeargs=(
		-DKDDockWidgets_QT6=ON
	)
	cmake_src_configure
}
