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

src_prepare() {
	sed -i -e "s|vnote|vnote3|g" src/data/core/vnote.desktop || die
	sed -i -e "s|add_library(VSyntaxHighlighting|add_library(VSyntaxHighlighting STATIC|g" \
		 libs/vtextedit/libs/syntax-highlighting/CMakeLists.txt || die
	sed -i -e "s|add_library(qhotkey|add_library(qhotkey STATIC|g" \
		libs/QHotkey/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${ED}/usr/bin/vnote" "${ED}/usr/bin/vnote3"
	mv "${ED}/usr/share/applications/vnote.desktop" "${ED}/usr/share/applications/vnote3.desktop"
	for i in $(ls "${ED}/usr/share/icons/hicolor/");do
		case $i in
			*x*) mv "${ED}/usr/share/icons/hicolor/$i/apps/vnote.png" "${ED}/usr/share/icons/hicolor/$i/apps/vnote3.png";;
			scalable) mv "${ED}/usr/share/icons/hicolor/$i/apps/vnote.svg" "${ED}/usr/share/icons/hicolor/$i/apps/vnote3.svg";;
		esac
	done
}
