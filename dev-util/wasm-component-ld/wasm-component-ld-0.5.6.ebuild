# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.8.11
	anstream-0.6.15
	anstyle-1.0.8
	anstyle-parse-0.2.5
	anstyle-query-1.1.1
	anstyle-wincon-3.0.4
	anyhow-1.0.86
	bitflags-2.6.0
	bumpalo-3.16.0
	cfg-if-1.0.0
	clap-4.5.12
	clap_builder-4.5.12
	clap_derive-4.5.11
	clap_lex-0.7.2
	colorchoice-1.0.2
	equivalent-1.0.1
	errno-0.3.9
	fastrand-2.1.0
	hashbrown-0.14.5
	heck-0.5.0
	id-arena-2.2.1
	indexmap-2.2.6
	is_terminal_polyfill-1.70.1
	itoa-1.0.11
	leb128-0.2.5
	lexopt-0.3.0
	libc-0.2.155
	linux-raw-sys-0.4.14
	log-0.4.22
	memchr-2.7.4
	once_cell-1.19.0
	proc-macro2-1.0.86
	quote-1.0.36
	rustix-0.38.34
	ryu-1.0.18
	semver-1.0.23
	serde-1.0.204
	serde_derive-1.0.204
	serde_json-1.0.121
	smallvec-1.13.2
	spdx-0.10.6
	strsim-0.11.1
	syn-2.0.72
	tempfile-3.10.1
	unicode-ident-1.0.12
	unicode-width-0.1.13
	unicode-xid-0.2.4
	utf8parse-0.2.2
	version_check-0.9.5
	wasi-preview1-component-adapter-provider-23.0.1
	wasm-encoder-0.215.0
	wasm-metadata-0.215.0
	wasmparser-0.215.0
	wast-215.0.0
	wat-1.215.0
	windows-sys-0.52.0
	windows-targets-0.52.6
	windows_aarch64_gnullvm-0.52.6
	windows_aarch64_msvc-0.52.6
	windows_i686_gnu-0.52.6
	windows_i686_gnullvm-0.52.6
	windows_i686_msvc-0.52.6
	windows_x86_64_gnu-0.52.6
	windows_x86_64_gnullvm-0.52.6
	windows_x86_64_msvc-0.52.6
	wit-component-0.215.0
	wit-parser-0.215.0
	zerocopy-0.7.35
	zerocopy-derive-0.7.35
"

inherit cargo

DESCRIPTION="Linker for wasm32-wasip2"
HOMEPAGE="https://github.com/bytecodealliance/wasm-component-ld"
SRC_URI="
	https://github.com/bytecodealliance/wasm-component-ld/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="|| ( MIT Apache-2.0 Apache-2.0-with-LLVM-exceptions )"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"
