# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Can't do 12 yet: heavy use of imp, among other things (bug #915001, bug #915062)
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="xml(+)"

# Same LLVM version of Rust
LLVM_VALID_SLOTS=( 17 18 )
LLVM_MAX_SLOT=18
GN_MIN_VER=0.2122

V8_VER=0.91.1
STACKER_VER=0.1.15

CRATES="
	Inflector-0.11.4
	addr2line-0.21.0
	adler-1.0.2
	aead-0.5.2
	aead-gcm-stream-0.1.0
	aes-0.8.3
	aes-gcm-0.10.3
	aes-kw-0.2.1
	ahash-0.8.11
	aho-corasick-1.1.3
	alloc-no-stdlib-2.0.4
	alloc-stdlib-0.2.2
	allocator-api2-0.2.16
	ammonia-3.3.0
	android_system_properties-0.1.5
	anstream-0.6.13
	anstyle-1.0.6
	anstyle-parse-0.2.3
	anstyle-query-1.0.2
	anstyle-wincon-3.0.2
	anyhow-1.0.82
	arrayvec-0.7.4
	ash-0.37.3+1.3.251
	asn1-rs-0.5.2
	asn1-rs-derive-0.4.0
	asn1-rs-impl-0.1.0
	ast_node-0.9.8
	async-compression-0.4.8
	async-stream-0.3.5
	async-stream-impl-0.3.5
	async-trait-0.1.80
	asynchronous-codec-0.7.0
	auto_impl-1.2.0
	autocfg-1.2.0
	backtrace-0.3.71
	base16ct-0.2.0
	base32-0.4.0
	base64-0.21.7
	base64-0.22.1
	base64-simd-0.7.0
	base64-simd-0.8.0
	base64ct-1.6.0
	bencher-0.1.5
	better_scoped_tls-0.1.1
	bincode-1.3.3
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	bitflags-2.5.0
	bitvec-1.0.1
	block-0.1.6
	block-buffer-0.10.4
	block-padding-0.3.3
	brotli-3.5.0
	brotli-4.0.0
	brotli-decompressor-2.5.1
	brotli-decompressor-3.0.0
	bstr-1.9.1
	bumpalo-3.16.0
	bytemuck-1.15.0
	byteorder-1.5.0
	bytes-1.6.0
	cache_control-0.2.0
	cbc-0.1.2
	cc-1.0.92
	cfg-if-1.0.0
	cfg_aliases-0.1.1
	chrono-0.4.37
	cipher-0.4.4
	clap-4.4.17
	clap_builder-4.4.17
	clap_complete-4.4.7
	clap_complete_fig-4.4.2
	clap_lex-0.6.0
	clipboard-win-5.3.0
	cmake-0.1.50
	codespan-reporting-0.11.1
	color-print-0.3.5
	color-print-proc-macro-0.3.5
	color_quant-1.1.0
	colorchoice-1.0.0
	comrak-0.20.0
	console_static_text-0.8.1
	const-oid-0.9.6
	convert_case-0.4.0
	cooked-waker-5.0.0
	core-foundation-0.9.4
	core-foundation-sys-0.8.6
	core-graphics-types-0.1.3
	cpufeatures-0.2.12
	crc-2.1.0
	crc-catalog-1.1.1
	crc32fast-1.4.0
	crossbeam-channel-0.5.12
	crossbeam-deque-0.8.5
	crossbeam-epoch-0.9.18
	crossbeam-queue-0.3.11
	crossbeam-utils-0.8.19
	crypto-bigint-0.5.5
	crypto-common-0.1.6
	ctr-0.9.2
	curve25519-dalek-4.1.2
	curve25519-dalek-derive-0.1.1
	d3d12-0.20.0
	darling-0.14.4
	darling_core-0.14.4
	darling_macro-0.14.4
	dashmap-5.5.3
	data-encoding-2.5.0
	data-url-0.3.0
	debugid-0.8.0
	deno_ast-0.38.2
	deno_cache_dir-0.7.1
	deno_config-0.16.3
	deno_core-0.280.0
	deno_core_icudata-0.0.73
	deno_doc-0.135.0
	deno_emit-0.40.3
	deno_graph-0.75.2
	deno_lint-0.58.4
	deno_lockfile-0.19.0
	deno_media_type-0.1.4
	deno_native_certs-0.2.0
	deno_npm-0.20.2
	deno_ops-0.156.0
	deno_semver-0.5.4
	deno_task_shell-0.16.1
	deno_terminal-0.1.1
	deno_unsync-0.3.4
	deno_whoami-0.1.0
	denokv_proto-0.5.0
	denokv_remote-0.5.0
	denokv_sqlite-0.5.0
	der-0.7.9
	der-parser-8.2.0
	deranged-0.3.11
	derive_builder-0.12.0
	derive_builder_core-0.12.0
	derive_builder_macro-0.12.0
	derive_more-0.99.17
	deunicode-1.4.3
	diff-0.1.13
	digest-0.10.7
	dirs-5.0.1
	dirs-sys-0.4.1
	displaydoc-0.2.4
	dissimilar-1.0.4
	dlopen2-0.6.1
	dlopen2_derive-0.4.0
	document-features-0.2.8
	dotenvy-0.15.7
	dprint-core-0.66.2
	dprint-core-macros-0.1.0
	dprint-plugin-json-0.19.2
	dprint-plugin-jupyter-0.1.3
	dprint-plugin-markdown-0.17.0
	dprint-plugin-typescript-0.90.5
	dprint-swc-ext-0.16.0
	dsa-0.6.3
	dyn-clone-1.0.17
	dynasm-1.2.3
	dynasmrt-1.2.3
	ecb-0.1.2
	ecdsa-0.16.9
	either-1.10.0
	elliptic-curve-0.13.8
	encoding_rs-0.8.33
	endian-type-0.1.2
	entities-1.0.1
	enum-as-inner-0.5.1
	env_logger-0.10.0
	equivalent-1.0.1
	errno-0.2.8
	errno-0.3.8
	errno-dragonfly-0.1.2
	error-code-3.2.0
	escape8259-0.5.2
	eszip-0.69.0
	fallible-iterator-0.2.0
	fallible-streaming-iterator-0.1.9
	fancy-regex-0.10.0
	faster-hex-0.9.0
	fastrand-2.0.2
	fastwebsockets-0.6.0
	fd-lock-4.0.2
	fdeflate-0.3.4
	ff-0.13.0
	fiat-crypto-0.2.7
	file_test_runner-0.7.0
	filetime-0.2.23
	fixedbitset-0.4.2
	flaky_test-0.1.0
	flate2-1.0.28
	float-cmp-0.9.0
	fnv-1.0.7
	foreign-types-0.5.0
	foreign-types-macros-0.2.3
	foreign-types-shared-0.3.1
	form_urlencoded-1.2.1
	fqdn-0.3.4
	from_variant-0.1.8
	fs3-0.5.0
	fsevent-sys-4.1.0
	fslock-0.2.1
	funty-2.0.0
	futf-0.1.5
	futures-0.3.30
	futures-channel-0.3.30
	futures-core-0.3.30
	futures-executor-0.3.30
	futures-io-0.3.30
	futures-macro-0.3.30
	futures-sink-0.3.30
	futures-task-0.3.30
	futures-util-0.3.30
	generic-array-0.14.7
	getrandom-0.2.14
	ghash-0.5.1
	gimli-0.28.1
	gl_generator-0.14.0
	glibc_version-0.1.2
	glob-0.3.1
	globset-0.4.14
	glow-0.13.1
	glutin_wgl_sys-0.5.0
	gpu-alloc-0.6.0
	gpu-alloc-types-0.3.0
	gpu-descriptor-0.3.0
	gpu-descriptor-types-0.2.0
	group-0.13.0
	gzip-header-1.0.0
	h2-0.3.26
	h2-0.4.4
	halfbrown-0.2.5
	handlebars-5.1.2
	hashbrown-0.14.3
	hashlink-0.8.4
	heck-0.4.1
	heck-0.5.0
	hermit-abi-0.3.9
	hex-0.4.3
	hexf-parse-0.2.1
	hkdf-0.12.4
	hmac-0.12.1
	home-0.5.9
	hostname-0.3.1
	hstr-0.2.9
	html-escape-0.2.13
	html5ever-0.26.0
	http-0.2.12
	http-1.1.0
	http-body-0.4.6
	http-body-1.0.0
	http-body-util-0.1.1
	httparse-1.8.0
	httpdate-1.0.3
	humantime-2.1.0
	hyper-0.14.28
	hyper-1.1.0
	hyper-rustls-0.24.2
	hyper-util-0.1.2
	ident_case-1.0.1
	idna-0.2.3
	idna-0.3.0
	idna-0.4.0
	if_chain-1.0.2
	ignore-0.4.20
	image-0.24.9
	import_map-0.19.0
	indexmap-2.2.6
	inotify-0.9.6
	inotify-sys-0.1.5
	inout-0.1.3
	instant-0.1.12
	ipconfig-0.3.2
	ipnet-2.9.0
	is-docker-0.2.0
	is-macro-0.3.5
	is-terminal-0.4.12
	is-wsl-0.4.0
	itertools-0.10.5
	itoa-1.0.11
	jni-sys-0.3.0
	jobserver-0.1.29
	js-sys-0.3.69
	jsonc-parser-0.23.0
	junction-0.2.0
	k256-0.13.3
	khronos-egl-6.0.0
	khronos_api-3.1.0
	kqueue-1.0.8
	kqueue-sys-1.0.4
	lazy-regex-3.1.0
	lazy-regex-proc_macros-3.1.0
	lazy_static-1.4.0
	lexical-core-0.8.5
	lexical-parse-float-0.8.5
	lexical-parse-integer-0.8.6
	lexical-util-0.8.5
	lexical-write-float-0.8.5
	lexical-write-integer-0.8.5
	libc-0.2.153
	libffi-3.2.0
	libffi-sys-2.3.0
	libloading-0.7.4
	libloading-0.8.3
	libm-0.2.8
	libredox-0.1.3
	libsqlite3-sys-0.26.0
	libz-sys-1.1.16
	linked-hash-map-0.5.6
	linux-raw-sys-0.4.13
	litrs-0.4.1
	lock_api-0.4.11
	log-0.4.21
	lru-cache-0.1.2
	lsp-types-0.94.1
	mac-0.1.1
	malloc_buf-0.0.6
	maplit-1.0.2
	markup5ever-0.11.0
	match_cfg-0.1.0
	matches-0.1.10
	md-5-0.10.6
	md4-0.10.2
	memchr-2.7.2
	memmap2-0.5.10
	memmem-0.1.1
	memoffset-0.7.1
	memoffset-0.9.1
	metal-0.28.0
	mime-0.3.17
	minimal-lexical-0.2.1
	miniz_oxide-0.7.2
	mio-0.8.11
	monch-0.5.0
	multimap-0.8.3
	naga-0.20.0
	napi-build-1.2.1
	napi-sys-2.2.2
	ndk-sys-0.5.0+25.2.9519653
	netif-0.1.6
	new_debug_unreachable-1.0.6
	nibble_vec-0.1.0
	nix-0.26.2
	nix-0.27.1
	nom-5.1.3
	nom-7.1.3
	notify-5.0.0
	ntapi-0.4.1
	num-bigint-0.4.4
	num-bigint-dig-0.8.4
	num-conv-0.1.0
	num-integer-0.1.46
	num-iter-0.1.44
	num-traits-0.2.18
	num_cpus-1.16.0
	objc-0.2.7
	object-0.32.2
	oid-registry-0.6.1
	once_cell-1.19.0
	onig-6.4.0
	onig_sys-69.8.1
	opaque-debug-0.3.1
	open-5.1.2
	openssl-probe-0.1.5
	option-ext-0.2.0
	ordered-float-2.10.1
	os_pipe-1.1.5
	outref-0.1.0
	outref-0.5.1
	p224-0.13.2
	p256-0.13.2
	p384-0.13.0
	p521-0.13.3
	parking_lot-0.11.2
	parking_lot-0.12.1
	parking_lot_core-0.8.6
	parking_lot_core-0.9.9
	password-hash-0.5.0
	paste-1.0.14
	path-clean-0.1.0
	path-dedot-3.1.1
	pathdiff-0.2.1
	pbkdf2-0.12.2
	pem-rfc7468-0.7.0
	percent-encoding-2.3.1
	pest-2.7.9
	pest_derive-2.7.9
	pest_generator-2.7.9
	pest_meta-2.7.9
	petgraph-0.6.4
	phf-0.10.1
	phf-0.11.2
	phf_codegen-0.10.0
	phf_generator-0.10.0
	phf_generator-0.11.2
	phf_macros-0.11.2
	phf_shared-0.10.0
	phf_shared-0.11.2
	pin-project-1.1.5
	pin-project-internal-1.1.5
	pin-project-lite-0.2.14
	pin-utils-0.1.0
	pkcs1-0.7.5
	pkcs8-0.10.2
	pkg-config-0.3.30
	platforms-3.4.0
	png-0.17.13
	polyval-0.6.2
	powerfmt-0.2.0
	ppv-lite86-0.2.17
	precomputed-hash-0.1.1
	pretty_assertions-1.4.0
	prettyplease-0.1.25
	primeorder-0.13.6
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-rules-0.4.0
	proc-macro-rules-macros-0.4.0
	proc-macro2-1.0.79
	profiling-1.0.15
	prost-0.11.9
	prost-build-0.11.9
	prost-derive-0.11.9
	prost-types-0.11.9
	psm-0.1.21
	pulldown-cmark-0.9.6
	quick-error-1.2.3
	quick-junit-0.3.6
	quick-xml-0.31.0
	quote-1.0.36
	radium-0.7.0
	radix_fmt-1.0.0
	radix_trie-0.2.1
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	range-alloc-0.1.3
	raw-window-handle-0.6.1
	rayon-1.10.0
	rayon-core-1.12.1
	redox_syscall-0.2.16
	redox_syscall-0.4.1
	redox_users-0.4.5
	ref-cast-1.0.22
	ref-cast-impl-1.0.22
	regex-1.10.4
	regex-automata-0.4.6
	regex-syntax-0.8.3
	relative-path-1.9.2
	reqwest-0.11.20
	resolv-conf-0.7.0
	rfc6979-0.4.0
	ring-0.17.8
	ripemd-0.1.3
	ron-0.8.1
	rsa-0.9.6
	runtimelib-0.9.0
	rusqlite-0.29.0
	rustc-demangle-0.1.23
	rustc-hash-1.1.0
	rustc_version-0.2.3
	rustc_version-0.4.0
	rusticata-macros-4.1.0
	rustix-0.38.32
	rustls-0.21.11
	rustls-native-certs-0.6.3
	rustls-pemfile-1.0.4
	rustls-tokio-stream-0.2.24
	rustls-webpki-0.101.7
	rustversion-1.0.15
	rustyline-13.0.0
	rustyline-derive-0.7.0
	ryu-1.0.17
	ryu-js-1.0.1
	saffron-0.1.0
	salsa20-0.10.2
	same-file-1.0.6
	schannel-0.1.23
	scoped-tls-1.0.1
	scopeguard-1.2.0
	scrypt-0.11.0
	sct-0.7.1
	sec1-0.7.3
	security-framework-2.10.0
	security-framework-sys-2.10.0
	semver-0.9.0
	semver-1.0.14
	semver-parser-0.7.0
	serde-1.0.200
	serde-value-0.7.0
	serde_bytes-0.11.14
	serde_derive-1.0.200
	serde_json-1.0.115
	serde_repr-0.1.16
	serde_urlencoded-0.7.1
	serde_v8-0.189.0
	sha-1-0.10.0
	sha1-0.10.6
	sha1_smol-1.0.0
	sha2-0.10.8
	shell-escape-0.1.5
	shellexpand-3.1.0
	signal-hook-0.3.17
	signal-hook-registry-1.4.1
	signature-2.2.0
	simd-abstraction-0.7.1
	simd-adler32-0.3.7
	simd-json-0.13.9
	simdutf8-0.1.4
	siphasher-0.3.11
	slab-0.4.9
	slotmap-1.0.7
	slug-0.1.5
	smallvec-1.13.2
	smartstring-1.0.1
	socket2-0.5.5
	sourcemap-8.0.1
	spin-0.5.2
	spin-0.9.8
	spirv-0.3.0+sdk-1.3.268.0
	spki-0.7.3
	stable_deref_trait-1.2.0
	stacker-0.1.15
	static_assertions-1.1.0
	string_cache-0.8.7
	string_cache_codegen-0.5.2
	string_enum-0.4.4
	strip-ansi-escapes-0.2.0
	strsim-0.10.0
	strum-0.25.0
	strum_macros-0.25.3
	subtle-2.5.0
	swc_atoms-0.6.7
	swc_bundler-0.227.0
	swc_cached-0.3.20
	swc_common-0.33.26
	swc_config-0.1.13
	swc_config_macro-0.1.4
	swc_ecma_ast-0.113.4
	swc_ecma_codegen-0.149.1
	swc_ecma_codegen_macros-0.7.6
	swc_ecma_loader-0.45.28
	swc_ecma_parser-0.144.1
	swc_ecma_transforms_base-0.138.2
	swc_ecma_transforms_classes-0.127.1
	swc_ecma_transforms_macros-0.5.5
	swc_ecma_transforms_optimization-0.199.1
	swc_ecma_transforms_proposal-0.172.3
	swc_ecma_transforms_react-0.184.1
	swc_ecma_transforms_typescript-0.189.1
	swc_ecma_utils-0.128.1
	swc_ecma_visit-0.99.1
	swc_eq_ignore_macros-0.1.3
	swc_fast_graph-0.21.22
	swc_graph_analyzer-0.22.23
	swc_macros_common-0.3.11
	swc_visit-0.5.14
	swc_visit_macros-0.5.12
	syn-1.0.109
	syn-2.0.58
	synstructure-0.12.6
	syntect-5.2.0
	tap-1.0.1
	tar-0.4.40
	tempfile-3.10.1
	tendril-0.4.3
	termcolor-1.4.1
	text-size-1.1.0
	text_lines-0.6.0
	thiserror-1.0.59
	thiserror-impl-1.0.59
	thread_local-1.1.8
	time-0.3.36
	time-core-0.1.2
	time-macros-0.2.18
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	tokio-1.37.0
	tokio-macros-2.2.0
	tokio-metrics-0.3.1
	tokio-rustls-0.24.1
	tokio-socks-0.5.1
	tokio-stream-0.1.15
	tokio-util-0.7.10
	toml-0.5.11
	tower-0.4.13
	tower-layer-0.3.2
	tower-lsp-0.20.0
	tower-lsp-macros-0.9.0
	tower-service-0.3.2
	tracing-0.1.40
	tracing-attributes-0.1.27
	tracing-core-0.1.32
	triomphe-0.1.11
	trust-dns-client-0.22.0
	trust-dns-proto-0.22.0
	trust-dns-resolver-0.22.0
	trust-dns-server-0.22.1
	try-lock-0.2.5
	twox-hash-1.6.3
	typed-arena-2.0.1
	typenum-1.17.0
	ucd-trie-0.1.6
	unic-char-property-0.9.0
	unic-char-range-0.9.0
	unic-common-0.9.0
	unic-ucd-ident-0.9.0
	unic-ucd-version-0.9.0
	unicase-2.7.0
	unicode-bidi-0.3.15
	unicode-id-0.3.4
	unicode-id-start-1.0.4
	unicode-ident-1.0.12
	unicode-normalization-0.1.23
	unicode-segmentation-1.11.0
	unicode-width-0.1.11
	unicode-xid-0.2.4
	unicode_categories-0.1.1
	universal-hash-0.5.1
	untrusted-0.9.0
	url-2.4.1
	urlpattern-0.2.0
	utf-8-0.7.6
	utf8-width-0.1.7
	utf8parse-0.2.1
	uuid-1.8.0
	v8-0.91.1
	value-trait-0.8.1
	vcpkg-0.2.15
	version_check-0.9.4
	vsimd-0.8.0
	vte-0.11.1
	vte_generate_state_changes-0.1.1
	walkdir-2.3.2
	want-0.3.1
	wasi-0.11.0+wasi-snapshot-preview1
	wasite-0.1.0
	wasm-bindgen-0.2.92
	wasm-bindgen-backend-0.2.92
	wasm-bindgen-futures-0.4.42
	wasm-bindgen-macro-0.2.92
	wasm-bindgen-macro-support-0.2.92
	wasm-bindgen-shared-0.2.92
	wasm-streams-0.3.0
	web-sys-0.3.69
	webpki-roots-0.25.4
	wgpu-core-0.20.0
	wgpu-hal-0.20.0
	wgpu-types-0.20.0
	which-4.4.2
	which-5.0.0
	whoami-1.5.1
	widestring-1.1.0
	win32job-2.0.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.6
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.52.0
	windows-core-0.52.0
	windows-sys-0.48.0
	windows-sys-0.52.0
	windows-targets-0.48.5
	windows-targets-0.52.4
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_gnullvm-0.52.4
	windows_aarch64_msvc-0.48.5
	windows_aarch64_msvc-0.52.4
	windows_i686_gnu-0.48.5
	windows_i686_gnu-0.52.4
	windows_i686_msvc-0.48.5
	windows_i686_msvc-0.52.4
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnu-0.52.4
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_gnullvm-0.52.4
	windows_x86_64_msvc-0.48.5
	windows_x86_64_msvc-0.52.4
	winreg-0.50.0
	winres-0.1.12
	wyz-0.5.1
	x25519-dalek-2.0.1
	x509-parser-0.15.1
	xattr-1.3.1
	xml-rs-0.8.20
	yansi-0.5.1
	zerocopy-0.7.32
	zerocopy-derive-0.7.32
	zeroize-1.7.0
	zeroize_derive-1.4.2
	zeromq-0.3.4
	zstd-0.12.4
	zstd-safe-6.0.6
	zstd-sys-2.0.10+zstd.1.5.6
"

inherit bash-completion-r1 cargo check-reqs llvm python-any-r1 toolchain-funcs

DESCRIPTION="A secure JavaScript and TypeScript runtime"
HOMEPAGE="https://deno.land"
SRC_URI="
	https://github.com/denoland/deno/releases/download/v${PV}/deno_src.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"
IUSE="static-libs bash-completion zsh-completion fish-completion"

BDEPEND="
	>=dev-build/gn-${GN_MIN_VER}
	app-alternatives/ninja
"
DEPEND="
	>=dev-libs/libffi-3.4.4
	>=sys-libs/zlib-1.3
	>=app-arch/zstd-1.5.5
	elibc_musl? ( debug? ( sys-libs/libexecinfo ) )
"

S="${WORKDIR}/deno"
DOCS=("README.md" "LICENSE.md" "Releases.md")

CHECKREQS_DISK_BUILD=8G

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	llvm_pkg_setup
	check-reqs_pkg_setup
}

src_unpack() {
	#https://bugs.gentoo.org/783372
	cargo_src_unpack
}

src_prepare() {
	cp -r "${ECARGO_VENDOR}/v8-${V8_VER}" "${WORKDIR}/v8" || die
	pushd "${WORKDIR}/v8" >/dev/null || die
	if tc-is-clang && (has_version "sys-devel/clang-common[default-compiler-rt]" || is-flagq -rtlib=compiler-rt); then
		eapply "${FILESDIR}/remove-libatomic.patch"
	fi
	if use elibc_musl; then
		eapply "${FILESDIR}/execinfo.patch"
	fi
	eapply "${FILESDIR}/build_from_source-1.41.2.patch"
	if [[ -z "${CXXSTDLIB}" ]]; then
		if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
			export CXXSTDLIB=c++
		else
			export CXXSTDLIB=stdc++
		fi
	fi
	popd >/dev/null || die

	cp -r "${ECARGO_VENDOR}/stacker-${STACKER_VER}" "${WORKDIR}/stacker"
	pushd "${WORKDIR}/stacker" >/dev/null || die
	eapply "${FILESDIR}/stacker.patch"
	popd >/dev/null || die

	cp -r "${ECARGO_VENDOR}/jobserver-0.1.29" "${WORKDIR}/jobserver"
	pushd "${WORKDIR}/jobserver" >/dev/null || die
	eapply "${FILESDIR}/jobserver-musl.patch"
	popd >/dev/null || die

	pushd "${S}" >/dev/null || die
	cat <<-_EOF_ >>Cargo.toml
		[patch.crates-io]
		v8 = { path = '../v8' }
		stacker = { path = '../stacker' }
		jobserver = { path = '../jobserver' }
	_EOF_
	if use elibc_musl; then
		eapply "${FILESDIR}/fix-stackoverflow.patch"
	fi
	eapply "${FILESDIR}/use-system-libraries.patch"
	popd >/dev/null || die

	default
}

src_configure() {
	python_setup

	export V8_FROM_SOURCE=1

	if ! tc-is-clang; then
		die "deno require CC=clang CXX=clang++"
	fi

	local myconf_gn="is_clang=true use_gold=false use_sysroot=false use_custom_libcxx=false v8_builtins_profiling_log_file=\"\""
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:default\""
	myconf_gn+=" clang_base_path=\"$(get_llvm_prefix "${LLVM_MAX_SLOT}")\""
	myconf_gn+=" fatal_linker_warnings=false treat_warnings_as_errors=false"
	export GN_ARGS="${myconf_gn}"
	cargo_src_configure --no-default-features
}

src_compile() {
	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	cargo_src_compile --bin deno -vv
}

src_test() {
	cargo_src_test --workspace
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
		"${S}"/target/release/deno completions bash >deno
		dobashcomp deno
	fi
	if use zsh-completion; then
		"${S}"/target/release/deno completions zsh >_deno
		insinto /usr/share/zsh/site-functions
		doins _deno
	fi
	if use fish-completion; then
		"${S}"/target/release/deno completions fish >deno.fish
		insinto /usr/share/fish/vendor_completions.d
		doins deno.fish
	fi
}