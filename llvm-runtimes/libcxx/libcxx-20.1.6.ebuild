# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake-multilib flag-o-matic llvm.org llvm-utils python-any-r1
inherit toolchain-funcs

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="https://libcxx.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="+clang +libcxxabi +static-libs test"
REQUIRED_USE="test? ( clang )"
RESTRICT="!test? ( test )"

RDEPEND="
	libcxxabi? (
		~llvm-runtimes/libcxxabi-${PV}[static-libs?,${MULTILIB_USEDEP}]
	)
	!libcxxabi? ( >=sys-devel/gcc-4.7:=[cxx] )
"
DEPEND="
	${RDEPEND}
	llvm-core/llvm:${LLVM_MAJOR}
"
BDEPEND="
	clang? (
		llvm-core/clang:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
	test? (
		dev-debug/gdb[python]
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=(
	runtimes libcxx{,abi} libc llvm/{cmake,utils/llvm-lit} cmake
)
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup

	if ! use libcxxabi && ! tc-is-gcc ; then
		eerror "To build ${PN} against libsupc++, you have to use gcc. Other"
		eerror "compilers are not supported. Please set CC=gcc and CXX=g++"
		eerror "and try again."
		die
	fi
	if tc-is-cross-compiler; then
		export CXXABI_ROOT="${EROOT}"
	else
		export CXXABI_ROOT="${EPREFIX}"
	fi
}

test_compiler() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c++ - \
		<<<'int main() { return 0; }' &>/dev/null
}

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	# note: we need to do this before multilib kicks in since it will
	# alter the CHOST
	local cxxabi cxxabi_incs
	if [[ ${CTARGET} == *-mingw* ]]; then
		cxxabi=libcxxabi
	elif use libcxxabi; then
		cxxabi=system-libcxxabi
		cxxabi_incs="${CXXABI_ROOT}/usr/include/c++/v1"
	else
		local gcc_inc="${CXXABI_ROOT}/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version)"
		cxxabi=libsupc++
		cxxabi_incs="${gcc_inc};${gcc_inc}/${CHOST}"
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	# link to compiler-rt
	local use_compiler_rt=OFF
	[[ $(tc-get-c-rtlib) == compiler-rt ]] && use_compiler_rt=ON

	local is_musllibc_like=$(llvm_cmake_use_musl)
	[[ ${CTARGET} == *wasi* ]] && is_musllibc_like=ON

	# bootstrap: cmake is unhappy if compiler can't link to stdlib
	local nolib_flags=( -nostdlib++ )
	if ! test_compiler && [[ "${CTARGET}" != *wasm* ]]; then
		if test_compiler "${nolib_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CXX} seems to lack runtime, trying with ${nolib_flags[*]}"
		fi
	fi

	local libdir=$(get_libdir)
	local runtimes="libcxx"
	[[ ${CTARGET} == *-mingw* ]] && runtimes="libcxxabi;libcxx"

	local enable_shared=ON
	[[ ${CTARGET} == *elf* ]] && enable_shared=OFF
	[[ ${CTARGET} == *wasi-threads* ]] && enable_shared=OFF

	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER_TARGET="${CHOST}"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_ENABLE_RUNTIMES=${runtimes}
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DLIBCXX_ENABLE_SHARED=${enable_shared}
		-DLIBCXX_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXX_CXX_ABI=${cxxabi}
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi_incs}
		# we're using our own mechanism for generating linker scripts
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=${is_musllibc_like}
		-DLIBCXX_INCLUDE_BENCHMARKS=OFF
		-DLIBCXX_INCLUDE_TESTS=$(usex test)
		-DLIBCXX_INSTALL_MODULES=ON
		-DLIBCXX_USE_COMPILER_RT=${use_compiler_rt}
		# this is broken with standalone builds, and also meaningless
		-DLIBCXXABI_USE_LLVM_UNWINDER=OFF
	)

	if tc-is-cross-compiler ; then
		mycmakeargs+=(
			-DCMAKE_CXX_COMPILER_WORKS=1
		)
		if [[ ${CHOST} == *-mingw* ]]; then
			mycmakeargs+=(
				-DLIBCXXABI_USE_COMPILER_RT=ON
				-DLIBCXXABI_ENABLE_SHARED=OFF
				-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=TRUE
			)
		fi
	fi
	if [[ "${CTARGET}" == *wasi* ]]; then
		mycmakeargs+=(
			-DCMAKE_POSITION_INDEPENDENT_CODE=ON
			-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
			-DLIBCXX_ENABLE_EXCEPTIONS=OFF
			-DLIBCXX_ENABLE_FILESYSTEM=ON
			-DLIBCXX_HAS_EXTERNAL_THREAD_API=OFF
			-DLIBCXX_HAS_WIN32_THREAD_API=OFF
			-DLIBCXX_ENABLE_TIME_ZONE_DATABASE=OFF
			-DUNIX=ON
		)
		if [[ "${CTARGET}" == *wasi*-threads ]]; then
			mycmakeargs+=(
				-DLIBCXX_ENABLE_THREADS=ON
				-DLIBCXX_HAS_PTHREAD_API=ON
			)
		else
			mycmakeargs+=(
				-DLIBCXX_ENABLE_THREADS=OFF
				-DLIBCXX_HAS_PTHREAD_API=OFF
			)
		fi
	fi
	if [[ "${CTARGET}" == *elf* ]]; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER_WORKS=1
			-DLIBCXX_ENABLE_EXCEPTIONS=ON
			-DLIBCXX_ENABLE_FILESYSTEM=OFF
			-DLIBCXX_ENABLE_THREADS=OFF
			-DLIBCXX_HAS_PTHREAD_API=OFF
			-DLIBCXX_HAS_EXTERNAL_THREAD_API=OFF
			-DLIBCXX_HAS_WIN32_THREAD_API=OFF
			-DLIBCXX_ENABLE_WIDE_CHARACTERS=OFF
			-DLIBCXX_ENABLE_RANDOM_DEVICE=OFF
			-DLIBCXX_ENABLE_LOCALIZATION=OFF
			-DLIBCXX_ENABLE_MONOTONIC_CLOCK=OFF
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
	cmake_src_compile
	if [[ ${CHOST} != *-darwin* ]] && [[ ${CHOST} != *-mingw* ]] && [[ ${CHOST} != *-wasi* ]] && [[ ${CHOST} != *elf* ]]; then
		gen_shared_ldscript
		use static-libs && gen_static_ldscript
	fi
}

multilib_src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build install-cxx-test-suite-prefix
	cp "${BUILD_DIR}"/{lib,libcxx/test-suite-install/$(get_libdir)}/libc++_shared.so || die
	if use static-libs; then
		cp "${BUILD_DIR}"/{lib,libcxx/test-suite-install/$(get_libdir)}/libc++_static.a || die
	fi
	cmake_build check-cxx
}

multilib_src_install() {
	cmake_src_install
	# since we've replaced libc++.{a,so} with ldscripts, now we have to
	# install the extra symlinks
	if [[ ${CHOST} != *-darwin* ]] && [[ ${CHOST} != *-mingw* ]] && [[ ${CHOST} != *-wasi* ]] && [[ ${CHOST} != *elf* ]]; then
		dolib.so lib/libc++_shared.so
		use static-libs && dolib.a lib/libc++_static.a
	fi
}

# Usage: deps
gen_ldscript() {
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	cat <<-END_LDSCRIPT
/* GNU ld script
   Include missing dependencies
*/
${output_format}
GROUP ( $@ )
END_LDSCRIPT
}

gen_static_ldscript() {
	# Move it first.
	mv lib/libc++{,_static}.a || die
	# Generate libc++.a ldscript for inclusion of its dependencies so that
	# clang++ -stdlib=libc++ -static works out of the box.
	local deps=(
		libc++_static.a
		$(usex libcxxabi libc++abi.a libsupc++.a)
	)
	# On Linux/glibc it does not link without libpthread or libdl. It is
	# fine on FreeBSD.
	use elibc_glibc && deps+=( libpthread.a libdl.a )

	gen_ldscript "${deps[*]}" > lib/libc++.a || die
}

gen_shared_ldscript() {
	# Move it first.
	mv lib/libc++{,_shared}.so || die
	local deps=(
		libc++_shared.so
		# libsupc++ doesn't have a shared version
		$(usex libcxxabi libc++abi.so libsupc++.a)
	)

	gen_ldscript "${deps[*]}" > lib/libc++.so || die
}
