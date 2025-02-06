# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit crossdev flag-o-matic multiprocessing python-any-r1 rust-toolchain toolchain-funcs

DESCRIPTION="Rust standard library, standalone (for crossdev)"
HOMEPAGE="https://www.rust-lang.org"


if [[ ${PV} = *beta* ]]; then
	betaver=${PV//*beta}
	ABI_VER=${PV//_beta*}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	MY_P="rustc-beta"
	SLOT="beta/${ABI_VER}"
	SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.xz -> rustc-${PV}-src.tar.xz"
	IS_DEV=""
elif [[ ${PV} = *rc* ]]; then
	rcver=${PV//*rc}
	ABI_VER=${PV//_rc*}
	RC_SNAPSHOT="${rcver:0:4}-${rcver:4:2}-${rcver:6:2}"
	MY_P="rustc-${ABI_VER}"
	SLOT="rc/${ABI_VER}"
	SRC="${RC_SNAPSHOT}/${MY_P}-src.tar.xz -> rustc-${PV}-src.tar.xz"
	IS_DEV="dev-"
else
	ABI_VER="$(ver_cut 1-2)"
	SLOT="stable/${ABI_VER}"
	MY_P="rustc-${PV}"
	SRC="${MY_P}-src.tar.xz"
	IS_DEV=""
fi

SRC_URI="https://${IS_DEV}static.rust-lang.org/dist/${SRC}"
S="${WORKDIR}/${MY_P}-src"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4"
# please do not keyword
#KEYWORDS="" #nowarn
IUSE="debug llvm-libunwind profiler"

BDEPEND="
	${PYTHON_DEPS}
	~dev-lang/rust-${PV}:=
"

DEPEND="||
	(
		>="${CATEGORY}"/gcc-4.7:*
		>="${CATEGORY}"/clang-3.5:*
		>="${CATEGORY}"/clang-crossdev-wrappers-17.0:*
	)
"

RDEPEND="${DEPEND}"

# need full compiler to run tests
RESTRICT="test"

QA_FLAGS_IGNORED="usr/lib/rust/${PV}/rustlib/.*/lib/lib.*.so"

toml_usex() {
	usex "$1" true false
}

pkg_pretend() {
	target_is_not_host || die "${PN} should only be used for cross"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default
}

_rust_abi() {
	local abi=$(rust_abi $@)
	local llvm
	if [[ ${CATEGORY} == cross_llvm-* ]]; then
		llvm="llvm"
	fi
	case $abi in
		x86_64-w64-mingw32) echo "x86_64-pc-windows-gnu$llvm";;
		i686-w64-mingw32) echo "i686-pc-windows-gnu$llvm";;
		*) echo $abi;;
	esac
}

src_configure() {
	# do the great cleanup
	strip-flags
	filter-flags '-mcpu=*' '-march=*' '-mtune=*' '-m32' '-m64'
	strip-unsupported-flags

	local rust_root x
	rust_root="$(rustc --print sysroot)"
	rtarget="$(rust_abi ${CTARGET})"
	rtarget="${ERUST_STD_RTARGET:-${rtarget}}" # some targets need to be custom.
	rbuild="$(rust_abi ${CBUILD})"
	rhost="$(rust_abi ${CHOST})"

	echo
	for x in CATEGORY rust_root rbuild rhost rtarget RUSTFLAGS CFLAGS CXXFLAGS LDFLAGS; do
		einfo "$(printf '%10s' ${x^^}:) ${!x}"
	done

	cat <<- EOF > "${S}"/config.toml
		# https://github.com/rust-lang/rust/issues/135358 (bug #947897)
		profile = "dist"
		change-id = 123711
		[llvm]
		download-ci-llvm = false
		[build]
		build = "${rbuild}"
		host = ["${rhost}"]
		target = ["${rtarget}"]
		cargo = "${rust_root}/bin/cargo"
		rustc = "${rust_root}/bin/rustc"
		submodules = false
		python = "${EPYTHON}"
		locked-deps = true
		vendor = true
		extended = true
		verbose = 2
		cargo-native-static = false
		optimized-compiler-builtins = true
		[install]
		prefix = "${EPREFIX}/usr/lib/${PN}/${PV}"
		sysconfdir = "etc"
		docdir = "share/doc/rust"
		bindir = "bin"
		libdir = "lib"
		mandir = "share/man"
		[rust]
		# https://github.com/rust-lang/rust/issues/54872
		codegen-units-std = 1
		optimize = true
		debug = $(toml_usex debug)
		debug-assertions = $(toml_usex debug)
		debuginfo-level-rustc = 0
		backtrace = true
		incremental = false
		default-linker = "$(tc-getCC)"
		rpath = false
		dist-src = false
		remap-debuginfo = true
		jemalloc = false
		deny-warnings = false
		[dist]
		src-tarball = false
		[target.${rtarget}]
		ar = "${CTARGET}-ar"
		cc = "${CTARGET}-cc"
		cxx = "${CTARGET}-c++"
		linker = "${CTARGET}-cc"
		ranlib = "${CTARGET}-ranlib"
		$(usev elibc_musl 'crt-static = false')
		llvm-libunwind = "$(usex llvm-libunwind system no)"
		profiler = $(toml_usex profiler)
	EOF

	if [[ "${CTARGET}" == *-musl* ]]; then
		cat <<- _EOF_ >> "${S}"/config.toml
			musl-root = "${EPREFIX}/usr/${CTARGET}/usr"
		_EOF_
	fi
	if [[ "${CTARGET}" == *-wasi* ]]; then
		cat <<- _EOF_ >> "${S}"/config.toml
			wasi-root = "${EPREFIX}/usr/${CTARGET}/"
		_EOF_
	fi

	einfo "${PN^} configured with the following settings:"
	cat "${S}"/config.toml || die
}

src_compile() {
	env RUST_BACKTRACE=1 \
		"${EPYTHON}" ./x.py build -vv --config="${S}"/config.toml -j$(makeopts_jobs) \
		library/std --stage 0 || die
}

src_test() {
	ewarn "${PN} can't run tests"
}

src_install() {
	local rustlib="lib/rust/${PV}/lib/rustlib"
	dodir "/usr/${rustlib}"
	pushd "build/${rhost}/stage0-sysroot/lib/rustlib" > /dev/null || die
	cp -pPRv "${rtarget}" "${ED}/usr/${rustlib}" || die
	popd > /dev/null || die
}
