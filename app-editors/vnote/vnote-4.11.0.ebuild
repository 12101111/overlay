# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.1
	aho-corasick@1.1.5
	android_system_properties@0.1.6
	approx@0.5.1
	ar_archive_writer@0.5.3
	arrayref@0.3.9
	arrayvec@0.7.8
	autocfg@1.5.1
	az@1.3.0
	base64@0.22.1
	base64@0.23.1
	biblatex@0.12.0
	bincode@1.3.3
	bit-set@0.8.0
	bit-vec@0.8.0
	bitflags@2.13.2
	blake3@1.8.7
	bumpalo@3.20.3
	by_address@1.2.1
	bytemuck@1.25.2
	bytemuck_derive@1.12.1
	byteorder-lite@0.1.0
	cc@1.8.0
	cfg-if@1.0.5
	chinese-number@0.7.8
	chinese-variant@1.1.6
	chrono@0.4.45
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	citationberg@0.7.0
	cobs@0.3.0
	codex@0.3.0
	color@0.3.3
	color_quant@1.1.0
	comemo-macros@0.5.1
	comemo@0.5.1
	constant_time_eq@0.4.2
	core-foundation-sys@0.8.7
	core-foundation@0.10.1
	core_maths@0.1.1
	cpufeatures@0.3.1
	crc32fast@1.5.2
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	crunchy@0.2.4
	csv-core@0.1.13
	csv@1.4.0
	data-url@0.3.2
	deranged@0.5.9
	dirs-sys@0.5.0
	dirs@6.0.0
	displaydoc@0.2.7
	ecow@0.2.6
	either@1.19.0
	enum-ordinalize-derive@4.4.2
	enum-ordinalize@4.4.2
	env_proxy@0.4.1
	equivalent@1.0.2
	errno@0.3.14
	euclid@0.22.14
	fancy-regex@0.16.2
	fastrand@2.5.0
	fdeflate@0.3.7
	fearless_simd@0.4.1
	fearless_simd@1.1.0
	filetime@0.2.29
	find-msvc-tools@0.1.14
	flate2@1.1.10
	float-cmp@0.9.0
	fnv@1.0.7
	foldhash@0.2.0
	font-types@0.11.3
	fontconfig-parser@0.5.8
	fontdb@0.23.0
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.2
	futures-core@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	getrandom@0.4.3
	gif@0.14.2
	glidesort@0.1.2
	glifo@0.1.1
	guillotiere@0.7.0
	half@2.7.1
	hashbrown@0.17.1
	hayagriva@0.10.1
	hayro-ccitt@0.3.0
	hayro-ccitt@0.4.0
	hayro-cmap@0.1.0
	hayro-interpret@0.7.0
	hayro-jbig2@0.3.1
	hayro-jpeg2000@0.3.5
	hayro-postscript@0.1.0
	hayro-svg@0.7.0
	hayro-syntax@0.7.2
	hayro-write@0.7.0
	hayro@0.7.1
	heck@0.5.0
	hypher@0.1.8
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	icu_collator@2.3.1
	icu_collator_data@2.3.0
	icu_collections@2.3.0
	icu_locale@2.3.1
	icu_locale_core@2.3.0
	icu_locale_data@2.3.0
	icu_locale_fallback@2.3.0
	icu_locale_fallback_data@2.3.0
	icu_normalizer@2.3.0
	icu_normalizer_data@2.3.0
	icu_properties@2.3.0
	icu_properties_data@2.3.0
	icu_provider@2.3.1
	icu_provider_blob@2.3.0
	icu_segmenter@2.3.0
	icu_segmenter_data@2.3.0
	idna@1.1.0
	idna_adapter@1.2.2
	image-webp@0.2.4
	image@0.25.10
	imagesize@0.14.0
	indexmap@2.14.2
	infer@0.19.0
	itoa@1.0.18
	js-sys@0.3.106
	kamadak-exif@0.6.1
	krilla-svg@0.8.1
	krilla@0.8.2
	kurbo@0.13.1
	libc@0.2.190
	libm@0.2.16
	libredox@0.1.25
	linebender_resource_handle@0.1.1
	linked-hash-map@0.5.6
	linux-raw-sys@0.12.1
	lipsum@0.9.1
	litemap@0.8.3
	lock_api@0.4.14
	log@0.4.34
	memchr@2.8.3
	memmap2@0.9.11
	miniz_oxide@0.8.9
	miniz_oxide@0.9.1
	moxcms@0.8.1
	mutate_once@0.1.2
	native-tls@0.2.18
	num-bigint@0.4.8
	num-conv@0.2.2
	num-integer@0.1.47
	num-traits@0.2.19
	object@0.39.1
	once_cell@1.21.4
	openssl-macros@0.1.1
	openssl-probe@0.2.1
	openssl-sys@0.9.117
	openssl@0.10.81
	option-ext@0.2.0
	palette@0.7.7
	palette_derive@0.7.7
	palette_math@0.7.7
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	paste@1.0.15
	pdf-writer@0.15.0
	peniko@0.6.1
	percent-encoding@2.3.2
	phf@0.13.1
	phf_generator@0.13.1
	phf_macros@0.13.1
	phf_shared@0.13.1
	pic-scale@0.7.12
	pico-args@0.5.0
	pin-project-lite@0.2.17
	pixglyph@0.6.1
	pkg-config@0.3.34
	plist@1.10.1
	png@0.18.1
	polycool@0.4.0
	portable-atomic@1.15.0
	postcard@1.1.3
	potential_utf@0.1.6
	powerfmt@0.2.1
	ppv-lite86@0.2.21
	proc-macro-hack@0.5.20+deprecated
	proc-macro2@1.0.107
	psm@0.1.32
	pxfm@0.1.30
	quick-error@2.0.1
	quick-xml@0.38.4
	quick-xml@0.42.0
	quote@1.0.47
	r-efi@6.0.0
	rand@0.8.8
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.13.0
	rayon@1.12.0
	read-fonts@0.39.2
	redox_syscall@0.5.18
	redox_users@0.5.3
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	resvg@0.47.0
	rgb@0.8.53
	roman-numerals-rs@3.1.0
	roxmltree@0.20.0
	roxmltree@0.21.1
	rust_decimal@1.43.0
	rustc-hash@2.1.3
	rustix@1.1.5
	rustversion@1.0.23
	rustybuzz@0.20.1
	ryu@1.0.23
	same-file@1.0.6
	schannel@0.1.29
	scopeguard@1.2.0
	security-framework-sys@2.17.0
	security-framework@3.7.0
	semver@1.0.28
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.154
	serde_path_to_error@0.1.20
	serde_spanned@0.6.9
	serde_yaml@0.9.34+deprecated
	shlex@2.0.1
	simd-adler32@0.3.10
	simplecss@0.2.2
	siphasher@1.0.4
	skrifa@0.42.1
	slab@0.4.12
	slotmap@1.1.1
	smallvec@1.16.3
	spin@0.9.9
	stable_deref_trait@1.2.1
	stacker@0.1.25
	strict-num@0.1.1
	strum@0.27.2
	strum_macros@0.27.2
	subsetter@0.2.6
	svgtypes@0.16.1
	syn@2.0.119
	syn@3.0.9
	synstructure@0.14.0
	syntect@5.3.0
	tar@0.4.46
	tempfile@3.27.0
	thin-vec@0.2.21
	thiserror-impl@2.0.21
	thiserror@2.0.21
	time-core@0.1.9
	time-macros@0.2.32
	time@0.3.55
	tiny-skia-path@0.12.0
	tiny-skia@0.12.0
	tinystr@0.8.4
	tinyvec@1.13.3
	toml@0.8.23
	toml_datetime@0.6.11
	toml_edit@0.22.27
	toml_write@0.1.2
	ttf-parser@0.25.1
	two-face@0.4.5
	typed-arena@2.0.2
	typst-assets@0.15.1
	typst-eval@0.15.1
	typst-html@0.15.1
	typst-ide@0.15.1
	typst-kit@0.15.1
	typst-layout@0.15.1
	typst-library@0.15.1
	typst-macros@0.15.1
	typst-pdf@0.15.1
	typst-realize@0.15.1
	typst-render@0.15.1
	typst-svg@0.15.1
	typst-syntax@0.15.1
	typst-timing@0.15.1
	typst-utils@0.15.1
	typst@0.15.1
	unic-langid-impl@0.9.6
	unic-langid-macros-impl@0.9.6
	unic-langid-macros@0.9.6
	unic-langid@0.9.6
	unicode-bidi-mirroring@0.4.0
	unicode-bidi@0.3.18
	unicode-ccc@0.4.0
	unicode-ident@1.0.27
	unicode-math-class@0.1.0
	unicode-normalization@0.1.25
	unicode-properties@0.1.4
	unicode-script@0.5.8
	unicode-segmentation@1.13.3
	unicode-vo@0.1.0
	unsafe-libyaml@0.2.11
	unscanny@0.1.0
	ureq@2.12.1
	url@2.5.8
	usvg@0.47.0
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	vcpkg@0.2.15
	vello_common@0.0.8
	vello_common@0.0.9
	vello_cpu@0.0.8
	version_check@0.9.5
	walkdir@2.5.0
	wasm-bindgen-macro-support@0.2.129
	wasm-bindgen-macro@0.2.129
	wasm-bindgen-shared@0.2.129
	wasm-bindgen@0.2.129
	wasmi@1.1.0
	wasmi_collections@1.1.0
	wasmi_core@1.1.0
	wasmi_ir@1.1.0
	wasmparser@0.239.0
	weezl@0.1.12
	winapi-util@0.1.11
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.61.2
	winnow@0.7.15
	write-fonts@0.48.1
	write16@1.0.0
	writeable@0.6.4
	xattr@1.6.1
	xmlwriter@0.1.0
	xmp-writer@0.3.3
	yaml-rust@0.4.5
	yoke-derive@0.8.4
	yoke@0.8.3
	zerocopy-derive@0.8.62
	zerocopy@0.8.62
	zerofrom-derive@0.1.8
	zerofrom@0.1.8
	zerotrie@0.2.5
	zerovec-derive@0.11.6
	zerovec@0.11.8
	zlib-rs@0.6.8
	zmij@1.0.23
	zune-core@0.5.3
	zune-jpeg@0.5.15
"

# Only the optional Typst helper (libs/vtextedit/tools/typst-backend) needs rust, gated behind USE=typst.
CARGO_OPTIONAL=1
# tools/typst-backend/rust-toolchain.toml
RUST_MIN_VER="1.99"

inherit cargo cmake xdg git-r3

DESCRIPTION="Qt-based, free and open source note-taking application, focusing on Markdown"
HOMEPAGE="https://vnotex.github.io/vnote"
EGIT_REPO_URI="https://github.com/vnotex/vnote.git"
EGIT_COMMIT="v${PV}"

KEYWORDS="~amd64"
SLOT="4"

LICENSE="LGPL-3 Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD MIT MPL-2.0 Unicode-3.0 ZLIB
	|| ( 0BSD CC0-1.0 )"

IUSE="+typst"
BDEPEND="
	typst? ( ${RUST_DEPEND} )
"
DEPEND="
	dev-qt/qtbase:6=[X,cups,gui,network,sql,widgets]
	dev-qt/qtdeclarative:6=
	dev-qt/qtwebchannel:6=
	typst? (
	    dev-qt/qtwebengine:6[pdfium]
		dev-libs/openssl
	)
	!typst? ( dev-qt/qtwebengine:6 )
	dev-qt/qtsvg:6=
	dev-libs/qtkeychain:=
	dev-libs/pugixml
	>=dev-libs/libgit2-1.9.2
	net-misc/curl[ssl]
"
RDEPEND="${DEPEND}"

# Commits pinned by libs/vxcore/third_party/CMakeLists.txt (FetchContent vxcore_sodium).
SODIUM_CMAKE_COMMIT="9b2848dfc1b917a9410f0de9d81059b26cbfaa8d"
SODIUM_COMMIT="93a7d0d41fe2e32409b5d00386946f491750b7de" # libsodium submodule of libsodium-cmake
SRC_URI="
	https://github.com/robinlinden/libsodium-cmake/archive/${SODIUM_CMAKE_COMMIT}.tar.gz
		-> libsodium-cmake-${SODIUM_CMAKE_COMMIT}.tar.gz
	https://github.com/jedisct1/libsodium/archive/${SODIUM_COMMIT}.tar.gz
		-> libsodium-${SODIUM_COMMIT}.tar.gz
	typst? ( ${CARGO_CRATE_URIS} )
"

src_unpack() {
	git-r3_src_unpack
	cargo_src_unpack
	mv "libsodium-cmake-${SODIUM_CMAKE_COMMIT}" libsodium-cmake || die
	# The archive contains an empty libsodium/ placeholder for the git submodule.
	rmdir libsodium-cmake/libsodium || die
	mv "libsodium-${SODIUM_COMMIT}" libsodium-cmake/libsodium || die
}

src_prepare() {
	sed -i -e "s|VNote|vnote|g" CMakeLists.txt || die
	sed -i -e "s|^add_library(VSyntaxHighlighting)$|add_library(VSyntaxHighlighting STATIC)|" \
		libs/vtextedit/libs/syntax-highlighting/src/lib/CMakeLists.txt || die
	sed -i -e "s|add_library(qhotkey|add_library(qhotkey STATIC|g" \
		libs/QHotkey/CMakeLists.txt || die
	sed -i -e "s|keychain.h|qt6keychain/keychain.h|g" src/core/services/synccredentialsstore.cpp || die
	sed -i -e "s|add_subdirectory(cmark)|add_subdirectory(cmark EXCLUDE_FROM_ALL)|g" libs/vtextedit/libs/CMakeLists.txt || die
	# don't clone it from GitHub during the build.
	sed -i -e '/GIT_REPOSITORY https:\/\/github.com\/robinlinden\/libsodium-cmake.git/d' \
		-e "s|GIT_TAG ${SODIUM_CMAKE_COMMIT}|SOURCE_DIR \"${WORKDIR}/libsodium-cmake\"|" \
		-e '/# This adapter pins official libsodium at /d' \
		-e '/GIT_SUBMODULES_RECURSE TRUE/d' \
		libs/vxcore/third_party/CMakeLists.txt || die
	pushd "${S}/libs/vxcore" > /dev/null || die
	eapply "${FILESDIR}/unbundle-libgit2.patch"
	eapply "${FILESDIR}/unbundle-curl-pugixml.patch"
	popd > /dev/null || die
	# Don't install license files for libs that are no longer bundled.
	eapply "${FILESDIR}/drop-unbundled-lib-licenses.patch"
	# Don't force to build the Typst editor and its Rust helper
	eapply "${FILESDIR}/typst-optional.patch"
	cmake_src_prepare
}

src_configure() {
	# export CARGO_NET_OFFLINE=true
	local mycmakeargs=(
		-DVTEXTEDIT_ENABLE_TYPST=$(usex typst ON OFF)
	)
	cmake_src_configure
}
