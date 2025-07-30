# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev flag-o-matic meson

DESCRIPTION="C library designed for embedded systems"
HOMEPAGE="https://keithp.com/picolibc"
SRC_URI="https://keithp.com/picolibc/dist/${P}.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~mips ~ppc ~riscv ~x86"

DEPEND="||
	(
		>="${CATEGORY}"/gcc-4.7:*
		>="${CATEGORY/sys-devel/llvm-core}"/clang-3.5:*
		>="${CATEGORY}"/clang-crossdev-wrappers-17.0:*
	)
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	export CHOST=${CTARGET}
	export CC=${CTARGET}-cc
	export CXX=${CTARGET}-c++
	export CPP=${CTARGET}-cpp
	export AR=${CTARGET}-ar
	export NM=${CTARGET}-nm
	export RANLIB=${CTARGET}-ranlib
	export OBJCOPY=${CTARGET}-objcopy
	export STRIP=${CTARGET}-strip
	export LD=${CTARGET}-ld
	
	strip-unsupported-flags

	append-flags -nostdlib
	filter-flags -fomit-frame-pointer
	
  local emesonargs=( )
  meson_src_configure
}

src_install() {
	meson_src_install --destdir ${ED}/usr/${CTARGET}
	mv ${ED}/usr/share ${ED}/usr/${CTARGET}/usr/
}
