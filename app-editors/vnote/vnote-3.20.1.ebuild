# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg git-r3

DESCRIPTION="Qt-based, free and open source note-taking application, focusing on Markdown"
HOMEPAGE="https://vnotex.github.io/vnote"
EGIT_REPO_URI="https://github.com/vnotex/vnote.git"
EGIT_COMMIT="v${PV}"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="3"

DEPEND="
	dev-qt/qtbase:6[X,cups,gui,network,sql,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6
	dev-qt/qtsvg:6
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/fix-cmake.patch" )

src_prepare() {
	sed -i -e "s|VNote|vnote|g" CMakeLists.txt || die
	sed -i -e "s|add_library(VSyntaxHighlighting|add_library(VSyntaxHighlighting STATIC|g" \
		 libs/vtextedit/libs/syntax-highlighting/CMakeLists.txt || die
	sed -i -e "s|add_library(qhotkey|add_library(qhotkey STATIC|g" \
		libs/QHotkey/CMakeLists.txt || die
	cmake_src_prepare
}

