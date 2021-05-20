# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils xdg git-r3

DESCRIPTION="Qt GUI fontend of v2ray"
HOMEPAGE="https://qv2ray.github.io/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
EGIT_SUBMODULES=( '*' '-3rdparty/zxing-cpp' '-libs/libqvb' )
EGIT_BRANCH=dev

LICENSE="GPL-3"
SLOT="0"
IUSE="libressl"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	net-libs/grpc
	dev-libs/protobuf
	net-misc/curl
"
RDEPEND="
	|| ( net-proxy/v2ray-bin net-proxy/v2ray )
	dev-libs/openssl:0=
	${DEPEND}
"
BDEPEND="
	dev-qt/linguist-tools:5
"

src_prepare() {
	cmake-utils_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=(
		-DQV2RAY_DEFAULT_VASSETS_PATH="/usr/share/v2ray"
		-DQV2RAY_DEFAULT_VCORE_PATH="/usr/bin/v2ray"
		-DQV2RAY_DISABLE_AUTO_UPDATE=on
	)
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
}
