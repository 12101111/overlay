# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	anyhow@1.0.95
	bitflags@2.8.0
	bumpalo@3.16.0
	cfg-if@1.0.0
	clap@4.5.27
	clap_builder@4.5.27
	clap_derive@4.5.24
	clap_lex@0.7.4
	colorchoice@1.0.3
	displaydoc@0.2.5
	equivalent@1.0.1
	errno@0.3.10
	fastrand@2.3.0
	foldhash@0.1.4
	form_urlencoded@1.2.1
	getrandom@0.2.15
	hashbrown@0.15.2
	heck@0.5.0
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	id-arena@2.2.1
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@2.7.1
	is_terminal_polyfill@1.70.1
	itoa@1.0.14
	leb128@0.2.5
	lexopt@0.3.0
	libc@0.2.169
	linux-raw-sys@0.4.15
	litemap@0.7.4
	log@0.4.25
	memchr@2.7.4
	once_cell@1.20.2
	percent-encoding@2.3.1
	proc-macro2@1.0.93
	quote@1.0.38
	rustix@0.38.43
	ryu@1.0.18
	semver@1.0.25
	serde@1.0.217
	serde_derive@1.0.217
	serde_json@1.0.137
	smallvec@1.13.2
	spdx@0.10.8
	stable_deref_trait@1.2.0
	strsim@0.11.1
	syn@2.0.96
	synstructure@0.13.1
	tempfile@3.15.0
	tinystr@0.7.6
	unicode-ident@1.0.14
	unicode-width@0.2.0
	unicode-xid@0.2.6
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	utf8parse@0.2.2
	wasi-preview1-component-adapter-provider@29.0.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-encoder@0.223.0
	wasm-metadata@0.223.0
	wasmparser@0.223.0
	wast@223.0.0
	wat@1.223.0
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
	winsplit@0.1.0
	wit-component@0.223.0
	wit-parser@0.223.0
	write16@1.0.0
	writeable@0.5.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zerovec-derive@0.10.3
	zerovec@0.10.4
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
