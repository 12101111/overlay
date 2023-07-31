# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Reference implementation of the ZIM specification"
HOMEPAGE="https://openzim.org"
SRC_URI="https://github.com/openzim/libzim/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64 ~amd64 ~x86"
IUSE="xapian"
DEPEND="
	app-arch/xz-utils
	dev-libs/icu:=
	app-arch/zstd
	xapian? ( dev-libs/xapian )
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local emesonargs=(
		$(meson_use xapian with_xapian)
	)
	meson_src_configure
}
