# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake crossdev flag-o-matic llvm.org llvm-utils python-any-r1
inherit toolchain-funcs

DESCRIPTION="Compiler runtime library for clang, compatible with libgcc_s"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86 ~amd64-linux"
IUSE="debug test"

DEPEND="
	~llvm-runtimes/compiler-rt-${LLVM_VERSION}
	~llvm-runtimes/libunwind-${LLVM_VERSION}[static-libs]"
RDEPEND="
	${DEPEND}
	!sys-devel/gcc
"
BDEPEND="
	llvm-core/clang:${LLVM_MAJOR}
	test? (
		$(python_gen_any_dep ">=dev-python/lit-15[\${PYTHON_USEDEP}]")
		=llvm-core/clang-${LLVM_VERSION}*:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
"

LLVM_COMPONENTS=( compiler-rt cmake llvm/cmake llvm-libgcc )
LLVM_TEST_COMPONENTS=( llvm/include/llvm/TargetParser )
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version ">=dev-python/lit-15[${PYTHON_USEDEP}]"
}

pkg_setup() {
	if target_is_not_host || tc-is-cross-compiler ; then
		# strips vars like CFLAGS="-march=x86_64-v3" for non-x86 architectures
		CHOST=${CTARGET} strip-unsupported-flags
		# overrides host docs otherwise
		DOCS=()
	fi
	python-any-r1_pkg_setup
}

src_configure() {
	# We need to build a separate copy of compiler-rt, because we need to disable the
	# COMPILER_RT_BUILTINS_HIDE_SYMBOLS option - compatibility with libgcc requires
	# visibility of all symbols.

	llvm_prepend_path "${LLVM_MAJOR}"

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

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		-DCOMPILER_RT_BUILD_CRT=OFF
		-DCOMPILER_RT_BUILD_CTX_PROFILE=OFF
		-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
		-DCOMPILER_RT_BUILD_MEMPROF=OFF
		-DCOMPILER_RT_BUILD_ORC=OFF
		-DCOMPILER_RT_BUILD_PROFILE=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_BUILD_XRAY=OFF

		-DCOMPILER_RT_BUILTINS_HIDE_SYMBOLS=OFF

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	# disable building non-native runtimes since we don't do multilib
	if use amd64; then
		mycmakeargs+=(
			-DCAN_TARGET_i386=OFF
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"

			-DCOMPILER_RT_TEST_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang++"
		)
	fi

	if is_crosspkg || tc-is-cross-compiler; then
		# Needed to target built libc headers
		export CFLAGS="${CFLAGS} -isystem /usr/${CTARGET}/usr/include"
		mycmakeargs+=(
			-DCMAKE_ASM_COMPILER_TARGET="${CTARGET}"
			-DCMAKE_C_COMPILER_TARGET="${CTARGET}"
			-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	shopt -s nullglob
	$(tc-getCC) ${CFLAGS} -E -xc ${WORKDIR}/llvm-libgcc/gcc_s.ver.in -o ${BUILD_DIR}/gcc_s.ver || die
	local LIBROOT=${EPREFIX}/usr
	if tc-is-cross-compiler; then
		LIBROOT=${LIBROOT}/${CTARGET}/usr
	fi
	$(tc-getCC) ${LDFLAGS} -nostdlib -Wl,-znodelete,-zdefs -Wl,--version-script,${BUILD_DIR}/gcc_s.ver \
		-Wl,--whole-archive ${LIBROOT}/lib/libunwind.a ${BUILD_DIR}/lib/linux/libclang_rt.builtins*.a \
		-Wl,-soname,libgcc_s.so.1.0 -lc -shared -o ${BUILD_DIR}/libgcc_s.so.1.0 || die
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
