# Copyright 2017-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="xml"

CRATES="
	Inflector-0.11.4
	adler-1.0.2
	aead-0.5.1
	aes-0.8.2
	aes-gcm-0.10.1
	aes-kw-0.2.1
	ahash-0.7.6
	aho-corasick-0.7.20
	alloc-no-stdlib-2.0.4
	alloc-stdlib-0.2.2
	android_system_properties-0.1.5
	anyhow-1.0.69
	arrayvec-0.7.2
	ash-0.37.2+1.3.238
	ast_node-0.8.6
	async-compression-0.3.15
	async-stream-0.3.3
	async-stream-impl-0.3.3
	async-trait-0.1.64
	atty-0.2.14
	auto_impl-0.5.0
	autocfg-1.1.0
	base16ct-0.1.1
	base32-0.4.0
	base64-0.13.1
	base64-0.21.0
	base64-simd-0.8.0
	base64ct-1.5.3
	basic-toml-0.1.1
	bencher-0.1.5
	better_scoped_tls-0.1.0
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	block-0.1.6
	block-buffer-0.9.0
	block-buffer-0.10.3
	block-modes-0.9.1
	block-padding-0.3.2
	brotli-3.3.4
	brotli-decompressor-2.3.4
	bumpalo-3.12.0
	byteorder-1.4.3
	bytes-1.2.1
	cache_control-0.2.0
	cbc-0.1.2
	cc-1.0.79
	cfg-if-1.0.0
	chrono-0.4.22
	cipher-0.4.3
	clap-3.1.12
	clap_complete-3.1.2
	clap_complete_fig-3.1.5
	clap_lex-0.1.1
	clipboard-win-4.5.0
	codespan-reporting-0.11.1
	console_static_text-0.3.4
	const-oid-0.9.1
	convert_case-0.4.0
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	core-graphics-types-0.1.1
	cpufeatures-0.2.5
	crc-2.1.0
	crc-catalog-1.1.1
	crc32fast-1.3.2
	crossbeam-channel-0.5.6
	crossbeam-utils-0.8.14
	crypto-bigint-0.4.9
	crypto-common-0.1.6
	ctor-0.1.26
	ctr-0.9.2
	cty-0.2.2
	curve25519-dalek-2.1.3
	curve25519-dalek-3.2.0
	cxx-1.0.89
	cxx-build-1.0.89
	cxxbridge-flags-1.0.89
	cxxbridge-macro-1.0.89
	d3d12-0.6.0
	darling-0.13.4
	darling_core-0.13.4
	darling_macro-0.13.4
	dashmap-5.4.0
	data-encoding-2.3.3
	data-url-0.2.0
	deno_ast-0.24.0
	deno_doc-0.57.0
	deno_emit-0.16.0
	deno_graph-0.44.2
	deno_lint-0.40.0
	deno_task_shell-0.10.0
	der-0.6.1
	derive_more-0.99.17
	diff-0.1.13
	digest-0.8.1
	digest-0.9.0
	digest-0.10.6
	dissimilar-1.0.4
	dlopen-0.1.8
	dlopen_derive-0.1.4
	dotenv-0.15.0
	dprint-core-0.60.0
	dprint-plugin-json-0.17.0
	dprint-plugin-markdown-0.15.2
	dprint-plugin-typescript-0.83.0
	dprint-swc-ext-0.7.0
	dyn-clone-1.0.10
	dynasm-1.2.3
	dynasmrt-1.2.3
	ecdsa-0.14.8
	either-1.8.1
	elliptic-curve-0.12.3
	encoding_rs-0.8.31
	endian-type-0.1.2
	enum-as-inner-0.5.1
	enum_kind-0.2.1
	env_logger-0.9.0
	errno-0.2.8
	errno-dragonfly-0.1.2
	error-code-2.3.1
	escape8259-0.5.2
	eszip-0.37.0
	fallible-iterator-0.2.0
	fallible-streaming-iterator-0.1.9
	fancy-regex-0.10.0
	fastrand-1.8.0
	fd-lock-3.0.10
	ff-0.12.1
	filetime-0.2.19
	fixedbitset-0.4.2
	flaky_test-0.1.0
	flate2-1.0.24
	fly-accept-encoding-0.2.0
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.1.0
	from_variant-0.1.4
	fs3-0.5.0
	fsevent-sys-4.1.0
	fslock-0.1.8
	futures-0.3.26
	futures-channel-0.3.26
	futures-core-0.3.26
	futures-executor-0.3.26
	futures-io-0.3.26
	futures-macro-0.3.26
	futures-sink-0.3.26
	futures-task-0.3.26
	futures-util-0.3.26
	fwdansi-1.1.0
	fxhash-0.2.1
	generic-array-0.12.4
	generic-array-0.14.6
	getrandom-0.1.16
	getrandom-0.2.8
	ghash-0.5.0
	glibc_version-0.1.2
	glob-0.3.1
	glow-0.12.0
	gpu-alloc-0.5.3
	gpu-alloc-types-0.2.0
	gpu-descriptor-0.2.3
	gpu-descriptor-types-0.1.1
	group-0.12.1
	h2-0.3.15
	hashbrown-0.12.3
	hashlink-0.8.1
	heck-0.4.1
	hermit-abi-0.1.19
	hermit-abi-0.2.6
	hexf-parse-0.2.1
	hkdf-0.12.3
	hmac-0.12.1
	hostname-0.3.1
	http-0.2.8
	http-body-0.4.5
	httparse-1.8.0
	httpdate-1.0.2
	humantime-2.1.0
	hyper-0.14.24
	hyper-rustls-0.23.2
	iana-time-zone-0.1.53
	iana-time-zone-haiku-0.1.1
	ident_case-1.0.1
	idna-0.2.3
	idna-0.3.0
	if_chain-1.0.2
	import_map-0.13.0
	import_map-0.15.0
	indexmap-1.9.2
	inotify-0.9.6
	inotify-sys-0.1.5
	inout-0.1.3
	instant-0.1.12
	io-lifetimes-1.0.5
	ipconfig-0.3.1
	ipnet-2.7.1
	is-macro-0.2.1
	itertools-0.10.5
	itoa-1.0.5
	jobserver-0.1.25
	js-sys-0.3.61
	jsonc-parser-0.21.0
	junction-0.2.0
	keccak-0.1.3
	khronos-egl-4.1.0
	kqueue-1.0.7
	kqueue-sys-1.0.3
	lazy_static-1.4.0
	lexical-6.1.1
	lexical-core-0.8.5
	lexical-parse-float-0.8.5
	lexical-parse-integer-0.8.6
	lexical-util-0.8.5
	lexical-write-float-0.8.5
	lexical-write-integer-0.8.5
	libc-0.2.139
	libffi-3.1.0
	libffi-sys-2.1.0
	libloading-0.7.4
	libm-0.2.6
	libsqlite3-sys-0.25.2
	link-cplusplus-1.0.8
	linked-hash-map-0.5.6
	linux-raw-sys-0.1.4
	lock_api-0.4.9
	log-0.4.17
	lru-cache-0.1.2
	lsp-types-0.93.2
	lzzzz-1.0.4
	malloc_buf-0.0.6
	match_cfg-0.1.0
	matches-0.1.10
	md-5-0.10.5
	md4-0.10.2
	memchr-2.5.0
	memmap2-0.5.8
	memoffset-0.6.5
	metal-0.24.0
	mime-0.3.16
	miniz_oxide-0.5.4
	mio-0.8.5
	mitata-0.0.7
	monch-0.4.0
	naga-0.11.0
	napi-build-1.2.1
	napi-sys-2.2.3
	netif-0.1.6
	new_debug_unreachable-1.0.4
	nibble_vec-0.1.0
	nix-0.24.2
	nom8-0.2.0
	notify-5.0.0
	ntapi-0.4.0
	num-bigint-0.4.3
	num-bigint-dig-0.8.2
	num-integer-0.1.45
	num-iter-0.1.43
	num-traits-0.2.15
	num_cpus-1.15.0
	objc-0.2.7
	objc_exception-0.1.2
	once_cell-1.16.0
	opaque-debug-0.3.0
	openssl-probe-0.1.5
	ordered-float-2.10.0
	os_pipe-1.0.1
	os_str_bytes-6.4.1
	output_vt100-0.1.3
	outref-0.5.1
	p256-0.11.1
	p384-0.11.2
	parking_lot-0.11.2
	parking_lot-0.12.1
	parking_lot_core-0.8.6
	parking_lot_core-0.9.7
	path-clean-0.1.0
	path-dedot-3.0.18
	pathdiff-0.2.1
	pem-rfc7468-0.6.0
	percent-encoding-2.2.0
	petgraph-0.6.3
	phf-0.10.1
	phf_generator-0.10.0
	phf_macros-0.10.0
	phf_shared-0.10.0
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkcs1-0.4.1
	pkcs8-0.9.0
	pkg-config-0.3.26
	pmutil-0.5.3
	polyval-0.6.0
	ppv-lite86-0.2.17
	precomputed-hash-0.1.1
	pretty_assertions-1.3.0
	prettyplease-0.1.23
	proc-macro-crate-1.3.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.20+deprecated
	proc-macro2-0.4.30
	proc-macro2-1.0.51
	profiling-1.0.7
	pty2-0.1.0
	pulldown-cmark-0.9.2
	quick-error-1.2.3
	quote-0.6.13
	quote-1.0.23
	radix_fmt-1.0.0
	radix_trie-0.2.1
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.4
	range-alloc-0.1.2
	raw-window-handle-0.5.0
	redox_syscall-0.2.16
	regex-1.6.0
	regex-syntax-0.6.28
	relative-path-1.7.3
	remove_dir_all-0.5.3
	reqwest-0.11.14
	resolv-conf-0.7.0
	rfc6979-0.3.1
	ring-0.16.20
	ripemd-0.1.3
	ron-0.8.0
	rsa-0.7.2
	rusqlite-0.28.0
	rustc-hash-1.1.0
	rustc_version-0.2.3
	rustc_version-0.4.0
	rustix-0.36.8
	rustls-0.20.8
	rustls-native-certs-0.6.2
	rustls-pemfile-1.0.2
	rustversion-1.0.11
	rustyline-10.0.0
	rustyline-derive-0.7.0
	ryu-1.0.12
	same-file-1.0.6
	schannel-0.1.21
	scoped-tls-1.0.1
	scopeguard-1.1.0
	scratch-1.0.3
	sct-0.7.0
	sec1-0.3.0
	security-framework-2.8.2
	security-framework-sys-2.8.0
	semver-0.9.0
	semver-1.0.14
	semver-parser-0.7.0
	serde-1.0.152
	serde-value-0.7.0
	serde_bytes-0.11.9
	serde_derive-1.0.152
	serde_json-1.0.92
	serde_repr-0.1.9
	serde_urlencoded-0.7.1
	sha-1-0.9.8
	sha-1-0.10.0
	sha1-0.10.5
	sha2-0.10.6
	sha3-0.10.6
	shell-escape-0.1.5
	signal-hook-registry-1.4.0
	signature-1.6.4
	siphasher-0.3.10
	slab-0.4.7
	slotmap-1.0.6
	smallvec-1.10.0
	socket2-0.4.7
	sourcemap-6.2.1
	spin-0.5.2
	spirv-0.2.0+1.5.4
	spki-0.6.0
	stable_deref_trait-1.2.0
	static_assertions-1.1.0
	str-buf-1.0.6
	string_cache-0.8.4
	string_cache_codegen-0.5.2
	string_enum-0.3.2
	strsim-0.10.0
	subtle-2.4.1
	swc_atoms-0.4.34
	swc_bundler-0.199.11
	swc_common-0.29.29
	swc_config-0.1.4
	swc_config_macro-0.1.0
	swc_ecma_ast-0.96.3
	swc_ecma_codegen-0.129.8
	swc_ecma_codegen_macros-0.7.1
	swc_ecma_dep_graph-0.96.5
	swc_ecma_loader-0.41.31
	swc_ecma_parser-0.124.5
	swc_ecma_transforms_base-0.116.5
	swc_ecma_transforms_classes-0.105.5
	swc_ecma_transforms_macros-0.5.0
	swc_ecma_transforms_optimization-0.172.12
	swc_ecma_transforms_proposal-0.149.8
	swc_ecma_transforms_react-0.160.9
	swc_ecma_transforms_typescript-0.164.10
	swc_ecma_utils-0.107.5
	swc_ecma_visit-0.82.3
	swc_eq_ignore_macros-0.1.1
	swc_fast_graph-0.17.30
	swc_graph_analyzer-0.18.32
	swc_macros_common-0.3.6
	swc_visit-0.5.4
	swc_visit_macros-0.5.5
	syn-0.15.44
	syn-1.0.107
	synstructure-0.12.6
	tar-0.4.38
	tempfile-3.3.0
	termcolor-1.2.0
	testing_macros-0.2.7
	text-size-1.1.0
	text_lines-0.6.0
	textwrap-0.15.2
	thiserror-1.0.38
	thiserror-impl-1.0.38
	time-0.3.17
	time-core-0.1.0
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	tokio-1.25.0
	tokio-macros-1.8.2
	tokio-rustls-0.23.4
	tokio-socks-0.5.1
	tokio-stream-0.1.11
	tokio-tungstenite-0.16.1
	tokio-util-0.7.4
	toml-0.5.11
	toml_datetime-0.5.1
	toml_edit-0.18.1
	tower-0.4.13
	tower-layer-0.3.2
	tower-lsp-0.17.0
	tower-lsp-macros-0.6.0
	tower-service-0.3.2
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	triomphe-0.1.8
	trust-dns-client-0.22.0
	trust-dns-proto-0.22.0
	trust-dns-resolver-0.22.0
	trust-dns-server-0.22.0
	try-lock-0.2.4
	trybuild-1.0.77
	tungstenite-0.16.0
	twox-hash-1.6.3
	typed-arena-2.0.1
	typenum-1.16.0
	unic-char-property-0.9.0
	unic-char-range-0.9.0
	unic-common-0.9.0
	unic-ucd-ident-0.9.0
	unic-ucd-version-0.9.0
	unicase-2.6.0
	unicode-bidi-0.3.10
	unicode-id-0.3.3
	unicode-ident-1.0.6
	unicode-normalization-0.1.22
	unicode-segmentation-1.10.1
	unicode-width-0.1.10
	unicode-xid-0.1.0
	unicode-xid-0.2.4
	universal-hash-0.5.0
	untrusted-0.7.1
	url-2.3.1
	urlpattern-0.2.0
	utf-8-0.7.6
	utf8parse-0.2.0
	uuid-1.1.2
	vcpkg-0.2.15
	version_check-0.9.4
	vsimd-0.8.0
	vte-0.11.0
	vte_generate_state_changes-0.1.1
	walkdir-2.3.2
	want-0.3.0
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-futures-0.4.34
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	wasm-streams-0.2.3
	web-sys-0.3.61
	webpki-0.22.0
	webpki-roots-0.22.6
	wgpu-core-0.15.0
	wgpu-hal-0.15.1
	wgpu-types-0.15.0
	which-4.4.0
	widestring-0.5.1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows-sys-0.45.0
	windows-targets-0.42.1
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.42.1
	winreg-0.10.1
	winres-0.1.12
	x25519-dalek-2.0.0-pre.1
	xattr-0.2.3
	yansi-0.5.1
	zeroize-1.5.7
	zeroize_derive-1.3.3
	zstd-0.11.2+zstd.1.5.2
	zstd-safe-5.0.2+zstd.1.5.2
	zstd-sys-2.0.6+zstd.1.5.2
"

inherit cargo check-reqs toolchain-funcs python-any-r1 git-r3 bash-completion-r1

DESCRIPTION="A secure JavaScript and TypeScript runtime"
HOMEPAGE="https://github.com/denoland/deno"
EGIT_REPO_URI="https://github.com/denoland/rusty_v8.git"
EGIT_COMMIT="v0.63.0"
EGIT_CHECKOUT_DIR="${WORKDIR}/v8"
EGIT_SUBMODULES=('v8' 'build' 'base/trace_event/common' 'third_party/jinja2' 'third_party/markupsafe' 'third_party/zlib' 'third_party/icu')
SRC_URI="
	https://github.com/denoland/deno/releases/download/v${PV}/deno_src.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0 ISC MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"
IUSE="static-libs bash-completion zsh-completion fish-completion"

BDEPEND="
	>=dev-libs/glib-2.74.6
	>=dev-util/gn-0.2077
	>=dev-util/ninja-1.11.1
	>=sys-devel/clang-15.0.7
	>=dev-lang/rust-1.68.2[wasi,wasm]
"

S="${WORKDIR}/deno"
DOCS=( "README.md" "LICENSE.md" "Releases.md" )

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
	pushd "${EGIT_CHECKOUT_DIR}" > /dev/null || die
	if tc-is-clang && ( has_version "sys-devel/clang-common[default-compiler-rt]" || is-flagq -rtlib=compiler-rt ); then
		eapply "${FILESDIR}/remove-libatomic.patch"
	fi
	if use elibc_musl; then
		eapply "${FILESDIR}/execinfo.patch"
	fi
	eapply "${FILESDIR}/build_from_source-${PV}.patch"
	popd > /dev/null || die
	pushd "${S}" > /dev/null || die
	echo "[patch.crates-io]" >> Cargo.toml
	echo "v8 = { path = '../v8' }" >> Cargo.toml
	if use elibc_musl; then
		eapply "${FILESDIR}/glibc.patch"
	fi
	eapply "${FILESDIR}/ext-node-fix-snapshot-failed.patch"
	popd > /dev/null || die
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
	# should be /usr/lib/llvm/15
	local clang_base=$(dirname ${clang_bin})
	local myconf_gn="is_clang=true use_gold=false use_sysroot=false use_custom_libcxx=false"
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" clang_base_path=\"${clang_base}\""
	myconf_gn+=" fatal_linker_warnings=false treat_warnings_as_errors=false"
	export GN_ARGS="${myconf_gn}"
	default
}

src_compile() {
	cd "${S}/cli" || die
	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	cargo_src_compile -vv
}

src_install() {
	if use debug; then
		dobin "${S}"/target/debug/deno
	else
		dobin "${S}"/target/release/deno
	fi
	einstalldocs
	use static-libs && dolib.a "${S}"/target/release/gn_out/obj/librusty_v8.a
	if use bash-completion; then
		"${S}"/target/release/deno completions bash > deno
		dobashcomp deno
	fi
	if use zsh-completion; then
		"${S}"/target/release/deno completions zsh > _deno
		insinto /usr/share/zsh/site-functions
		doins _deno
	fi
	if use fish-completion; then
		"${S}"/target/release/deno completions fish > deno.fish
		insinto /usr/share/fish/vendor_completions.d
		doins deno.fish
	fi
}
