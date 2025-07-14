# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GN_MIN_VER=0.2217
LLVM_COMPAT=( 19 20 )
RUST_NEEDS_LLVM=1
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"
RUST_MIN_VER=1.82.0

V8_VER=137.1.0
STACKER_VER=0.1.15

CRATES="
	Inflector@0.11.4
	addr2line@0.24.2
	adler2@2.0.0
	adler@1.0.2
	aead-gcm-stream@0.4.0
	aead@0.5.2
	aes-gcm@0.10.3
	aes-kw@0.2.1
	aes@0.8.3
	ahash@0.8.11
	aho-corasick@1.1.3
	alloc-no-stdlib@2.0.4
	alloc-stdlib@0.2.2
	allocator-api2@0.2.21
	android_system_properties@0.1.5
	anstream@0.6.15
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.8
	anyhow@1.0.98
	arbitrary@1.4.1
	arrayvec@0.7.4
	ascii@1.1.0
	ash@0.38.0+1.3.281
	asn1-rs-derive@0.4.0
	asn1-rs-impl@0.1.0
	asn1-rs@0.5.2
	ast_node@3.0.0
	async-compression@0.4.11
	async-once-cell@0.5.4
	async-recursion@1.1.1
	async-stream-impl@0.3.5
	async-stream@0.3.5
	async-trait@0.1.88
	asynchronous-codec@0.7.0
	atomic-waker@1.1.2
	auto_impl@1.2.0
	autocfg@1.3.0
	aws-lc-rs@1.12.4
	aws-lc-sys@0.26.0
	axum-core@0.4.5
	axum@0.7.5
	az@1.2.1
	backtrace@0.3.74
	base16ct@0.2.0
	base32@0.5.1
	base64-simd@0.8.0
	base64@0.21.7
	base64@0.22.1
	base64ct@1.6.0
	bencher@0.1.5
	better_scoped_tls@1.0.0
	bincode@1.3.3
	bindgen@0.69.5
	bindgen@0.70.1
	bindgen@0.71.1
	bit-set@0.8.0
	bit-vec@0.8.0
	bitflags@1.3.2
	bitflags@2.8.0
	bitvec@1.0.1
	blake2@0.10.6
	block-buffer@0.10.4
	block-padding@0.3.3
	block@0.1.6
	boxed_error@0.2.3
	brotli-decompressor@4.0.1
	brotli@6.0.0
	bstr@1.9.1
	bumpalo@3.17.0
	bytemuck@1.21.0
	bytemuck_derive@1.8.1
	byteorder-lite@0.1.0
	byteorder@1.5.0
	bytes@1.9.0
	cache_control@0.2.0
	capacity_builder@0.5.0
	capacity_builder_macros@0.3.0
	caseless@0.2.1
	castaway@0.2.3
	cbc@0.1.2
	cc@1.2.16
	cexpr@0.6.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.37
	cipher@0.4.4
	clang-sys@1.8.1
	clap@4.5.30
	clap_builder@4.5.30
	clap_complete@4.5.45
	clap_complete_fig@4.5.2
	clap_lex@0.7.4
	clipboard-win@5.3.0
	cmake@0.1.50
	codespan-reporting@0.11.1
	color-print-proc-macro@0.3.5
	color-print@0.3.5
	colorchoice@1.0.0
	compact_str@0.7.1
	comrak@0.29.0
	console_static_text@0.8.3
	const-oid@0.9.6
	convert_case@0.4.0
	cooked-waker@5.0.0
	core-foundation-sys@0.8.6
	core-foundation@0.10.1
	core-foundation@0.9.4
	core-graphics-types@0.1.3
	countme@3.0.1
	cpufeatures@0.2.12
	cranelift-bforest@0.116.1
	cranelift-bitset@0.116.1
	cranelift-codegen-meta@0.116.1
	cranelift-codegen-shared@0.116.1
	cranelift-codegen@0.116.1
	cranelift-control@0.116.1
	cranelift-entity@0.116.1
	cranelift-frontend@0.116.1
	cranelift-isle@0.116.1
	cranelift-module@0.116.1
	cranelift-native@0.116.1
	cranelift@0.116.1
	crc-catalog@1.1.1
	crc32fast@1.4.2
	crc@2.1.0
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.11
	crossbeam-utils@0.8.21
	crossterm@0.28.1
	crossterm_winapi@0.9.1
	crypto-bigint@0.5.5
	crypto-common@0.1.6
	css_dataset@0.4.1
	ctr@0.9.2
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.3
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	dashmap@5.5.3
	data-encoding@2.5.0
	data-url@0.3.1
	dbus-secret-service@4.0.3
	dbus@0.9.7
	debug-ignore@1.0.5
	debugid@0.8.0
	deno-tower-lsp-macros@0.11.3
	deno_ast@0.48.1
	deno_cache_dir@0.23.0
	deno_core@0.352.0
	deno_doc@0.179.0
	deno_error@0.6.1
	deno_error_macro@0.6.1
	deno_graph@0.96.2
	deno_lint@0.76.0
	deno_lockfile@0.29.0
	deno_lockfile@0.30.2
	deno_media_type@0.2.9
	deno_native_certs@0.3.0
	deno_npm@0.34.0
	deno_npm@0.35.0
	deno_ops@0.228.0
	deno_panic@0.1.0
	deno_path_util@0.4.0
	deno_semver@0.8.1
	deno_task_shell@0.24.0
	deno_terminal@0.1.1
	deno_terminal@0.2.2
	deno_tower_lsp@0.4.3
	deno_unsync@0.4.4
	deno_whoami@0.1.0
	denokv_proto@0.11.0
	denokv_remote@0.11.0
	denokv_sqlite@0.11.0
	der-parser@8.2.0
	der@0.7.9
	der_derive@0.7.3
	deranged@0.3.11
	derive_arbitrary@1.4.1
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	derive_more@0.99.17
	deunicode@1.4.3
	dhat@0.3.3
	diff@0.1.13
	digest@0.10.7
	dirs-sys@0.4.1
	dirs@5.0.1
	displaydoc@0.2.4
	dissimilar@1.0.9
	dlopen2@0.6.1
	dlopen2_derive@0.4.0
	document-features@0.2.10
	dotenvy@0.15.7
	dprint-core-macros@0.1.0
	dprint-core@0.67.4
	dprint-plugin-json@0.20.0
	dprint-plugin-jupyter@0.2.0
	dprint-plugin-markdown@0.18.0
	dprint-plugin-typescript@0.95.8
	dprint-swc-ext@0.24.0
	dsa@0.6.3
	dunce@1.0.5
	dyn-clone@1.0.17
	ecb@0.1.2
	ecdsa@0.16.9
	ecow@0.2.3
	ed25519-dalek@2.1.1
	ed25519@2.2.3
	ed448-goldilocks@0.8.3
	editpe@0.1.0
	either@1.10.0
	elliptic-curve@0.13.8
	encoding_rs@0.8.35
	endian-type@0.1.2
	entities@1.0.1
	enum-as-inner@0.6.0
	env_filter@0.1.3
	env_logger@0.11.6
	equivalent@1.0.1
	errno@0.3.10
	error-code@3.2.0
	error_reporter@1.0.0
	esbuild_client@0.5.0
	eszip@0.93.0
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fancy-regex@0.14.0
	fast-socks5@0.9.6
	faster-hex@0.10.0
	fastrand@2.3.0
	fastwebsockets@0.8.0
	fd-lock@4.0.2
	fdeflate@0.3.4
	ff@0.13.0
	fiat-crypto@0.1.20
	fiat-crypto@0.2.7
	file_test_runner@0.7.3
	filetime@0.2.23
	fixedbitset@0.4.2
	fixedbitset@0.5.7
	flaky_test@0.2.2
	flaky_test_impl@0.2.2
	flate2@1.0.35
	float-cmp@0.9.0
	fluent-uri@0.1.4
	fnv@1.0.7
	foldhash@0.1.4
	foreign-types-macros@0.2.3
	foreign-types-shared@0.1.1
	foreign-types-shared@0.3.1
	foreign-types@0.3.2
	foreign-types@0.5.0
	form_urlencoded@1.2.1
	fqdn@0.3.4
	from_variant@2.0.0
	fs3@0.5.0
	fs_extra@1.3.0
	fsevent-sys@4.1.0
	fslock@0.2.1
	funty@2.0.0
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.3.31
	generator@0.8.4
	generic-array@0.14.7
	getrandom@0.2.14
	ghash@0.5.1
	gimli@0.31.1
	gl_generator@0.14.0
	glibc_version@0.1.2
	glob@0.3.1
	globset@0.4.14
	glow@0.16.0
	glutin_wgl_sys@0.6.1
	gpu-alloc-types@0.3.0
	gpu-alloc@0.6.0
	gpu-allocator@0.27.0
	gpu-descriptor-types@0.2.0
	gpu-descriptor@0.3.0
	group@0.13.0
	gzip-header@1.0.0
	h2@0.3.26
	h2@0.4.7
	halfbrown@0.2.5
	handlebars@6.1.0
	hash32@0.3.1
	hashbrown@0.12.3
	hashbrown@0.14.5
	hashbrown@0.15.2
	hashlink@0.10.0
	hashlink@0.8.4
	hdrhistogram@7.5.4
	heapless@0.8.0
	heck@0.4.1
	heck@0.5.0
	hermit-abi@0.3.9
	hex@0.4.3
	hexf-parse@0.2.1
	hickory-client@0.25.0-alpha.4
	hickory-proto@0.25.0-alpha.4
	hickory-resolver@0.25.0-alpha.4
	hickory-server@0.25.0-alpha.4
	hipstr@0.6.0
	hkdf@0.12.4
	hmac@0.12.1
	home@0.5.9
	hostname@0.3.1
	hstr@1.0.0
	html-escape@0.2.13
	http-body-util@0.1.2
	http-body@0.4.6
	http-body@1.0.0
	http@0.2.12
	http@1.1.0
	httparse@1.10.0
	httpdate@1.0.3
	humantime@2.1.0
	hyper-rustls@0.27.2
	hyper-timeout@0.5.2
	hyper-util@0.1.10
	hyper@0.14.28
	hyper@1.6.0
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
	ident_case@1.0.1
	idna@1.0.3
	idna_adapter@1.2.0
	if_chain@1.0.2
	ignore@0.4.20
	image@0.25.4
	import_map@0.22.0
	indexmap@1.9.3
	indexmap@2.9.0
	inotify-sys@0.1.5
	inotify@0.9.6
	inout@0.1.3
	ipconfig@0.3.2
	ipnet@2.9.0
	ipnetwork@0.20.0
	is-docker@0.2.0
	is-macro@0.3.5
	is-wsl@0.4.0
	is_terminal_polyfill@1.70.1
	itertools@0.12.1
	itertools@0.13.0
	itertools@0.14.0
	itoa@1.0.14
	jni-sys@0.3.0
	jobserver@0.1.32
	js-sys@0.3.77
	jsonc-parser@0.26.2
	junction@1.2.0
	jupyter-protocol@0.8.0
	k256@0.13.3
	keccak@0.1.5
	keyring@4.0.0-rc.1
	khronos-egl@6.0.0
	khronos_api@3.1.0
	kqueue-sys@1.0.4
	kqueue@1.0.8
	lazy-regex-proc_macros@3.1.0
	lazy-regex@3.1.0
	lazy_static@1.5.0
	lazycell@1.3.0
	lcms2-sys@4.0.5
	lcms2@6.1.0
	libc@0.2.172
	libdbus-sys@0.2.5
	libffi-sys@3.2.0
	libffi@4.0.0
	libloading@0.7.4
	libloading@0.8.5
	libm@0.2.8
	libredox@0.1.3
	libsqlite3-sys@0.32.0
	libsui@0.10.0
	libuv-sys-lite@1.48.2
	libz-sys@1.1.20
	linux-raw-sys@0.4.13
	litemap@0.7.3
	litrs@0.4.1
	lock_api@0.4.11
	log@0.4.27
	loom@0.7.2
	lsp-types@0.97.0
	malloc_buf@0.0.6
	malva@0.12.1
	markup_fmt@0.22.0
	match_cfg@0.1.0
	matchers@0.1.0
	matchit@0.7.3
	md-5@0.10.6
	md4@0.10.2
	memchr@2.7.4
	memmap2@0.9.5
	memoffset@0.9.1
	metal@0.31.0
	mime@0.3.17
	minimal-lexical@0.2.1
	miniz_oxide@0.7.2
	miniz_oxide@0.8.8
	mintex@0.1.3
	mio@0.8.11
	mio@1.0.3
	moka@0.12.10
	monch@0.5.0
	multimap@0.8.3
	naga@24.0.0
	napi-build@1.2.1
	napi-sys@2.2.2
	ndk-sys@0.5.0+25.2.9519653
	netif@0.1.6
	new_debug_unreachable@1.0.6
	nibble_vec@0.1.0
	nix@0.27.1
	nix@0.29.0
	nom@5.1.3
	nom@7.1.3
	notify@6.1.1
	ntapi@0.4.1
	ntest_timeout@0.9.3
	nu-ansi-term@0.46.0
	num-bigint-dig@0.8.4
	num-bigint@0.4.4
	num-complex@0.4.6
	num-conv@0.1.0
	num-integer@0.1.46
	num-iter@0.1.44
	num-rational@0.4.2
	num-traits@0.2.19
	num@0.4.2
	num_cpus@1.16.0
	objc@0.2.7
	object@0.36.3
	oid-registry@0.6.1
	once_cell@1.21.3
	opaque-debug@0.3.1
	open@5.1.2
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-src@300.5.0+3.5.0
	openssl-sys@0.9.108
	openssl@0.10.72
	opentelemetry-http@0.27.0
	opentelemetry-otlp@0.27.0
	opentelemetry-proto@0.27.0
	opentelemetry-semantic-conventions@0.27.0
	opentelemetry@0.27.0
	opentelemetry_sdk@0.27.1
	option-ext@0.2.0
	ordered-float@2.10.1
	ordered-float@4.6.0
	os_pipe@1.2.1
	outref@0.5.1
	overload@0.1.1
	p224@0.13.2
	p256@0.13.2
	p384@0.13.0
	p521@0.13.3
	par-core@1.0.3
	par-iter@1.0.2
	parking_lot@0.12.3
	parking_lot_core@0.9.9
	password-hash@0.5.0
	paste@1.0.15
	path-clean@0.1.0
	path-dedot@3.1.1
	pathdiff@0.2.1
	pbkdf2@0.12.2
	pem-rfc7468@0.7.0
	percent-encoding@2.3.1
	pest@2.7.15
	pest_derive@2.7.15
	pest_generator@2.7.15
	pest_meta@2.7.15
	petgraph@0.6.4
	petgraph@0.7.1
	phf@0.11.2
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.11.2
	pin-project-internal@1.1.5
	pin-project-lite@0.2.14
	pin-project@1.1.5
	pin-utils@0.1.0
	pkcs1@0.7.5
	pkcs5@0.7.1
	pkcs8@0.10.2
	pkg-config@0.3.30
	png@0.17.13
	polyval@0.6.2
	portable-atomic@1.10.0
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	prefix-trie@0.5.1
	presser@0.3.1
	pretty_assertions@1.4.1
	pretty_yaml@0.5.0
	prettyplease@0.2.17
	primeorder@0.13.6
	proc-macro-crate@3.2.0
	proc-macro-rules-macros@0.4.0
	proc-macro-rules@0.4.0
	proc-macro2@1.0.86
	profiling@1.0.15
	prost-build@0.13.3
	prost-derive@0.13.3
	prost-types@0.13.3
	prost@0.13.3
	psm@0.1.21
	ptr_meta@0.3.0
	ptr_meta_derive@0.3.0
	pulldown-cmark@0.11.2
	quick-error@1.2.3
	quick-junit@0.3.6
	quick-xml@0.31.0
	quinn-proto@0.11.9
	quinn-udp@0.5.8
	quinn@0.11.6
	quote@1.0.37
	radium@0.7.0
	radix_fmt@1.0.0
	radix_trie@0.2.1
	raffia@0.9.2
	raffia_macro@0.1.1
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	range-alloc@0.1.3
	raw-window-handle@0.6.1
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.4.1
	redox_users@0.4.5
	ref-cast-impl@1.0.22
	ref-cast@1.0.22
	regalloc2@0.11.1
	regex-automata@0.1.10
	regex-automata@0.4.6
	regex-syntax@0.6.29
	regex-syntax@0.8.3
	regex@1.10.6
	relative-path@1.9.2
	reqwest@0.12.5
	resolv-conf@0.7.0
	rfc6979@0.4.0
	ring@0.17.14
	ripemd@0.1.3
	ron@0.8.1
	rowan@0.15.15
	rsa@0.9.6
	runtimelib@0.28.0
	rusqlite@0.34.0
	rustc-demangle@0.1.24
	rustc-hash@1.1.0
	rustc-hash@2.1.1
	rustc_version@0.2.3
	rustc_version@0.4.0
	rusticata-macros@4.1.0
	rustix@0.38.34
	rustls-native-certs@0.7.0
	rustls-pemfile@2.1.2
	rustls-pki-types@1.8.0
	rustls-tokio-stream@0.5.0
	rustls-webpki@0.102.5
	rustls@0.23.11
	rustversion@1.0.15
	rustyline-derive@0.7.0
	rustyline@13.0.0
	ryu-js@1.0.1
	ryu@1.0.17
	saffron@0.1.0
	salsa20@0.10.2
	same-file@1.0.6
	schannel@0.1.23
	scoped-tls@1.0.1
	scopeguard@1.2.0
	scrypt@0.11.0
	sec1@0.7.3
	security-framework-sys@2.14.0
	security-framework@2.10.0
	security-framework@3.2.0
	semver-parser@0.7.0
	semver@0.9.0
	semver@1.0.25
	serde-value@0.7.0
	serde-wasm-bindgen@0.5.0
	serde@1.0.219
	serde_bytes@0.11.14
	serde_derive@1.0.219
	serde_json@1.0.140
	serde_repr@0.1.19
	serde_urlencoded@0.7.1
	serde_v8@0.261.0
	serdect@0.2.0
	sha1@0.10.6
	sha1_smol@1.0.0
	sha2@0.10.8
	sha3@0.10.8
	sharded-slab@0.1.7
	shell-escape@0.1.5
	shellexpand@3.1.0
	shlex@1.3.0
	signal-hook-mio@0.2.4
	signal-hook-registry@1.4.2
	signal-hook@0.3.17
	signature@2.2.0
	simd-adler32@0.3.7
	simd-json@0.14.0
	simdutf8@0.1.4
	siphasher@0.3.11
	slab@0.4.9
	slotmap@1.0.7
	slug@0.1.5
	sm3@0.4.2
	smallvec@1.14.0
	smartstring@1.0.1
	socket2@0.5.5
	sourcemap@9.2.0
	spin@0.9.8
	spirv@0.3.0+sdk-1.3.268.0
	spki@0.7.3
	sptr@0.3.2
	sqlformat@0.3.5
	stable_deref_trait@1.2.0
	stacker@0.1.15
	static_assertions@1.1.0
	string_enum@1.0.0
	stringcase@0.4.0
	strip-ansi-escapes@0.2.0
	strsim@0.11.1
	strum@0.26.3
	strum@0.27.1
	strum_macros@0.26.4
	strum_macros@0.27.1
	subtle@2.5.0
	swc_allocator@4.0.0
	swc_atoms@5.0.0
	swc_bundler@17.0.0
	swc_common@9.2.0
	swc_config@3.0.0
	swc_config_macro@1.0.0
	swc_ecma_ast@9.0.0
	swc_ecma_codegen@11.0.0
	swc_ecma_codegen_macros@2.0.0
	swc_ecma_lexer@12.0.0
	swc_ecma_loader@9.0.0
	swc_ecma_parser@12.0.0
	swc_ecma_transforms_base@13.0.0
	swc_ecma_transforms_classes@13.0.0
	swc_ecma_transforms_macros@1.0.0
	swc_ecma_transforms_optimization@14.0.0
	swc_ecma_transforms_proposal@13.0.0
	swc_ecma_transforms_react@15.0.0
	swc_ecma_transforms_typescript@15.0.0
	swc_ecma_utils@13.1.0
	swc_ecma_visit@9.0.0
	swc_eq_ignore_macros@1.0.0
	swc_graph_analyzer@10.0.0
	swc_macros_common@0.3.13
	swc_macros_common@1.0.0
	swc_visit@2.0.0
	swc_visit_macros@0.5.13
	syn@1.0.109
	syn@2.0.87
	sync_wrapper@1.0.1
	synstructure@0.12.6
	synstructure@0.13.1
	sys_traits@0.1.16
	sys_traits_macros@0.1.0
	tagptr@0.2.0
	tap@1.0.1
	tar@0.4.43
	target-lexicon@0.13.2
	temp_deno_which@0.1.0
	tempfile@3.10.1
	termcolor@1.4.1
	terminal_size@0.4.1
	text-size@1.1.1
	text_lines@0.6.0
	thiserror-impl@1.0.69
	thiserror-impl@2.0.12
	thiserror@1.0.69
	thiserror@2.0.12
	thousands@0.2.0
	thread_local@1.1.8
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tiny_pretty@0.2.0
	tinystr@0.7.6
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-eld@0.2.0
	tokio-macros@2.5.0
	tokio-metrics@0.3.1
	tokio-rustls@0.26.0
	tokio-socks@0.5.1
	tokio-stream@0.1.16
	tokio-util@0.7.10
	tokio-vsock@0.7.1
	tokio@1.45.1
	toml@0.5.11
	toml_datetime@0.6.8
	toml_edit@0.22.23
	tonic@0.12.3
	tower-http@0.6.1
	tower-layer@0.3.3
	tower-service@0.3.3
	tower@0.4.13
	tower@0.5.2
	tracing-attributes@0.1.28
	tracing-core@0.1.33
	tracing-log@0.2.0
	tracing-opentelemetry@0.28.0
	tracing-subscriber@0.3.19
	tracing@0.1.41
	triomphe@0.1.13
	try-lock@0.2.5
	twox-hash@1.6.3
	twox-hash@2.1.0
	typed-arena@2.0.2
	typenum@1.17.0
	ucd-trie@0.1.6
	unic-char-property@0.9.0
	unic-char-range@0.9.0
	unic-common@0.9.0
	unic-ucd-ident@0.9.0
	unic-ucd-version@0.9.0
	unicase@2.7.0
	unicode-id-start@1.2.0
	unicode-id@0.3.4
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-segmentation@1.11.0
	unicode-width@0.1.13
	unicode-width@0.2.0
	unicode-xid@0.2.6
	unicode_categories@0.1.1
	universal-hash@0.5.1
	untrusted@0.7.1
	untrusted@0.9.0
	url@2.5.4
	urlpattern@0.3.0
	utf-8@0.7.6
	utf16_iter@1.0.5
	utf8-width@0.1.7
	utf8_iter@1.0.4
	utf8parse@0.2.1
	uuid@1.8.0
	v8@137.1.0
	v8_valueserializer@0.1.1
	valuable@0.1.0
	value-trait@0.10.0
	vcpkg@0.2.15
	version_check@0.9.4
	vsimd@0.8.0
	vsock@0.5.1
	vte@0.11.1
	vte@0.13.1
	vte_generate_state_changes@0.1.1
	walkdir@2.5.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasite@0.1.0
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	wasm-streams@0.4.0
	wasm_dep_analyzer@0.3.0
	weak-table@0.3.2
	web-sys@0.3.77
	web-time@1.1.0
	web-transport-proto@0.2.3
	webpki-root-certs@0.26.6
	webpki-roots@0.26.1
	wgpu-core@24.0.0
	wgpu-hal@24.0.0
	wgpu-types@24.0.0
	which@4.4.2
	which@6.0.1
	whoami@1.5.1
	widestring@1.1.0
	win32job@2.0.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-core@0.58.0
	windows-implement@0.58.0
	windows-interface@0.58.0
	windows-result@0.2.0
	windows-strings@0.1.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows@0.52.0
	windows@0.58.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.6.26
	winnow@0.7.1
	winreg@0.50.0
	winreg@0.52.0
	winres@0.1.12
	winsafe@0.0.19
	write16@1.0.0
	writeable@0.5.5
	wtf8@0.1.0
	wyz@0.5.1
	x25519-dalek@2.0.1
	x509-parser@0.15.1
	xattr@1.3.1
	xml-rs@0.8.20
	yaml_parser@0.2.1
	yansi@1.0.1
	yoke-derive@0.7.4
	yoke@0.7.4
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
	zerofrom-derive@0.1.4
	zerofrom@0.1.4
	zeroize@1.7.0
	zeroize_derive@1.4.2
	zeromq@0.4.1
	zeromq@0.5.0-pre
	zerovec-derive@0.10.3
	zerovec@0.10.4
	zip@2.4.1
	zstd-safe@7.2.4
	zstd-sys@2.0.15+zstd.1.5.7
	zstd@0.13.2
	zune-core@0.4.12
	zune-jpeg@0.4.13
"

inherit bash-completion-r1 cargo check-reqs llvm-r1 python-any-r1 rust toolchain-funcs

DESCRIPTION="A secure JavaScript and TypeScript runtime"
HOMEPAGE="https://deno.land"
SRC_URI="
	https://github.com/denoland/deno/releases/download/v${PV}/deno_src.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/chromium/chromium/129.0.6668.62/tools/generate_shim_headers/generate_shim_headers.py -> deno_129_generate_shim_headers.py
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	CC0-1.0 ISC MIT MPL-2.0 MPL-2.0 Unicode-3.0 Unicode-DFS-2016 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"
IUSE="denort static-libs bash-completion zsh-completion fish-completion"

BDEPEND="
	>=dev-build/gn-${GN_MIN_VER}
	app-alternatives/ninja
"
DEPEND="
	>=dev-libs/libffi-3.4.4
	>=sys-libs/zlib-1.3
	>=app-arch/zstd-1.5.5
	dev-db/sqlite:3
	>=dev-libs/icu-74.2:=
	elibc_musl? ( debug? ( sys-libs/libexecinfo ) )
"

S="${WORKDIR}/deno"
DOCS=("README.md" "LICENSE.md" "Releases.md")

CHECKREQS_DISK_BUILD=8G

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
	llvm-r1_pkg_setup
	rust_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	#https://bugs.gentoo.org/783372
	cargo_src_unpack
}

src_prepare() {
	cp -r "${ECARGO_VENDOR}/v8-${V8_VER}" "${WORKDIR}/v8" || die
	pushd "${WORKDIR}/v8" >/dev/null || die
	if tc-is-clang && (has_version "llvm-core/clang-common[default-compiler-rt]" || is-flagq -rtlib=compiler-rt); then
		eapply "${FILESDIR}/remove-libatomic.patch"
	fi
	if use elibc_musl; then
		eapply "${FILESDIR}/execinfo.patch"
	fi
	eapply "${FILESDIR}/build_from_source-M137.patch"
	eapply "${FILESDIR}/v8-use-system-libraries.patch"
	pushd build >/dev/null || die
	eapply "${FILESDIR}/v8-compiler.patch"
	popd >/dev/null || die
	if [[ -z "${CXXSTDLIB}" ]]; then
		if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
			export CXXSTDLIB=c++
		else
			export CXXSTDLIB=stdc++
		fi
	fi
	install -Dm755 ${DISTDIR}/deno_129_generate_shim_headers.py tools/generate_shim_headers/generate_shim_headers.py
	build/linux/unbundle/replace_gn_files.py --system-libraries icu || die
	popd >/dev/null || die

	cp -r "${ECARGO_VENDOR}/stacker-${STACKER_VER}" "${WORKDIR}/stacker"
	pushd "${WORKDIR}/stacker" >/dev/null || die
	eapply "${FILESDIR}/stacker.patch"
	popd >/dev/null || die

	pushd "${S}" >/dev/null || die
	cat <<-_EOF_ >>Cargo.toml
		[patch.crates-io]
		v8 = { path = '../v8' }
		stacker = { path = '../stacker' }
	_EOF_
	if use elibc_musl; then
		eapply "${FILESDIR}/fix-stackoverflow.patch"
		eapply "${FILESDIR}/fix-musl.patch"
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
	myconf_gn+=" clang_base_path=\"$(get_llvm_prefix)\""
	myconf_gn+=" clang_resource_path=\"$(realpath $($CC --print-resource-dir))\""
	myconf_gn+=" fatal_linker_warnings=false treat_warnings_as_errors=false"
	myconf_gn+=" system_zlib=true icu_use_data_file=false"
	export GN_ARGS="${myconf_gn}"
	cargo_src_configure --no-default-features
}

src_compile() {
	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	cargo_src_compile --bin deno -vv
	use denort && cargo_src_compile --bin denort -vv
}

src_test() {
	cargo_src_compile --bin test_server -vv
	local server
	if use debug; then
		server=target/debug/test_server
	else
		server=target/release/test_server
	fi
	$server & cargo_src_test --workspace
}

src_install() {
	cargo_src_install --path ${S}/cli --bin deno
	use denort && cargo_src_install --path ${S}/cli/rt --bin denort
	einstalldocs
	use static-libs && dolib.a "$(cargo_target_dir)"/gn_out/obj/librusty_v8.a
	if use bash-completion; then
		"$(cargo_target_dir)"/deno completions bash > deno
		dobashcomp deno
	fi
	if use zsh-completion; then
		"$(cargo_target_dir)"/deno completions zsh > _deno
		insinto /usr/share/zsh/site-functions
		doins _deno
	fi
	if use fish-completion; then
		"$(cargo_target_dir)"/deno completions fish > deno.fish
		insinto /usr/share/fish/vendor_completions.d
		doins deno.fish
	fi
}
