# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="BSD licensed clone of the GNU libc backtrace facility"
HOMEPAGE="http://www.freshports.org/devel/libexecinfo"
SRC_URI="http://distcache.freebsd.org/local-distfiles/itetcu/libexecinfo-${PV}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/musl"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/01-execinfo.patch"
	"${FILESDIR}/02-makefile.patch"
	"${FILESDIR}/03-define-gnu-source.patch"
	"${FILESDIR}/libexecinfo_pc.patch"
)

src_install() {
	sed -e "/Version:/s@version@${PV}@" -i libexecinfo.pc
	doheader *.h
	dolib.so libexecinfo.so.1
	dosym libexecinfo.so.1 /usr/lib/libexecinfo.so
	dolib.a libexecinfo.a
	insinto /usr/lib/pkgconfig/
	doins libexecinfo.pc
}
