# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils gnome2-utils

DESCRIPTION="Graphical utility to review and modify permissions from Flatpak applications"
HOMEPAGE="https://github.com/tchx84/Flatseal"
SRC_URI="https://github.com/tchx84/Flatseal/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=gui-libs/libhandy-1.0.2
	>=dev-libs/appstream-glib-0.7.18
	>=dev-libs/jasmine-gjs-2.6.4
	dev-libs/gjs
"
RDEPEND="
	${DEPEND}
	sys-apps/flatpak
"
BDEPEND=""

S="${WORKDIR}/Flatseal-${PV}"

src_prepare() {
	sed -i -e "s/get_option('datadir'), 'appdata'/get_option('datadir'), 'metainfo'/" "${S}"/data/meson.build
	default
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	gnome2_schemas_update
}
