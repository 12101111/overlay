# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	anstream@0.6.20
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.11
	anyhow@1.0.99
	bitflags@2.9.3
	bumpalo@3.19.0
	cfg-if@1.0.3
	clap@4.5.45
	clap_builder@4.5.44
	clap_derive@4.5.45
	clap_lex@0.7.5
	colorchoice@1.0.4
	equivalent@1.0.2
	errno@0.3.13
	fastrand@2.3.0
	foldhash@0.1.5
	getrandom@0.3.3
	hashbrown@0.15.5
	heck@0.5.0
	id-arena@2.2.1
	indexmap@2.11.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.15
	leb128fmt@0.1.0
	lexopt@0.3.1
	libc@0.2.175
	linux-raw-sys@0.9.4
	log@0.4.27
	memchr@2.7.5
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	proc-macro2@1.0.101
	quote@1.0.40
	r-efi@5.3.0
	rustix@1.0.8
	ryu@1.0.20
	semver@1.0.26
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.143
	strsim@0.11.1
	syn@2.0.106
	tempfile@3.21.0
	unicode-ident@1.0.18
	unicode-width@0.2.1
	unicode-xid@0.2.6
	utf8parse@0.2.2
	wasi-preview1-component-adapter-provider@36.0.1
	wasi@0.14.2+wasi-0.2.4
	wasm-encoder@0.237.0
	wasm-metadata@0.237.0
	wasmparser@0.237.0
	wast@237.0.0
	wat@1.237.0
	windows-link@0.1.3
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-targets@0.52.6
	windows-targets@0.53.3
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.0
	winsplit@0.1.0
	wit-bindgen-rt@0.39.0
	wit-component@0.237.0
	wit-parser@0.237.0
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
	Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0 ZLIB
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong"
RESTRICT="mirror"
