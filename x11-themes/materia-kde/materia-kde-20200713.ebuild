# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Port of the GTK Materia Theme for Plasma 5 desktop with additions and extras."
HOMEPAGE="https://git.io/materia-kde"

if [[ ${PV} == 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}"
else
	SRC_URI="https://github.com/PapirusDevelopmentTeam/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm ~arm64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="kde konsole yakuake kvantum"
REQUIRED_USE="|| ( kde konsole yakuake kvantum )"

RDEPEND="
	kde? ( kde-plasma/plasma-desktop:5 )
	konsole? ( kde-apps/konsole )
	yakuake? ( kde-apps/yakuake )
	kvantum? ( x11-themes/kvantum )"

src_install() {
	use kde && THEME+="aurorae color-schemes plasma"
	use konsole && THEME+=" konsole"
	use kvantum && THEME+=" Kvantum"
	use yakuake && THEME+=" yakuake"
	DESTDIR="${ED}" THEMES="${THEME}" default
}
