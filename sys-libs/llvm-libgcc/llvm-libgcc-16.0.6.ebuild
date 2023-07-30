# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic llvm llvm.org toolchain-funcs

DESCRIPTION="Compiler runtime library for GCC (LLVM compitable version)"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86 ~amd64-linux"
IUSE="+abi_x86_32 abi_x86_64 debug"

DEPEND="
	sys-devel/llvm:${LLVM_MAJOR}
"
BDEPEND="
	>=dev-util/cmake-3.16
	=sys-devel/clang-${LLVM_VERSION}*:${LLVM_MAJOR}
	=sys-libs/compiler-rt-${LLVM_VERSION}*
	=sys-libs/llvm-libunwind-${LLVM_VERSION}*
	!!sys-devel/gcc
"

LLVM_COMPONENTS=( compiler-rt cmake llvm/cmake llvm-libgcc )
llvm.org_set_globals

src_configure() {
	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	if ! tc-is-clang ; then
		die "this package is for clang only system"
	fi

	strip-unsupported-flags

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/"

		-DCOMPILER_RT_INCLUDE_TESTS=OFF
		-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
		-DCOMPILER_RT_BUILD_MEMPROF=OFF
		-DCOMPILER_RT_BUILD_ORC=OFF
		-DCOMPILER_RT_BUILD_PROFILE=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_BUILD_XRAY=OFF
		-DCOMPILER_RT_BUILTINS_HIDE_SYMBOLS=OFF
	)

	if use amd64; then
		mycmakeargs+=(
			-DCAN_TARGET_i386=$(usex abi_x86_32)
			-DCAN_TARGET_x86_64=$(usex abi_x86_64)
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	shopt -s nullglob
	$(tc-getCC) -E -xc ${WORKDIR}/llvm-libgcc/lib/gcc_s.ver -o ${BUILD_DIR}/gcc_s.ver || die
	$(tc-getCC) -nostdlib -Wl,-znodelete,-zdefs -Wl,--version-script,${BUILD_DIR}/gcc_s.ver \
		-Wl,--whole-archive ${EPREFIX}/usr/lib/libunwind.a ${BUILD_DIR}/lib/linux/libclang_rt.builtins*.a \
		-Wl,-soname,libgcc_s.so.1.0 -lc -shared -o ${BUILD_DIR}/libgcc_s.so.1.0
	shopt -u nullglob
}

src_install() {
	shopt -s nullglob
	dolib.so ${BUILD_DIR}/libgcc_s.so.1.0
	newlib.a ${BUILD_DIR}/lib/linux/libclang_rt.builtins*.a libgcc.a
	dosym libgcc_s.so.1.0 /usr/lib/libgcc_s.so.1
	dosym libgcc_s.so.1 /usr/lib/libgcc_s.so
	dosym libunwind.a /usr/lib/libgcc_eh.a
	shopt -u nullglob
}
