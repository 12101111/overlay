# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit crossdev git-r3

DESCRIPTION="libc for WebAssembly programs built on top of WASI system calls"
HOMEPAGE="https://wasi.dev/"
EGIT_REPO_URI="https://github.com/WebAssembly/wasi-libc.git"

LICENSE="Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT BSD-2 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	>=sys-devel/clang-18.1.4
	>=sys-devel/lld-18.1.4
	>=dev-util/wasm-component-ld-0.3
"
RDEPEND="${DEPEND}"
BDEPEND=""

pkg_pretend() {
	target_is_not_host || die "${PN} should only be used for cross"
}

src_compile() {
	snapshot=p1
	if [[ ${CTARGET} == *p1* ]]; then
		snapshot=p1
	elif [[ ${CTARGET} == *p2* ]]; then
		snapshot=p2
	fi
	emake CC=clang \
		AR=llvm-ar \
		NM=llvm-nm \
		RANLIB=llvm-ranlib \
		SYSROOT="${S}/sysroot" \
		WASI_SNAPSHOT=$snapshot \
		TARGET_TRIPLE=${CTARGET} \
		BUILTINS_LIB="$(clang --print-resource-dir)/lib/${CTARGET}/libclang_rt.builtins.a" \
		default libc_so
}

src_install() {
	mkdir -p "${ED}/usr/${CTARGET}/usr"
	dosym usr/lib /usr/${CTARGET}/lib
	dosym usr/include /usr/${CTARGET}/include
	cp -r "${S}/sysroot/include/${CTARGET}" "${ED}/usr/${CTARGET}/usr/include"
	cp -r "${S}/sysroot/lib/${CTARGET}" "${ED}/usr/${CTARGET}/usr/lib"
	dosym . /usr/${CTARGET}/usr/include/${CTARGET}
	dosym . /usr/${CTARGET}/usr/lib/${CTARGET}
}
