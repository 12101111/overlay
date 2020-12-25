# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Vim-inspired note taking application that knows programmers and Markdown better"
HOMEPAGE="https://github.com/tamlok/vnote"
VTEXTEDIT_COMMIT="12a74cb32438b28f002dea51c484133d3058a882"
SYNTAX_COMMIT="0f63ff8ce3f7135ffafd62bc464c355960f56cfd"
MY_PV="3.0.0-beta.3"
SRC_URI="
	${HOMEPAGE}/archive/v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz
	https://codeload.github.com/vnotex/vtextedit/tar.gz/${VTEXTEDIT_COMMIT} -> vtextedit-${MY_PV}.tar.gz
	https://codeload.github.com/vnotex/syntax-highlighting/tar.gz/${SYNTAX_COMMIT} -> vnotex-syntax-highlighting-${MY_PV}.tar.gz
"

KEYWORDS=""

PATCHES=(
	"${FILESDIR}/remove_gold_linker.patch"
)

LICENSE="MIT"
SLOT="0"

DEPEND="
	>=dev-qt/qtcore-5.15.1:5=
	>=dev-qt/qtwebengine-5.15.1:5=
	>=dev-qt/qtsvg-5.15.1:5=
"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-${MY_PV}"

pkg_setup(){
	export INSTALL_ROOT="${D}"
}

src_unpack() {
	default
	mv "${WORKDIR}/vtextedit-${VTEXTEDIT_COMMIT}"/* "${S}/libs/vtextedit" || die
	mv "${WORKDIR}/syntax-highlighting-${SYNTAX_COMMIT}"/* "${S}/libs/vtextedit/src/libs/syntax-highlighting" || die
}

src_configure(){
	eqmake5 vnote.pro
}
