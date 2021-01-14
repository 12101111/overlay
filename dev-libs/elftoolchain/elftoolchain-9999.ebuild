# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal flag-o-matic toolchain-funcs git-r3 portability

DESCRIPTION="Libraries/utilities to handle ELF objects (BSD drop in replacement for libelf)"
HOMEPAGE="https://wiki.freebsd.org/LibElf"
EGIT_REPO_URI="https://github.com/elftoolchain/elftoolchain.git"
EGIT_BRANCH="trunk"

LICENSE="|| ( BSD ) "
SLOT="0"
IUSE="utils static-libs"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	app-arch/libarchive
	app-arch/sharutils
	dev-libs/expat
	!dev-libs/libelf
	!dev-libs/elfutils
	utils? ( !sys-devel/binutils[binutils] )"

DEPEND="${RDEPEND}
	virtual/yacc
	virtual/pmake
	sys-apps/lsb-release
	elibc_musl? (
		sys-libs/argp-standalone
		sys-libs/fts-standalone
		sys-libs/obstack-standalone
	)"

PATCHES=(
	"${FILESDIR}/0001-gelf_symshndx-allow-xndxdata-parameter-to-be-NULL.patch"
	"${FILESDIR}/elfdefinitions.patch"
)

src_prepare() {
	default
	cp ${FILESDIR}/make-toolchain-version libelftc/ || die
	rm -rf test || die
	rm -rf documentation || die
	strip-unsupported-flags
	filter-flags -fomit-frame-pointer
}

src_compile() {
	MAKE="$(get_bmake)" emake CC="$(tc-getCC)" LD="$(tc-getLD)" || die
}

src_install() {
	MAKE="$(get_bmake)" emake DESTDIR=${ED} install || die
	if ! use utils; then
		rm -rf "${ED}"/usr/bin || die
	else
		mv ${ED}/usr/bin/ld ${ED}/usr/bin/ld.elf
	fi
	einstalldocs
}
