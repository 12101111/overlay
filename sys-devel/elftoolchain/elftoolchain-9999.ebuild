# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs git-r3

DESCRIPTION="Libraries/utilities to handle ELF objects (BSD drop in replacement for libelf)"
HOMEPAGE="https://wiki.freebsd.org/LibElf"
EGIT_REPO_URI="https://github.com/elftoolchain/elftoolchain.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

RDEPEND="
	app-arch/libarchive:=
	!dev-libs/elfutils
	!dev-libs/libelf"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/lsb-release
	>=sys-devel/bmake-20210314-r1
	virtual/yacc
	elibc_musl? (
		sys-libs/argp-standalone
		sys-libs/fts-standalone
		sys-libs/obstack-standalone
		sys-libs/musl-legacy-compat
	)"

PATCHES=(
)

src_prepare() {
	default

	# needs unpackaged TET tools
	rm -r test || die

	# sys-libs/musl-legacy-compat put a warning on #include <sys/cdefs.h>
	echo "" > ${S}/libelf/os.Linux.mk || die

	strip-unsupported-flags
	# clang-12: error: invalid argument '-fomit-frame-pointer' not allowed with '-pg'
	filter-flags -fomit-frame-pointer
}

src_configure() {
	tc-export AR CC LD RANLIB
	export MAKESYSPATH="${BROOT}"/usr/share/mk/bmake
}

src_compile() {
	bmake || die
}

src_install() {
	bmake \
		DESTDIR="${D}" \
		BINDIR="${EPREFIX}"/usr/bin/${CHOST}-elftoolchain \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		install || die

	# remove static libraries
	find "${ED}" -name '*.a' -delete || die
}
