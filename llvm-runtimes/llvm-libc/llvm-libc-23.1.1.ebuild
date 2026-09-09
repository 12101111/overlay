# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 23 )

inherit cmake llvm-r1

DESCRIPTION="LLVM's libc implementation (Math overlay components only)"
HOMEPAGE="https://llvm.org"
SRC_URI="https://github.com{PV}/llvm-project-${PV}.src.tar.xz"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="0"
#KEYWORDS="~amd64 ~arm64"

S="${WORKDIR}/llvm-project-${PV}.src/runtimes"

# Target dependencies mapped to the new llvm-runtimes/* category
RDEPEND="
	llvm-runtimes/compiler-rt:${LLVM_COMPAT}
"
DEPEND="${RDEPEND}"

# Host build tools pulled from llvm-core/*, resolved via LLVM_SLOT
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/lld:${LLVM_SLOT}
	')
"

src_configure() {
	local mycmakeargs=(
		-DLLVM_ENABLE_RUNTIMES="libc"
		-DCMAKE_C_COMPILER=clang
		-DCMAKE_CXX_COMPILER=clang++

		# Overlay mode prevents overwriting your system musl installation
		-DLLVM_LIBC_FULL_BUILD=OFF

		# Safe isolated installation path under Gentoo's standard LLVM root
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_SLOT}/llvm-libc"
	)
	cmake_src_configure
}

src_compile() {
	cmake_build libc
}

src_install() {
	DESTDIR="${D}" cmake_build install-libc
}
