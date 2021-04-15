# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="BSD licensed clone of the GNU libc backtrace facility"
HOMEPAGE="https://netbsd.org/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-libs/musl
	sys-libs/musl-legacy-compat
	virtual/libelf
	|| ( sys-libs/llvm-libunwind sys-libs/libunwind )
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_prepare() {
	cp -r "${FILESDIR}"/* ${S}
	default
}

src_compile() {
	emake
}

src_install() {
	sed -e "/Version:/s@version@${PV}@" -i libexecinfo.pc
	doheader execinfo.h
	dolib.so libexecinfo.so.1
	dosym libexecinfo.so.1 /usr/lib/libexecinfo.so
	dolib.a libexecinfo.a
	insinto /usr/lib/pkgconfig/
	doins libexecinfo.pc
}
