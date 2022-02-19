# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ROMs for the 86Box emulator"
HOMEPAGE="https://github.com/86Box/roms"
SRC_URI="https://github.com/86Box/roms/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="86Box-roms"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	insinto "${EPREFIX}/usr/share/86box/roms"
	cd roms-${PV} || die
	doins -r .
}
