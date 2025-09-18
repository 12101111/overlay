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
	
  local emesonargs=( -Dmultilib=false )
  meson_src_configure
}

src_install() {
	meson_src_install --destdir ${ED}/usr/${CTARGET}
	mv ${ED}/usr/share ${ED}/usr/${CTARGET}/usr/
	if [[ ${CTARGET} == riscv64* ]]; then
		elf_header=$(llvm-readelf -h "${ED}/usr/${CTARGET}/usr/lib/crt0.o")
		flags_info=$(echo "$elf_header"| grep 'Flags:' | tr -d ',')
		flags_val=$(echo "$flags_info" | grep -o '0x[0-9a-fA-F]*' | head -n1)
		flags_dec=$((flags_val))
		float_abi_mask=$((flags_dec & 0x6))
		if [[ $float_abi_mask == 4 ]]; then
			mkdir -p "${ED}/usr/${CTARGET}/rv64imafdc/lp64d"
			dosym -r /usr/${CTARGET}/usr/include /usr/${CTARGET}/rv64imafdc/lp64d/include
			dosym -r /usr/${CTARGET}/usr/lib /usr/${CTARGET}/rv64imafdc/lp64d/lib
		else
			mkdir -p "${ED}/usr/${CTARGET}/rv64imac/lp64"
			dosym -r /usr/${CTARGET}/usr/include /usr/${CTARGET}/rv64imac/lp64/include
			dosym -r /usr/${CTARGET}/usr/lib /usr/${CTARGET}/rv64imac/lp64/lib
		fi
	fi
  if [[ ${CTARGET} == riscv32* ]]; then
		elf_header=$(llvm-readelf -h "${ED}/usr/${CTARGET}/usr/lib/crt0.o")
		flags_info=$(echo "$elf_header"| grep 'Flags:' | tr -d ',')
		flags_val=$(echo "$flags_info" | grep -o '0x[0-9a-fA-F]*' | head -n1)
		flags_dec=$((flags_val))
		float_abi_mask=$((flags_dec & 0x6))
		case $float_abi_mask in
		4)
			mkdir -p "${ED}/usr/${CTARGET}/rv32imafdc/ilp32d"
			dosym -r /usr/${CTARGET}/usr/include /usr/${CTARGET}/rv32imafdc/ilp32d/include
			dosym -r /usr/${CTARGET}/usr/lib /usr/${CTARGET}/rv32imafdc/ilp32d/lib
			;;
		2) 
			mkdir -p "${ED}/usr/${CTARGET}/rv32imafc/ilp32f"
			dosym -r /usr/${CTARGET}/usr/include /usr/${CTARGET}/rv32imafc/ilp32f/include
			dosym -r /usr/${CTARGET}/usr/lib /usr/${CTARGET}/rv32imafc/ilp32f/lib
			;;
		0)
			mkdir -p "${ED}/usr/${CTARGET}/rv32imac/ilp32"
			dosym -r /usr/${CTARGET}/usr/include /usr/${CTARGET}/rv32imac/ilp32/include
			dosym -r /usr/${CTARGET}/usr/lib /usr/${CTARGET}/rv32imac/ilp32/lib
		;;
		esac
  fi
}
