# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="libc for WebAssembly programs built on top of WASI system calls"
HOMEPAGE="https://wasi.dev/"
EGIT_REPO_URI="https://github.com/WebAssembly/wasi-libc.git"

LICENSE="Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT BSD-2 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	sys-devel/clang
	sys-devel/lld
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}"/ignore-macro.patch )

src_compile() {
	export CC=clang
	emake SYSROOT="${S}/sysroot"
}

src_install() {
	mkdir -p "${ED}/opt/"
	cp -r "${S}/sysroot" "${ED}/opt/wasm32-wasi"
}
