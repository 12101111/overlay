# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils toolchain-funcs git-r3

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="https://github.com/moonjit/moonjit"
EGIT_REPO_URI="https://github.com/moonjit/moonjit.git"

LICENSE="MIT"
# this should probably be pkgmoved to 2.0 for sake of consistency.
SLOT="2"
KEYWORDS="~amd64"
IUSE="lua52compat static-libs"

S="${WORKDIR}/luajit-${PV}"

_emake() {
	emake \
		Q= \
		PREFIX="${EPREFIX}/usr" \
		MULTILIB="$(get_libdir)" \
		DESTDIR="${D}" \
		HOST_CC="$(tc-getBUILD_CC)" \
		STATIC_CC="$(tc-getCC)" \
		DYNAMIC_CC="$(tc-getCC) -fPIC" \
		TARGET_LD="$(tc-getCC)" \
		TARGET_AR="$(tc-getAR) rcus" \
		BUILDMODE="$(usex static-libs mixed dynamic)" \
		TARGET_STRIP="true" \
		INSTALL_LIB="${ED%/}/usr/$(get_libdir)" \
		"$@"
}

src_compile() {
	_emake XCFLAGS="$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")"
}

src_install() {
	_emake install

	pax-mark m "${ED}usr/bin/luajit-${MY_PV}"

	HTML_DOCS="doc/." einstalldocs
}
