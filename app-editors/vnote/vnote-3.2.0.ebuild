# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg git-r3

DESCRIPTION="Qt-based, free and open source note-taking application, focusing on Markdown"
HOMEPAGE="https://vnotex.github.io/vnote"
EGIT_REPO_URI="https://github.com/vnotex/vnote.git"
EGIT_COMMIT="v${PV}"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="3"

DEPEND="
	>=dev-qt/qtcore-5.15.1:5=
	>=dev-qt/qtwebengine-5.15.1:5=
	>=dev-qt/qtsvg-5.15.1:5=
"
RDEPEND="${DEPEND}"

pkg_setup() {
	export INSTALL_ROOT="${ED}"
}

src_prepare() {
	sed -i -e "s|vnote|vnote3|g" src/data/core/vnote.desktop || die
	default
}

src_configure() {
	eqmake5 vnote.pro
}

src_install() {
	emake install
	mv "${ED}/usr/bin/vnote" "${ED}/usr/bin/vnote3"
	mv "${ED}/usr/share/applications/vnote.desktop" "${ED}/usr/share/applications/vnote3.desktop"
	for i in $(ls "${ED}/usr/share/icons/hicolor/");do
		case $i in
			*x*) mv ${ED}/usr/share/icons/hicolor/$i/apps/vnote.png ${ED}/usr/share/icons/hicolor/$i/apps/vnote3.png;;
			scalable) mv ${ED}/usr/share/icons/hicolor/$i/apps/vnote.svg ${ED}/usr/share/icons/hicolor/$i/apps/vnote3.svg;;
		esac
	done
}
