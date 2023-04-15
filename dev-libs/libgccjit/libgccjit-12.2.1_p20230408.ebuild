# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is modified from toolchain.eclass

inherit edo flag-o-matic gnuconfig libtool multilib pax-utils toolchain-funcs prefix

DESCRIPTION="Just-In-Time Compilation library from GNU Compiler Collection"
HOMEPAGE="https://gcc.gnu.org/wiki/JIT"

PATCH_VER="14"
PATCH_GCC_VER="12.2.0"
MUSL_VER="7"
MUSL_GCC_VER="12.2.0"
GCCMAJOR=$(ver_cut 1 ${PV})
SNAPSHOT=${GCCMAJOR}-${PV##*_p}
DEV="https://dev.gentoo.org/~sam/distfiles/sys-devel/gcc"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
LICENSE="GPL-3+ LGPL-3+"
IUSE=""

SRC_URI="
	mirror://gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT}.tar.xz
	${DEV}/gcc-${PATCH_GCC_VER}-patches-${PATCH_VER}.tar.xz
	${DEV}/gcc-${MUSL_GCC_VER}-musl-patches-${MUSL_VER}.tar.xz
"

RDEPEND="
	sys-libs/zlib
	virtual/libiconv
	>=dev-libs/gmp-4.3.2:0=
	>=dev-libs/mpfr-2.4.2:0=
	>=dev-libs/mpc-0.8.1:0=
	!sys-devel/gcc
"
BDEPEND="
	>=sys-devel/bison-1.875
	>=sys-devel/flex-2.5.4
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/gcc-${SNAPSHOT}"

src_setup() {
	# We don't want to use the installed compiler's specs to build gcc
	unset GCC_SPECS

	# bug #265283
	unset LANGUAGES

	# See https://www.gnu.org/software/make/manual/html_node/Parallel-Output.html
	# Avoid really confusing logs from subconfigure spam, makes logs far
	# more legible.
	MAKEOPTS="--output-sync=line ${MAKEOPTS}"
}

src_prepare() {
	einfo "Applying Gentoo patches ..."
	eapply "${WORKDIR}"/patch/*.patch

	if use elibc_musl; then
		if [[ ${CATEGORY} == cross-* ]] ; then
			# We don't want to apply some patches when cross-compiling.
			if [[ -d "${WORKDIR}"/musl/nocross ]] ; then
				rm -fv "${WORKDIR}"/musl/nocross/*.patch || die
			else
				# Just make an empty directory to make the glob below easier.
				mkdir -p "${WORKDIR}"/musl/nocross || die
			fi
		fi
		local shopt_save=$(shopt -p nullglob)
		shopt -s nullglob
		einfo "Applying musl patches ..."
		eapply "${WORKDIR}"/musl/{,nocross/}*.patch
		${shopt_save}
	fi

	default

	# Make sure the pkg-config files install into multilib dirs.
	# Since we configure with just one --libdir, we can't use that
	# (as gcc itself takes care of building multilibs). bug #435728
	find "${S}" -name Makefile.in \
		-exec sed -i '/^pkgconfigdir/s:=.*:=$(toolexeclibdir)/pkgconfig:' {} + || die

	# Fixup libtool to correctly generate .la files with portage
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	# Update configure files
	local f
	einfo "Fixing misc issues in configure files"
	for f in $(grep -l 'autoconf version 2.13' $(find "${S}" -name configure)) ; do
		ebegin "  Updating ${f/${S}\/} [LANG]"
		patch "${f}" "${FILESDIR}"/gcc-configure-LANG.patch >& "${T}"/configure-patch.log \
			|| eerror "Please file a bug about this"
		eend $?
	done
	# bug #215828
	sed -i 's|A-Za-z0-9|[:alnum:]|g' "${S}"/gcc/*.awk || die

	# Prevent new texinfo from breaking old versions (see #198182, bug #464008)
	einfo "Remove texinfo (bug #198182, bug #464008)"
	eapply "${FILESDIR}"/gcc-configure-texinfo.patch

	# >=gcc-4
	if [[ -x contrib/gcc_update ]] ; then
		einfo "Touching generated files"
		./contrib/gcc_update --touch | \
			while read f ; do
				einfo "  ${f%%...}"
			done
	fi
}

src_configure() {
	# Avoid shooting self in foot
	filter-flags '-mabi*' -m31 -m32 -m64

	# bug #490738
	filter-flags -frecord-gcc-switches
	# bug #506202
	filter-flags -mno-rtm -mno-htm

	filter-flags '-fsanitize=*'

	tc-is-clang && append-flags -Wno-array-bounds

	strip-unsupported-flags

	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "CXXFLAGS=\"${CXXFLAGS}\""
	einfo "LDFLAGS=\"${LDFLAGS}\""

	confgcc=(
		--host=${CHOST}
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--with-system-zlib
		--enable-checking=release
		--enable-obsolete
		--enable-secureplt
		--enable-languages=jit
		--enable-shared
		--enable-host-shared
		--enable-default-pie
		--enable-default-ssp
		--enable-threads=posix
		--enable-__cxa_atexit
		--disable-nls
		--disable-werror
		--disable-libada
		--disable-bootstrap
		--disable-multilib
		--disable-lto
		--disable-libgomp
		--disable-libssp
		--disable-libada
		--disable-libsanitizer
		--disable-libvtv
		--disable-libatomic
		--disable-libquadmath
		--disable-libquadmath-support
		--disable-libunwind-exceptions
		--with-gcc-major-version-only
	)

	# Disable gcc info regeneration -- it ships with generated info pages
	# already.  Our custom version/urls/etc... trigger it.  #464008
	export gcc_cv_prog_makeinfo_modern=no

	# Do not let the X detection get in our way.  We know things can be found
	# via system paths, so no need to hardcode things that'll break multilib.
	# Older gcc versions will detect ac_x_libraries=/usr/lib64 which ends up
	# killing the 32bit builds which want /usr/lib.
	export ac_cv_have_x='have_x=yes ac_x_includes= ac_x_libraries='

	# In case gcc is symbol link to clang
	export acx_cv_cc_gcc_supports_ada=no

	# Build in a separate build tree
	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build >/dev/null

	# ...and now to do the actual configuration
	addwrite /dev/zero

	local gcc_shell="${BROOT}"/bin/sh
	CONFIG_SHELL="${gcc_shell}" edo "${gcc_shell}" "${S}"/configure "${confgcc[@]}" || die "failed to run configure"

	# return to whatever directory we were in before
	popd >/dev/null
}

src_compile() {
	touch "${S}"/gcc/c-gperf.h

	# Do not make manpages if we do not have perl ...
	[[ ! -x /usr/bin/perl ]] \
		&& find "${WORKDIR}"/build -name '*.[17]' -exec touch {} +

	pushd "${WORKDIR}"/build >/dev/null
	emake all-gcc || die
	popd >/dev/null
}


src_install() {
	pushd "${WORKDIR}"/build/gcc > /dev/null
	emake -j1 DESTDIR="${D}" install-common install-driver || die
	popd > /dev/null

	rm "${ED}/usr/bin/gcc"
	rm "${ED}/usr/bin/gcov"
	rm "${ED}/usr/bin/gcov-dump"
	rm "${ED}/usr/bin/gcov-tool"
	rm "${ED}/usr/bin/${CHOST}-gcc"
	rm "${ED}/usr/bin/${CHOST}-gcc-${GCCMAJOR}"
	rm "${ED}/usr/libexec/gcc/${CHOST}/${GCCMAJOR}/collect2"
	rm "${ED}/usr/libexec/gcc/${CHOST}/${GCCMAJOR}/cc1"

	# Punt some tools which are really only useful while building gcc
	find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}"

	# prune empty dirs left behind
	find "${ED}" -depth -type d -delete 2>/dev/null
}

