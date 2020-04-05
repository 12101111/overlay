# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils xdg

DESCRIPTION="Vim-inspired note taking application that knows programmers and Markdown better"
HOMEPAGE="https://github.com/tamlok/vnote"
EGIT_REPO_URI="${HOMEPAGE}.git"
HOEDOWN_VERSION="4.0.0"
MARKED_VERSION="0.5.1"
SRC_URI="
	https://github.com/tamlok/hoedown/archive/${HOEDOWN_VERSION}.tar.gz -> hoedown-${HOEDOWN_VERSION}.tar.gz
	https://github.com/markedjs/marked/archive/v${MARKED_VERSION}.tar.gz -> marked-${MARKED_VERSION}.tar.gz
"

LICENSE="MIT"
SLOT="0"

DEPEND="
	>=dev-qt/qtcore-5.9:5=
	>=dev-qt/qtwebengine-5.9:5=
	>=dev-qt/qtsvg-5.9:5=
"
RDEPEND="${DEPEND}"

pkg_setup(){
	export INSTALL_ROOT="${D}"
}

src_unpack() {
	default
	mv "${WORKDIR}/hoedown-${HOEDOWN_VERSION}"/* "${S}/hoedown" || die
	mv "${WORKDIR}/marked-${MARKED_VERSION}"/* "${S}/src/utils/marked" || die
}

src_configure(){
	eqmake5 VNote.pro
}
