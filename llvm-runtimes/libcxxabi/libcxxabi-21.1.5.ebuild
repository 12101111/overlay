# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake-multilib crossdev flag-o-matic llvm.org llvm-utils
inherit python-any-r1 toolchain-funcs

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="+clang +static-libs test"
REQUIRED_USE="test? ( clang )"
RESTRICT="!test? ( test )"

DEPEND="
	${RDEPEND}
	llvm-core/llvm:${LLVM_MAJOR}
"
BDEPEND="
	clang? (
		llvm-core/clang:${LLVM_MAJOR}
		llvm-core/clang-linker-config:${LLVM_MAJOR}
		llvm-runtimes/clang-rtlib-config:${LLVM_MAJOR}
		llvm-runtimes/clang-unwindlib-config:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( runtimes libcxx{abi,} llvm/cmake cmake )
LLVM_TEST_COMPONENTS=(
	libc llvm/include/llvm/{Demangle,Testing} llvm/utils/llvm-lit
)
llvm.org_set_globals
[[ ${CTARGET} == *-mingw* ]] && IS_MINGW=true || IS_MINGW=false

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

test_compiler() {
	target_is_not_host && return
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c - \
		<<<'int main() { return 0; }' &>/dev/null
}

multilib_src_configure() {
	if $IS_MINGW ; then
		return 0
	fi
	# Workaround for bgo #961153.
	# TODO: Fix the multilib.eclass, so it sets CTARGET properly.
	if ! is_crosspkg; then
		export CTARGET=${CHOST}
	fi

	if use clang; then
		llvm_prepend_path -b "${LLVM_MAJOR}"
		local -x CC=${CTARGET}-clang-${LLVM_MAJOR}
		local -x CXX=${CTARGET}-clang++-${LLVM_MAJOR}
		strip-unsupported-flags

		# The full clang configuration might not be ready yet. Use the partial
		# configuration of components that libunwind depends on.
		#
		local flags=(
			--config="${ESYSROOT}"/etc/clang/"${LLVM_MAJOR}"/gentoo-{rtlib,unwindlib,linker}.cfg
		)
		local -x CFLAGS="${CFLAGS} ${flags[@]}"
		local -x CXXFLAGS="${CXXFLAGS} ${flags[@]}"
		local -x LDFLAGS="${LDFLAGS} ${flags[@]}"
	fi

	local nostdlib_flags=( -nostdlib++ )
	if ! test_compiler && test_compiler "${nostdlib_flags[@]}"; then
		local -x LDFLAGS="${LDFLAGS} ${nostdlib_flags[*]}"
		ewarn "${CXX} seems to lack stdlib, trying with ${nostdlib_flags[*]}"
	fi

	# link to compiler-rt
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == compiler-rt ]] && use_compiler_rt=ON

	local is_musllibc_like=$(llvm_cmake_use_musl)
	[[ ${CTARGET} == *wasi* ]] && is_musllibc_like=ON

	local enable_shared=ON
	[[ ${CTARGET} == *elf* ]] && enable_shared=OFF
	[[ ${CTARGET} == *wasi-threads* ]] && enable_shared=OFF

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DCMAKE_CXX_COMPILER_TARGET="${CTARGET}"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES="libcxxabi;libcxx"
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=${enable_shared}
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		-DLIBCXXABI_USE_COMPILER_RT=${use_compiler_rt}

		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
		# this is broken with standalone builds, and also meaningless
		-DLIBCXXABI_USE_LLVM_UNWINDER=OFF

		-DLIBCXX_LIBDIR_SUFFIX=
		-DLIBCXX_ENABLE_SHARED=${enable_shared}
		-DLIBCXX_ENABLE_STATIC=OFF
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=${is_musllibc_like}
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
	)
	if is_crosspkg; then
		mycmakeargs+=(
			# Without this, the compiler will compile a test program
			# and fail due to no builtins.
			-DCMAKE_C_COMPILER_WORKS=1
			-DCMAKE_CXX_COMPILER_WORKS=1
			# Install inside the cross sysroot.
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/${CTARGET}/usr"
		)
	elif tc-is-cross-compiler ; then
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
			-DLIBCXX_ENABLE_THREADS=ON
			-DLIBCXX_HAS_PTHREAD_API=ON
			-DLIBCXXABI_ENABLE_THREADS=ON
			-DLIBCXXABI_HAS_PTHREAD_API=ON
			-DUNIX=ON
		)
	fi
  	if [[ "${CTARGET}" == *elf* ]]; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER_WORKS=1
			-DLIBCXXABI_BAREMETAL=ON
			-DLIBCXX_ENABLE_EXCEPTIONS=ON
			-DLIBCXX_ENABLE_FILESYSTEM=OFF
			-DLIBCXX_ENABLE_THREADS=OFF
			-DLIBCXX_HAS_PTHREAD_API=OFF
			-DLIBCXXABI_ENABLE_THREADS=OFF
			-DLIBCXXABI_HAS_PTHREAD_API=OFF
			-DLIBCXX_HAS_EXTERNAL_THREAD_API=OFF
			-DLIBCXX_HAS_WIN32_THREAD_API=OFF
			-DLIBCXXABI_HAS_EXTERNAL_THREAD_API=OFF
			-DLIBCXXABI_HAS_WIN32_THREAD_API=OFF
			-DLIBCXX_ENABLE_WIDE_CHARACTERS=OFF
			-DLIBCXX_ENABLE_RANDOM_DEVICE=OFF
			-DLIBCXX_ENABLE_LOCALIZATION=OFF
		)
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
