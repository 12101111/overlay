# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.8.11
	anstream-0.6.13
	anstyle-1.0.6
	anstyle-parse-0.2.3
	anstyle-query-1.0.2
	anstyle-wincon-3.0.2
	anyhow-1.0.80
	bitflags-2.4.2
	bumpalo-3.16.0
	cfg-if-1.0.0
	clap-4.5.4
	clap_builder-4.5.2
	clap_derive-4.5.4
	clap_lex-0.7.0
	colorchoice-1.0.0
	equivalent-1.0.1
	errno-0.3.8
	fastrand-2.0.1
	hashbrown-0.14.3
	heck-0.5.0
	id-arena-2.2.1
	indexmap-2.2.3
	itoa-1.0.10
	leb128-0.2.5
	lexopt-0.3.0
	libc-0.2.153
	linux-raw-sys-0.4.13
	log-0.4.20
	memchr-2.7.2
	once_cell-1.19.0
	proc-macro2-1.0.78
	quote-1.0.35
	rustix-0.38.31
	ryu-1.0.17
	semver-1.0.22
	serde-1.0.197
	serde_derive-1.0.197
	serde_json-1.0.114
	smallvec-1.13.1
	spdx-0.10.3
	strsim-0.11.1
	syn-2.0.50
	tempfile-3.10.0
	unicode-ident-1.0.12
	unicode-width-0.1.12
	unicode-xid-0.2.4
	utf8parse-0.2.1
	version_check-0.9.4
	wasm-encoder-0.206.0
	wasm-metadata-0.206.0
	wasmparser-0.206.0
	wast-206.0.0
	wat-1.206.0
	windows-sys-0.52.0
	windows-targets-0.52.3
	windows_aarch64_gnullvm-0.52.3
	windows_aarch64_msvc-0.52.3
	windows_i686_gnu-0.52.3
	windows_i686_msvc-0.52.3
	windows_x86_64_gnu-0.52.3
	windows_x86_64_gnullvm-0.52.3
	windows_x86_64_msvc-0.52.3
	wit-component-0.206.0
	wit-parser-0.206.0
	zerocopy-0.7.32
	zerocopy-derive-0.7.32
"

inherit cargo

DESCRIPTION="Linker for wasm32-wasip2"
HOMEPAGE="https://github.com/alexcrichton/wasm-component-ld"
SRC_URI="
	https://github.com/bytecodealliance/wasm-component-ld/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="|| ( MIT Apache-2.0 Apache-2.0-with-LLVM-exceptions )"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"
