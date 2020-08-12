# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs git-r3 portability

DESCRIPTION="Libraries/utilities to handle ELF objects (BSD drop in replacement for libelf)"
HOMEPAGE="https://wiki.freebsd.org/LibElf"
SRC_URI=""
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
}

src_compile() {
	$(get_bmake) || die
}

src_install() {
	$(get_bmake) DESTDIR=${ED} install || die
	if ! use utils; then
		rm -rf "${ED}"/usr/bin || die
	else
		mv ${ED}/usr/bin/ld ${ED}/usr/bin/ld.elf
	fi
	einstalldocs
}
