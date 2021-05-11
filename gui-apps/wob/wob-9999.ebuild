# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="lightweight overlay volume/backlight/progress/anything bar for Wayland"
HOMEPAGE="https://github.com/francma/wob"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/francma/${PN^}.git"
else
    SRC_URI="https://github.com/francma/${PN^}/archive/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64"
fi

LICENSE="ISC"
SLOT="0"

DEPEND="
	dev-libs/wayland
	dev-libs/wayland-protocols
	sys-libs/libseccomp
"
BDEPEND=">=app-text/scdoc-1.9.2"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/musl-fix.patch
)
