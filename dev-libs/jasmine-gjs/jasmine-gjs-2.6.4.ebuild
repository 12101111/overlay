# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="BDD (behavior-driven development) framework for JavaScript"
HOMEPAGE="https://github.com/ptomato/jasmine-gjs"
SRC_URI="https://github.com/ptomato/jasmine-gjs/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/gjs
"
RDEPEND="${DEPEND}"
BDEPEND=""
