# Copyright 2019 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Hjdskes/cage"
else
	SRC_URI="https://github.com/Hjdskes/cage/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Wayland Kiosk"
HOMEPAGE="https://www.hjdskes.nl/projects/cage/"
LICENSE="MIT"
SLOT="0"
IUSE="xwayland"

# dev-libs/wayland provides wayland-server, wayland-scanner
DEPEND="
	>=gui-libs/wlroots-0.11.0:=
	xwayland? ( gui-libs/wlroots[X] )
	>=dev-libs/wayland-protocols-1.20:=
	x11-libs/pixman:=
	x11-libs/libxkbcommon:=
	dev-libs/wayland:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		"$(meson_use xwayland)"
		"-Dwerror=false"
	)

	meson_src_configure
}
