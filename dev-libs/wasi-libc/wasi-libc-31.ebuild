# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# minimum_clang_required in wsi-sdk/cmake/wasi-sdk-sysroot.cmake
LLVM_COMPAT=( {18..22} )

inherit cmake crossdev flag-o-matic llvm-r2

DESCRIPTION="libc for WebAssembly programs built on top of WASI system calls"
HOMEPAGE="https://wasi.dev/"
SRC_URI="https://github.com/WebAssembly/${PN}/archive/wasi-sdk-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT BSD BSD-2 CC0-1.0"
SLOT="0"
IUSE="emmalloc +setjmp simd +shared"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~loong ~riscv"

DEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/lld:${LLVM_SLOT}=
	')
"
RDEPEND="${DEPEND}"
BDEPEND=""

if [[ ${CTARGET} == *p[23]* ]]; then
	BDEPEND+="
		>=dev-util/wasm-component-ld-0.5.21
		>=dev-util/wasm-tools-1.244.0
	"
fi

S="${WORKDIR}/${PN}-wasi-sdk-${PV}"

pkg_pretend() {
	target_is_not_host || die "${PN} should only be used for cross"
}

src_configure() {
	CC=clang
	CXX=clang++
	AR=llvm-ar
	NM=llvm-nm
	RANLIB=llvm-ranlib
	STRIP=llvm-strip
	einfo "Compile using $(which $CC)"
	tc-export CC CXX AR NM RANLIB STRIP
	
	# don't work with PIC or shared libraries
	filter-lto
	filter-flags '-mcpu*' '-march*' '-mtune*'
	
	local mycmakeargs=(
		-DCMAKE_C_COMPILER_WORKS=ON
		# CMake detects this based on `CMAKE_C_COMPILER` alone and when that compiler
  		# is just a bare "clang" installation then it can mistakenly deduce that this
  		# feature is supported when it's not actually supported for WASI targets.
  		# Currently `wasm-ld` does not support the linker flag for this.
		-DCMAKE_C_LINKER_DEPFILE_SUPPORTED=OFF
		-DTARGET_TRIPLE=${CTARGET}
		-DMALLOC=$(usex emmalloc emmalloc dlmalloc)
		-DBUILTINS_LIB="$(realpath $(${CTARGET}-clang --print-libgcc-file-name))"
		-DSETJMP=$(usex setjmp ON OFF)
		-DSIMD=$(usex simd ON OFF)
		-DBUILD_SHARED=$(usex shared ON OFF)
		-DWASI_SDK_VERSION="${PV}"
	)
	if [[ ${CTARGET} == *p[23]* ]]; then
	    # Always enable `-fPIC` for the `wasm32-wasip2` and `wasm32-wasip3` targets.
    	# This makes `libc.a` more flexible and usable in dynamic linking situations.
		append-cflags -fPIC
	fi
	if [[ ${CTARGET} == wasm32-wasi* ]]; then
	  	# The `wasm32-wasi` target is deprecated in clang, so ignore the deprecation warnings for now.
		append-cflags -Wno-deprecated
	fi
	cmake_src_configure
}

src_install() {
	mkdir -p "${ED}/usr/${CTARGET}/usr"
	mkdir -p "${ED}/usr/${CTARGET}/lib"
	cmake_src_install
	dosym usr/include /usr/${CTARGET}/include
	mv "${ED}/usr/include/${CTARGET}" "${ED}/usr/${CTARGET}/usr/include"
	mv "${ED}/usr/lib/${CTARGET}" "${ED}/usr/${CTARGET}/usr/lib"
	mv "${ED}/usr/share" "${ED}/usr/${CTARGET}/usr"
	dosym . /usr/${CTARGET}/usr/include/${CTARGET}
	dosym ../usr/lib /usr/${CTARGET}/lib/${CTARGET}
}
