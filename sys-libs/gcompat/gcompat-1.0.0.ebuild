# Copyright 2018-2020 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal flag-o-matic

DESCRIPTION="The GNU C Library compatibility layer for musl"
HOMEPAGE="https://code.foxkit.us/adelie/gcompat"
KEYWORDS="~amd64 ~x86 ~arm64"
LICENSE="UoI-NCSA"
IUSE="+libucontext +obstack +fts"
SRC_URI="https://distfiles.adelielinux.org/source/${PN}/${P}.tar.xz"
SLOT="0"

DEPEND="
	libucontext? ( sys-libs/libucontext )
	obstack? ( sys-libs/obstack-standalone )
	fts? ( sys-libs/fts-standalone )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/more.patch" )

get_loader_name() {
	# Loosely based on Adélie APKBUILD
	# TODO: Check against glibc’s logic

	case "$ABI" in
		x86) echo "ld-linux.so.2" ;;
		amd64) echo "ld-linux-x86-64.so.2" ;;
		arm64) echo "ld-linux-aarch64.so.1" ;;
		arm) echo "ld-linux-armhf.so.3" ;;
		mips | powerpc | s390) echo "ld.so.1" ;;
	esac
}

get_glibc_libdir() {
	case "$ABI" in
		amd64) echo "lib64";;
		*) echo "lib";;
	esac
}

get_linker_path() {
	local arch=$(ldd 2>&1 | sed -n '1s/^musl libc (\(.*\))$/\1/p')
	echo "/lib/ld-musl-${arch}.so.1"
}

src_compile() {
	filter-flags "-Wl,--as-needed"

	emake \
		LINKER_PATH="$(get_linker_path)" \
		LOADER_NAME="$(get_loader_name)" \
		WITH_OBSTACK="$(usex obstack 'obstack-standalone' 'no')" \
		WITH_FTS="$(usex fts 'fts-standalone' 'no')" \
		$(usex libucontext WITH_LIBUCONTEXT=yes '')
}

src_install() {
	emake \
		LINKER_PATH="$(get_linker_path)" \
		LOADER_NAME="$(get_loader_name)" \
		WITH_OBSTACK="$(usex obstack 'obstack-standalone' 'no')" \
		WITH_FTS="$(usex fts 'fts-standalone' 'no')" \
		$(usex libucontext WITH_LIBUCONTEXT=yes '') \
		DESTDIR="${D}" \
		install

	mkdir -p "${ED}/$(get_glibc_libdir)"
	mv "${ED}/lib/$(get_loader_name)" "${ED}/$(get_glibc_libdir)/$(get_loader_name)"
}
