# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.102
	bitflags@2.13.0
	bumpalo@3.20.3
	cfg-if@1.0.4
	clap@4.6.1
	clap_builder@4.6.0
	clap_derive@4.6.1
	clap_lex@1.1.0
	colorchoice@1.0.5
	equivalent@1.0.2
	errno@0.3.14
	fastrand@2.4.1
	foldhash@0.1.5
	foldhash@0.2.0
	getrandom@0.4.2
	hashbrown@0.15.5
	hashbrown@0.17.1
	heck@0.5.0
	id-arena@2.3.0
	indexmap@2.14.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	leb128fmt@0.1.0
	lexopt@0.3.2
	libc@0.2.186
	linux-raw-sys@0.12.1
	log@0.4.32
	memchr@2.8.1
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	prettyplease@0.2.37
	proc-macro2@1.0.106
	quote@1.0.45
	r-efi@6.0.0
	rustix@1.1.4
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.150
	strsim@0.11.1
	syn@2.0.117
	tempfile@3.27.0
	unicode-ident@1.0.24
	unicode-width@0.2.2
	unicode-xid@0.2.6
	utf8parse@0.2.2
	wasi-preview1-component-adapter-provider@44.0.2
	wasip2@1.0.1+wasi-0.2.4
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-encoder@0.244.0
	wasm-encoder@0.252.0
	wasm-metadata@0.244.0
	wasm-metadata@0.252.0
	wasmparser@0.244.0
	wasmparser@0.252.0
	wast@252.0.0
	wat@1.252.0
	windows-link@0.2.1
	windows-sys@0.61.2
	winsplit@0.1.0
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.46.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-component@0.252.0
	wit-parser@0.244.0
	wit-parser@0.252.0
	zmij@1.0.21
"

inherit cargo

DESCRIPTION="Linker for wasm32-wasip2/p3"
HOMEPAGE="https://github.com/bytecodealliance/wasm-component-ld"
SRC_URI="
	https://github.com/bytecodealliance/wasm-component-ld/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="|| ( Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0 ZLIB
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong"
RESTRICT="mirror"
