# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit chromium-2

DESCRIPTION="Cross platform application development framework based on web technologies"
HOMEPAGE="https://www.electronjs.org/"

REPO="https://github.com/electron/electron/releases/download"
SRC_URI="
https://atom.io/download/electron/v${PV}/node-v${PV}-headers.tar.gz -> electron-v${PV}-headers.tar.gz
amd64? ( ${REPO}/v${PV}/electron-v${PV}-linux-x64.zip )
x86? ( ${REPO}/v${PV}/electron-v${PV}-linux-ia32.zip )
arm? ( ${REPO}/v${PV}/electron-v${PV}-linux-armv7l.zip )
arm64? ( ${REPO}/v${PV}/electron-v${PV}-linux-arm64.zip )
"
LICENSE="BSD"
SLOT="${PV%%[.+]*}"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	sys-libs/glibc
	>=x11-libs/gtk+-3.24.16:3[X]
	>=media-libs/alsa-lib-1.2.1
	>=net-print/cups-2.2.13
	>=x11-libs/libnotify-0.7.8
	>=dev-libs/nss-3.26
	app-crypt/gnupg
	app-accessibility/at-spi2-atk
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	app-crypt/libsecret[crypt]
	app-eselect/eselect-electron
"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}"

_get_install_suffix() {
	local c=(${SLOT//\// })
	local slot=${c[0]}
	local suffix

	if [[ "${slot}" == "0" ]]; then
		suffix=""
	else
		suffix="-${slot}"
	fi

	echo -n "${suffix}"
}

_get_install_dir() {
	echo -n "/usr/$(get_libdir)/electron$(_get_install_suffix)"
}

src_install() {
	local install_dir="$(_get_install_dir)"
	local install_suffix="$(_get_install_suffix)"

	pushd locales > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	# Install Electron
	insinto "${install_dir}"
	exeinto "${install_dir}"
	doins -r .

	fperms 755 "${install_dir}"/electron
	fperms 4755 "${install_dir}"/chrome-sandbox

	cat > node <<EOF
#!/bin/sh
exec env ELECTRON_RUN_AS_NODE=1 "${install_dir}/electron" "\${@}"
EOF
	doexe node

	# Install Node headers
	insopts -m644
	local node_headers="/usr/include/electron${install_suffix}"
	insinto "${node_headers}"
	doins -r node_headers/include/node
	rm -rf "${ED}/${install_dir}/node_headers"
	# set up a symlink structure that npm expects..
	dodir "${node_headers}"/node/deps/{v8,uv}
	dosym . "${node_headers}"/node/src
	for var in deps/{uv,v8}/include; do
		dosym ../.. "${node_headers}"/node/${var}
	done

	dosym "${install_dir}/electron" "/usr/bin/electron${install_suffix}"
}
