# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	arbitrary-1.3.0
	cc-1.0.79
	compiler_builtins-0.1.92
	jobserver-0.1.26
	libc-0.2.144
	libfuzzer-sys-0.4.6
	once_cell-1.17.2
	rustc-std-workspace-core-1.0.0
"

inherit cargo

DESCRIPTION="C API for the rustc-demangle crate"
HOMEPAGE="https://github.com/alexcrichton/rustc-demangle"
SRC_URI="
	$(cargo_crate_uris ${CRATES})
	https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	cargo build -p rustc-demangle-capi --release
}

src_install() {
	doheader "${S}"/crates/capi/include/rustc_demangle.h
	dolib.a "${S}"/target/release/librustc_demangle.a
	dolib.so "${S}"/target/release/librustc_demangle.so
}
