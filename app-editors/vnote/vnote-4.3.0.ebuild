# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg git-r3

DESCRIPTION="Qt-based, free and open source note-taking application, focusing on Markdown"
HOMEPAGE="https://vnotex.github.io/vnote"
EGIT_REPO_URI="https://github.com/vnotex/vnote.git"
EGIT_COMMIT="v${PV}"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="4"

DEPEND="
	dev-qt/qtbase:6[X,cups,gui,network,sql,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6
	dev-qt/qtsvg:6
	dev-libs/qtkeychain:=
"
RDEPEND="${DEPEND}"
PATCHES=( "${FILESDIR}/fix-crash.patch" )

src_prepare() {
	sed -i -e "s|VNote|vnote|g" CMakeLists.txt || die
	sed -i -e "s|add_library(VSyntaxHighlighting|add_library(VSyntaxHighlighting STATIC|g" \
		 libs/vtextedit/libs/syntax-highlighting/CMakeLists.txt || die
	sed -i -e "s|add_library(qhotkey|add_library(qhotkey STATIC|g" \
		libs/QHotkey/CMakeLists.txt || die
	sed -i -e "s|keychain.h|qt6keychain/keychain.h|g" src/core/services/synccredentialsstore.cpp || die
	sed -i -e "s|add_subdirectory(cmark)|add_subdirectory(cmark EXCLUDE_FROM_ALL)|g" libs/vtextedit/libs/CMakeLists.txt || die
	cmake_src_prepare
}

