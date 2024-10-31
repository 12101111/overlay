# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake-multilib flag-o-matic llvm.org llvm-utils python-any-r1
inherit toolchain-funcs

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="+clang +static-libs test"
REQUIRED_USE="test? ( clang )"
RESTRICT="!test? ( test )"

# in 15.x, cxxabi.h is moving from libcxx to libcxxabi
RDEPEND+="
	!<sys-libs/libcxx-15
"
DEPEND="
	${RDEPEND}
	sys-devel/llvm:${LLVM_MAJOR}
"
BDEPEND="
	clang? (
		sys-devel/clang:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( runtimes libcxx{abi,} llvm/cmake cmake )
LLVM_TEST_COMPONENTS=( llvm/utils/llvm-lit )
llvm.org_set_globals
[[ ${CTARGET} == *-mingw* ]] && IS_MINGW=true || IS_MINGW=false

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

multilib_src_configure() {
	if $IS_MINGW ; then
		return 0
	fi
	llvm_prepend_path "${LLVM_MAJOR}"

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	# link to compiler-rt
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == compiler-rt ]] && use_compiler_rt=ON

	local is_musllibc_like=$(usex elibc_musl)
	[[ ${CTARGET} == *wasi* ]] && is_musllibc_like=ON

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER_TARGET="${CHOST}"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES="libcxxabi;libcxx"
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=ON
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		-DLIBCXXABI_USE_COMPILER_RT=${use_compiler_rt}

		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
		# this is broken with standalone builds, and also meaningless
		-DLIBCXXABI_USE_LLVM_UNWINDER=OFF

		-DLIBCXX_LIBDIR_SUFFIX=
		-DLIBCXX_ENABLE_SHARED=ON
		-DLIBCXX_ENABLE_STATIC=OFF
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=${is_musllibc_like}
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
	)
	if tc-is-cross-compiler ; then
		mycmakeargs+=(
			-DCMAKE_CXX_COMPILER_WORKS=1
		)
	fi
	if [[ "${CTARGET}" == *wasi* ]]; then
		mycmakeargs+=(
			-DCMAKE_POSITION_INDEPENDENT_CODE=ON
			-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
			-DLIBCXX_ENABLE_EXCEPTIONS=OFF
			-DLIBCXX_ENABLE_FILESYSTEM=ON
			-DLIBCXXABI_ENABLE_EXCEPTIONS=OFF
			-DLIBCXXABI_SILENT_TERMINATE=ON
			-DLIBCXX_HAS_EXTERNAL_THREAD_API=OFF
			-DLIBCXX_HAS_WIN32_THREAD_API=OFF
			-DLIBCXXABI_HAS_EXTERNAL_THREAD_API=OFF
			-DLIBCXXABI_HAS_WIN32_THREAD_API=OFF
			-DUNIX=ON
		)
		if [[ "${CTARGET}" == *wasi*-threads ]]; then
			mycmakeargs+=(
				-DLIBCXX_ENABLE_THREADS=ON
				-DLIBCXX_HAS_PTHREAD_API=ON
				-DLIBCXXABI_ENABLE_THREADS=ON
			)
		else
			mycmakeargs+=(
				-DLIBCXX_ENABLE_THREADS=OFF
				-DLIBCXX_HAS_PTHREAD_API=OFF
				-DLIBCXXABI_ENABLE_THREADS=OFF
				-DLIBCXXABI_HAS_PTHREAD_API=OFF
			)
		fi
	fi
	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi
	cmake_src_configure
}

multilib_src_compile() {
	if $IS_MINGW ; then
		return 0
	fi
	cmake_build cxxabi
}

multilib_src_test() {
	if $IS_MINGW ; then
		return 0
	fi
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-cxxabi
}

multilib_src_install() {
	if $IS_MINGW ; then
		return 0
	fi
	DESTDIR="${D}" cmake_build install-cxxabi
}
