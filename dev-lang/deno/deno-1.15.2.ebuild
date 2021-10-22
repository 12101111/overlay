# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python2_7)
PYTHON_REQ_USE="xml"

CRATES="
	Inflector-0.11.4
	abort_on_panic-2.0.0
	adler-1.0.2
	aes-0.7.5
	ahash-0.4.7
	ahash-0.7.4
	aho-corasick-0.7.18
	alloc-no-stdlib-2.0.3
	alloc-stdlib-0.2.1
	ansi_term-0.11.0
	ansi_term-0.12.1
	anyhow-1.0.44
	arrayvec-0.5.2
	arrayvec-0.7.1
	ash-0.33.3+1.2.191
	ast_node-0.7.3
	async-compression-0.3.8
	async-stream-0.3.2
	async-stream-impl-0.3.2
	async-trait-0.1.51
	atty-0.2.14
	auto_impl-0.4.1
	autocfg-0.1.7
	autocfg-1.0.1
	base64-0.11.0
	base64-0.13.0
	bencher-0.1.5
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.2.1
	block-0.1.6
	block-buffer-0.9.0
	block-modes-0.8.1
	block-padding-0.2.1
	brotli-3.3.2
	brotli-decompressor-2.3.2
	build_const-0.2.2
	bumpalo-3.7.1
	byteorder-1.4.3
	bytes-1.1.0
	cc-1.0.71
	cfg-if-0.1.10
	cfg-if-1.0.0
	cfg_aliases-0.1.1
	chrono-0.4.19
	cipher-0.3.0
	clap-2.33.3
	clipboard-win-4.2.1
	cloudabi-0.1.0
	codespan-reporting-0.11.1
	const-oid-0.6.1
	convert_case-0.4.0
	copyless-0.1.5
	core-foundation-0.9.1
	core-foundation-sys-0.8.2
	core-graphics-types-0.1.1
	cpufeatures-0.2.1
	crc-1.8.1
	crc32fast-1.2.1
	crossbeam-channel-0.5.1
	crossbeam-utils-0.8.5
	crypto-bigint-0.2.10
	crypto-mac-0.11.1
	ctor-0.1.20
	d3d12-0.4.1
	darling-0.10.2
	darling_core-0.10.2
	darling_macro-0.10.2
	dashmap-4.0.2
	data-encoding-2.3.2
	data-url-0.1.0
	deno-libffi-0.0.7
	deno-libffi-sys-0.0.7
	deno_ast-0.3.0
	deno_doc-0.16.0
	deno_graph-0.7.0
	deno_lint-0.17.0
	der-0.4.4
	derive_more-0.99.16
	diff-0.1.12
	digest-0.9.0
	dissimilar-1.0.3
	dlopen-0.1.8
	dlopen_derive-0.1.4
	dprint-core-0.46.4
	dprint-plugin-json-0.13.0
	dprint-plugin-markdown-0.10.0
	dprint-plugin-typescript-0.57.4
	dprint-swc-ecma-ast-view-0.39.0
	ecdsa-0.12.4
	either-1.6.1
	elliptic-curve-0.10.6
	encoding_rs-0.8.28
	endian-type-0.1.2
	enum-as-inner-0.3.3
	enum_kind-0.2.1
	env_logger-0.8.4
	errno-0.1.8
	error-code-2.3.0
	fallible-iterator-0.2.0
	fallible-streaming-iterator-0.1.9
	fancy-regex-0.7.1
	fd-lock-3.0.0
	ff-0.10.1
	filetime-0.2.15
	fixedbitset-0.2.0
	fixedbitset-0.4.0
	flaky_test-0.1.0
	flate2-1.0.22
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	from_variant-0.1.3
	fs3-0.5.0
	fsevent-sys-4.0.0
	fslock-0.1.8
	futures-0.3.17
	futures-channel-0.3.17
	futures-core-0.3.17
	futures-executor-0.3.17
	futures-io-0.3.17
	futures-macro-0.3.17
	futures-sink-0.3.17
	futures-task-0.3.17
	futures-util-0.3.17
	fwdansi-1.1.0
	fxhash-0.2.1
	generic-array-0.14.4
	getrandom-0.1.16
	getrandom-0.2.3
	glow-0.11.0
	gpu-alloc-0.5.2
	gpu-alloc-types-0.2.0
	gpu-descriptor-0.2.1
	gpu-descriptor-types-0.1.1
	group-0.10.0
	h2-0.3.6
	hashbrown-0.9.1
	hashbrown-0.11.2
	hashlink-0.7.0
	heck-0.3.3
	hermit-abi-0.1.19
	hmac-0.11.0
	hostname-0.3.1
	http-0.2.5
	http-body-0.4.3
	httparse-1.5.1
	httpdate-1.0.1
	humantime-2.1.0
	hyper-0.14.13
	hyper-rustls-0.22.1
	ident_case-1.0.1
	idna-0.2.3
	if_chain-1.0.2
	import_map-0.3.3
	indexmap-1.6.2
	inotify-0.9.5
	inotify-sys-0.1.5
	inplace_it-0.3.3
	input_buffer-0.4.0
	instant-0.1.11
	ipconfig-0.2.2
	ipnet-2.3.1
	is-macro-0.1.9
	itoa-0.4.8
	js-sys-0.3.49
	jsonc-parser-0.17.0
	kernel32-sys-0.2.2
	khronos-egl-4.1.0
	kqueue-1.0.4
	kqueue-sys-1.0.3
	lazy_static-1.4.0
	lexical-5.2.2
	lexical-core-0.7.6
	libc-0.2.103
	libloading-0.7.1
	libm-0.2.1
	libsqlite3-sys-0.22.2
	linked-hash-map-0.5.4
	lock_api-0.4.5
	log-0.4.14
	lru-cache-0.1.2
	lsp-types-0.89.2
	lspower-1.1.0
	lspower-macros-0.2.1
	make-cmd-0.1.0
	malloc_buf-0.0.6
	match_cfg-0.1.0
	matches-0.1.9
	memchr-2.4.1
	memoffset-0.6.4
	metal-0.23.1
	mime-0.3.16
	miniz_oxide-0.4.4
	mio-0.7.13
	miow-0.3.7
	naga-0.6.3
	new_debug_unreachable-1.0.4
	nibble_vec-0.1.0
	nix-0.22.2
	notify-5.0.0-pre.12
	ntapi-0.3.6
	num-bigint-0.2.6
	num-bigint-dig-0.7.0
	num-integer-0.1.44
	num-iter-0.1.42
	num-traits-0.2.14
	num_cpus-1.13.0
	objc-0.2.7
	objc_exception-0.1.2
	once_cell-1.8.0
	opaque-debug-0.3.0
	openssl-probe-0.1.4
	os_pipe-0.9.2
	output_vt100-0.1.2
	owning_ref-0.4.1
	p256-0.9.0
	p384-0.8.0
	parking_lot-0.11.1
	parking_lot_core-0.8.0
	percent-encoding-2.1.0
	pest-2.1.3
	petgraph-0.5.1
	petgraph-0.6.0
	phf-0.8.0
	phf_generator-0.8.0
	phf_macros-0.8.0
	phf_shared-0.8.0
	pin-project-1.0.8
	pin-project-internal-1.0.8
	pin-project-lite-0.2.7
	pin-utils-0.1.0
	pkcs1-0.2.4
	pkcs8-0.7.6
	pkg-config-0.3.20
	pmutil-0.5.3
	ppv-lite86-0.2.10
	precomputed-hash-0.1.1
	pretty_assertions-0.7.2
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro-nested-0.1.7
	proc-macro2-0.4.30
	proc-macro2-1.0.29
	profiling-1.0.3
	pty-0.2.2
	pulldown-cmark-0.8.0
	quick-error-1.2.3
	quote-0.6.13
	quote-1.0.10
	radix_fmt-1.0.0
	radix_trie-0.2.1
	rand-0.7.3
	rand-0.8.4
	rand_chacha-0.2.2
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.3
	rand_hc-0.2.0
	rand_hc-0.3.1
	rand_pcg-0.2.1
	range-alloc-0.1.2
	raw-window-handle-0.3.3
	redox_syscall-0.1.57
	redox_syscall-0.2.10
	regex-1.5.4
	regex-syntax-0.6.25
	relative-path-1.5.0
	remove_dir_all-0.5.3
	renderdoc-sys-0.7.1
	reqwest-0.11.5
	resolv-conf-0.7.0
	retain_mut-0.1.4
	ring-0.16.20
	ron-0.6.5
	rsa-0.5.0
	rusqlite-0.25.3
	rustc-hash-1.1.0
	rustc_version-0.2.3
	rustc_version-0.3.3
	rustls-0.19.1
	rustls-native-certs-0.5.0
	rustyline-9.0.0
	rustyline-derive-0.5.0
	ryu-1.0.5
	same-file-1.0.6
	schannel-0.1.19
	scoped-tls-1.0.0
	scopeguard-1.1.0
	sct-0.6.1
	security-framework-2.3.1
	security-framework-sys-2.4.2
	semver-0.9.0
	semver-0.11.0
	semver-parser-0.7.0
	semver-parser-0.10.2
	serde-1.0.130
	serde_derive-1.0.130
	serde_json-1.0.68
	serde_repr-0.1.7
	serde_urlencoded-0.7.0
	serde_v8-0.15.0
	sha-1-0.9.8
	sha2-0.9.8
	shell-escape-0.1.5
	signal-hook-registry-1.4.0
	signature-1.3.1
	siphasher-0.3.7
	slab-0.4.4
	slotmap-1.0.6
	smallvec-1.7.0
	socket2-0.3.19
	socket2-0.4.2
	sourcemap-6.0.1
	spin-0.5.2
	spirv-0.2.0+1.5.4
	spki-0.4.1
	stable_deref_trait-1.2.0
	static_assertions-1.1.0
	str-buf-1.0.5
	string_cache-0.8.1
	string_cache_codegen-0.5.1
	string_enum-0.3.1
	strsim-0.8.0
	strsim-0.9.3
	subtle-2.4.1
	swc_atoms-0.2.7
	swc_bundler-0.68.1
	swc_common-0.13.4
	swc_ecma_ast-0.54.3
	swc_ecma_codegen-0.74.4
	swc_ecma_codegen_macros-0.6.0
	swc_ecma_dep_graph-0.42.0
	swc_ecma_loader-0.21.0
	swc_ecma_parser-0.73.11
	swc_ecma_transforms-0.81.0
	swc_ecma_transforms_base-0.37.1
	swc_ecma_transforms_classes-0.23.0
	swc_ecma_transforms_macros-0.2.1
	swc_ecma_transforms_optimization-0.51.0
	swc_ecma_transforms_proposal-0.46.0
	swc_ecma_transforms_react-0.48.1
	swc_ecma_transforms_typescript-0.48.0
	swc_ecma_utils-0.47.1
	swc_ecma_visit-0.40.0
	swc_ecmascript-0.73.0
	swc_eq_ignore_macros-0.1.0
	swc_macros_common-0.3.3
	swc_visit-0.2.6
	swc_visit_macros-0.2.3
	syn-0.15.44
	syn-1.0.65
	synstructure-0.12.6
	sys-info-0.9.0
	tempfile-3.2.0
	termcolor-1.1.2
	text-size-1.1.0
	text_lines-0.3.0
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	time-0.1.44
	tinyvec-1.5.0
	tinyvec_macros-0.1.0
	tokio-1.12.0
	tokio-macros-1.4.1
	tokio-rustls-0.22.0
	tokio-stream-0.1.7
	tokio-tungstenite-0.14.0
	tokio-util-0.6.8
	toml-0.5.8
	tower-service-0.3.1
	tracing-0.1.29
	tracing-attributes-0.1.18
	tracing-core-0.1.21
	trust-dns-client-0.20.3
	trust-dns-proto-0.20.3
	trust-dns-resolver-0.20.3
	trust-dns-server-0.20.3
	try-lock-0.2.3
	tungstenite-0.13.0
	twoway-0.2.2
	typenum-1.14.0
	ucd-trie-0.1.3
	unchecked-index-0.2.2
	unic-char-property-0.9.0
	unic-char-range-0.9.0
	unic-common-0.9.0
	unic-ucd-ident-0.9.0
	unic-ucd-version-0.9.0
	unicase-2.6.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.1.0
	unicode-xid-0.2.2
	untrusted-0.7.1
	url-2.2.2
	urlpattern-0.1.2
	utf-8-0.7.6
	utf8parse-0.2.0
	uuid-0.8.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.3
	walkdir-2.3.2
	want-0.3.0
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.10.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.72
	wasm-bindgen-backend-0.2.72
	wasm-bindgen-futures-0.4.22
	wasm-bindgen-macro-0.2.72
	wasm-bindgen-macro-support-0.2.72
	wasm-bindgen-shared-0.2.72
	web-sys-0.3.49
	webpki-0.21.4
	webpki-roots-0.21.1
	wgpu-core-0.10.4
	wgpu-hal-0.10.7
	wgpu-types-0.10.0
	which-4.2.2
	widestring-0.4.3
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	winreg-0.6.2
	winreg-0.7.0
	winres-0.1.12
	zeroize-1.4.2
	zeroize_derive-1.2.0
"

RUSTY_V8="0.32.0"
V8="9.5.172.19"
chromium_build="b1cbcbce2c71b08bb34ede6add332626e78fa10e"
icu="f022e298b4f4a782486bb6d5ce6589c998b51fe2"

inherit cargo check-reqs toolchain-funcs python-any-r1 git-r3

DESCRIPTION="A secure JavaScript and TypeScript runtime"
HOMEPAGE="https://github.com/denoland/deno"
EGIT_REPO_URI="https://github.com/denoland/rusty_v8"
EGIT_COMMIT="v${RUSTY_V8}"
EGIT_CHECKOUT_DIR="${WORKDIR}/rusty_v8"
EGIT_SUBMODULES=('third_party/jinja2' 'third_party/markupsafe' 'third_party/zlib' 'base/trace_event/common')
SRC_URI="
	https://github.com/denoland/deno/releases/download/v${PV}/deno_src.tar.gz -> ${P}.tar.gz
	https://github.com/v8/v8/archive/refs/tags/${V8}.tar.gz -> v8-${V8}.tar.gz
	https://github.com/denoland/chromium_build/archive/${chromium_build}.tar.gz -> deno_build-${chromium_build}.tar.gz
	https://github.com/denoland/icu/archive/${icu}.tar.gz -> deno_icu-${icu}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0 ISC MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE="libcxx static-libs"

BDEPEND="
	>=dev-libs/glib-2.66.7
	>=dev-util/gn-0.1807
	>=dev-util/ninja-1.10.0
	>=sys-devel/clang-10.0.0
	dev-lang/python:2.7[xml]
	libcxx? ( sys-libs/libcxx )
	>=dev-lang/rust-1.51.0[wasi,wasm]
"

S="${WORKDIR}/deno"

CHECKREQS_DISK_BUILD=23G

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
}

src_unpack() {
	git-r3_src_unpack
	#https://bugs.gentoo.org/783372
	cargo_src_unpack
}

src_prepare() {
	pushd "${EGIT_CHECKOUT_DIR}" >> /dev/null
	rm -rf v8 || die
	rm -rf build || die
	rm -rf third_party/icu || die
	mv "../v8-${V8}" v8 || die
	mv "../chromium_build-${chromium_build}" build || die
	mv "../icu-${icu}" third_party/icu || die
	eapply "${FILESDIR}/remove-libatomic.patch"
	eapply "${FILESDIR}/gentoo-r1.patch"
	pushd v8 >> /dev/null
	eapply "${FILESDIR}/v8.patch"
	popd >> /dev/null
	popd >> /dev/null
	echo "[patch.crates-io]" >> "${S}/Cargo.toml"
	echo "rusty_v8 = { path = '../rusty_v8' }" >> "${S}/Cargo.toml"
	default
}

src_configure() {
	python_setup

	export V8_FROM_SOURCE=1

	if ! tc-is-clang; then
		die "deno require CC=clang CXX=clang++"
	fi

	local clang_path=$($(tc-getCC) --print-prog-name clang)
	local clang_bin=$(dirname ${clang_path})
	# should be /usr/lib/llvm/12
	local clang_base=$(dirname ${clang_bin})
	local myconf_gn=""
	myconf_gn+="is_clang=true use_gold=false use_sysroot=false use_custom_libcxx=false"
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" clang_base_path=\"${clang_base}\""
	myconf_gn+=" fatal_linker_warnings=false"
	export GN_ARGS="${myconf_gn}"

	if use libcxx; then
		# for cc-rs
		export CXXSTDLIB=c++
	fi
	default
}

src_compile() {
	cd "${S}/cli"
	cargo_src_compile -vv --jobs $(makeopts_jobs)
}

src_install() {
	dobin "${S}"/target/release/deno
	use static-libs && dolib.a "${S}"/target/release/gn_out/obj/librusty_v8.a
}
