# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Legacy compatibility headers for the musl libc"
HOMEPAGE="http://www.voidlinux.org"

LICENSE="BSD-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-libs/musl
	sys-libs/queue-standalone
"
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}"

src_install() {
	insinto /usr/include/sys
	for f in ${FILESDIR}/{cdefs,tree}.h;do
        doins ${f}
    done
	insinto /usr/include
	doins ${FILESDIR}/error.h
}
