# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash@0.8.11
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.89
	bitflags@2.6.0
	bumpalo@3.16.0
	cfg-if@1.0.0
	clap@4.5.20
	clap_builder@4.5.20
	clap_derive@4.5.18
	clap_lex@0.7.2
	colorchoice@1.0.2
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.1.1
	hashbrown@0.14.5
	hashbrown@0.15.0
	heck@0.5.0
	id-arena@2.2.1
	indexmap@2.6.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	leb128@0.2.5
	lexopt@0.3.0
	libc@0.2.159
	linux-raw-sys@0.4.14
	log@0.4.22
	memchr@2.7.4
	once_cell@1.20.2
	proc-macro2@1.0.87
	quote@1.0.37
	rustix@0.38.37
	ryu@1.0.18
	semver@1.0.23
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	smallvec@1.13.2
	spdx@0.10.6
	strsim@0.11.1
	syn@2.0.79
	tempfile@3.13.0
	unicode-ident@1.0.13
	unicode-width@0.1.14
	unicode-xid@0.2.6
	utf8parse@0.2.2
	version_check@0.9.5
	wasi-preview1-component-adapter-provider@24.0.0
	wasm-encoder@0.219.0
	wasm-metadata@0.219.0
	wasmparser@0.219.0
	wast@219.0.0
	wat@1.219.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	wit-component@0.219.0
	wit-parser@0.219.0
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo

DESCRIPTION="Linker for wasm32-wasip2"
HOMEPAGE="https://github.com/bytecodealliance/wasm-component-ld"
SRC_URI="
	https://github.com/bytecodealliance/wasm-component-ld/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="|| ( Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong"
RESTRICT="mirror"
