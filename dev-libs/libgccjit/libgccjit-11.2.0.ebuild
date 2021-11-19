# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# This ebuild is modified from toolchain.eclass

inherit flag-o-matic gnuconfig libtool multilib pax-utils toolchain-funcs prefix

DESCRIPTION="Just-In-Time Compilation library from GNU Compiler Collection"
HOMEPAGE="https://gcc.gnu.org/wiki/JIT"

# GCC_RELEASE_VER must always match 'gcc/BASE-VER' value.
# It's an internal representation of gcc version used for:
# - versioned paths on disk
# - 'gcc -dumpversion' output. Must always match <digit>.<digit>.<digit>.
GCC_RELEASE_VER=$(ver_cut 1-3 ${PV})
GCC_BRANCH_VER=$(ver_cut 1-2 ${PV})
GCCMAJOR=$(ver_cut 1 ${PV})
GCCMINOR=$(ver_cut 2 ${PV})
GCCMICRO=$(ver_cut 3 ${PV})
PATCH_VER="1"

SRC_URI="
	mirror://gnu/gcc/gcc-${PV}/gcc-${GCC_RELEASE_VER}.tar.xz
	mirror://gentoo/gcc-${GCC_RELEASE_VER}-patches-${PATCH_VER}.tar.bz2
"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
LICENSE="GPL-3+ LGPL-3+"
IUSE=""

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

S="${WORKDIR}/gcc-${GCC_RELEASE_VER}"

src_prepare() {
	eapply "${WORKDIR}"/patch/*.patch

	if use elibc_musl || [[ ${CATEGORY} = cross-*-musl* ]]; then
		eapply "${FILESDIR}"/cpu_indicator.patch
		eapply "${FILESDIR}"/posix_memalign.patch
		case $(tc-arch) in
			amd64|arm64|ppc64) eapply "${FILESDIR}"/gcc-pure64.patch ;;
		esac
	fi

	if [[ ${CATEGORY} != cross-* ]] ; then
		eapply "${FILESDIR}"/gcc-6.1-musl-libssp.patch
	fi

	default

	local actual_version=$(<"${S}"/gcc/BASE-VER)
	if [[ "${GCC_RELEASE_VER}" != "${actual_version}" ]]; then
		die "'${S}/gcc/BASE-VER' contains '${actual_version}', expected '${GCC_RELEASE_VER}'"
	fi

	# Fixup libtool to correctly generate .la files with portage
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	# update configure files
	local f
	einfo "Fixing misc issues in configure files"
	for f in $(grep -l 'autoconf version 2.13' $(find "${S}" -name configure)); do
		ebegin "  Updating ${f/${S}\//} [LANG]"
		patch "${f}" "${FILESDIR}"/gcc-configure-LANG.patch >&"${T}"/configure-patch.log ||
			eerror "Please file a bug about this"
		eend $?
	done
	sed -i 's|A-Za-z0-9|[:alnum:]|g' "${S}"/gcc/*.awk #215828

	# Prevent new texinfo from breaking old versions (see #198182, #464008)
	einfo "Remove texinfo (bug #198182, bug #464008)"
	eapply "${FILESDIR}"/gcc-configure-texinfo.patch

	# >=gcc-4
	if [[ -x contrib/gcc_update ]]; then
		einfo "Touching generated files"
		./contrib/gcc_update --touch |
			while read f; do
				einfo "  ${f%%...}"
			done
	fi
}

src_configure() {
	# dont want to funk ourselves
	filter-flags '-mabi*' -m31 -m32 -m64
	filter-flags -frecord-gcc-switches # 490738
	filter-flags -mno-rtm -mno-htm     # 506202
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
		--enable-languages="jit"
		--enable-shared
		--enable-host-shared
		--enable-default-pie
		--enable-default-ssp
		--disable-nls
		--disable-werror
		--disable-bootstrap
		--disable-multilib
		--disable-lto
		--disable-libgomp
		--disable-libssp
		--disable-libada
		--disable-libsanitizer
		--disable-libvtv
		--disable-libquadmath
		--disable-libquadmath-support
		--disable-libunwind-exceptions
	)

	case ${CHOST} in
	mingw* | *-mingw*)
		confgcc+=(--enable-threads=win32)
		;;
	*)
		confgcc+=(--enable-threads=posix)
		;;
	esac

	# __cxa_atexit is "essential for fully standards-compliant handling of
	# destructors", but apparently requires glibc.
	case ${CTARGET} in
	*-musl*)
		confgcc+=(--enable-__cxa_atexit)
		;;
	*-gnu*)
		confgcc+=(
			--enable-__cxa_atexit
			--enable-clocale=gnu
		)
		;;
	*-freebsd*)
		confgcc+=(--enable-__cxa_atexit)
		;;
	*-solaris*)
		confgcc+=(--enable-__cxa_atexit)
		;;
	esac

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

	# and now to do the actual configuration
	addwrite /dev/zero
	echo "${S}"/configure "${confgcc[@]}"

	# Older gcc versions did not detect bash and re-exec itself, so force the
	# use of bash.  Newer ones will auto-detect, but this is not harmful.
	CONFIG_SHELL="${EPREFIX}/bin/bash" \
	bash "${S}"/configure "${confgcc[@]}" || die "failed to run configure"

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
	emake -j1 DESTDIR="${D}" install-common install-driver install-lto-wrapper || die
	popd > /dev/null

	rm "${ED}/usr/bin/gcc"
	rm "${ED}/usr/bin/${CHOST}-gcc"
	#rm "${ED}/usr/libexec/gcc/${CHOST}/${GCC_RELEASE_VER}/cc1"

	# Punt some tools which are really only useful while building gcc
	find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}"

	# prune empty dirs left behind
	find "${ED}" -depth -type d -delete 2>/dev/null
}

