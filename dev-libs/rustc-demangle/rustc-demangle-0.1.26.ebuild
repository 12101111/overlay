# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	arbitrary@1.2.0
	cc@1.0.77
	compiler_builtins@0.1.84
	jobserver@0.1.25
	libc@0.2.137
	libfuzzer-sys@0.4.5
	once_cell@1.16.0
	rustc-std-workspace-core@1.0.0
"

inherit cargo

DESCRIPTION="Rust compiler symbol demangling."
HOMEPAGE="https://github.com/rust-lang/rustc-demangle"
SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/rust-lang/${PN}/archive/${PN}-v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${PN}-v${PV}"

src_compile() {
	cargo build -p rustc-demangle-capi --release
}

src_install() {
	doheader "${S}"/crates/capi/include/rustc_demangle.h
	dolib.a "${S}"/target/release/librustc_demangle.a
	dolib.so "${S}"/target/release/librustc_demangle.so
}
