# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
SRC_URI="
	https://github.com/YosysHQ/${PN}/releases/download/v${PV}/${PN}.tar.gz -> ${P}.tar.gz
"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/boost
	media-gfx/xdot
	llvm-core/clang
"

DEPEND="${RDEPEND}"
BDEPEND="dev-vcs/git"

S="${WORKDIR}"

src_configure() {
	cat <<-__EOF__ >> Makefile.conf || die
		PREFIX := ${EPREFIX}/usr
		STRIP := @echo "skipping strip"
	__EOF__
	default
}
