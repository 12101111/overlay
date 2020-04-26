# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils git-r3

DESCRIPTION="PAC plugin for Qv2ray to support connecting proxy with PAC"
HOMEPAGE="https://github.com/Qv2ray/QvPlugin-PAC"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	net-proxy/qv2ray
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	eqmake5
}

src_install(){
	insinto "/usr/share/qv2ray/plugins"
	insopts -m755
	doins "libQvPACPlugin.so"
}
