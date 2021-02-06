# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal flag-o-matic toolchain-funcs portability

DESCRIPTION="Libraries/utilities to handle ELF objects (BSD drop in replacement for libelf)"
HOMEPAGE="https://wiki.freebsd.org/LibElf"
#sourceforge has a crappy download url system, I hope this will work
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
SRC_URI="https://netcologne.dl.sourceforge.net/project/elftoolchain/Sources/elftoolchain-0.7.1/elftoolchain-0.7.1.tar.bz2"

LICENSE="|| ( BSD ) "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~amd64-fbsd ~x86-fbsd"
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
	"${FILESDIR}/fix-fno-common.patch"
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
