# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="SteamOS session compositing window manager"
HOMEPAGE="https://github.com/Plagman/gamescope"
SRC_URI="https://github.com/Plagman/gamescope/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE="screencast"
KEYWORDS="~arm64 ~amd64 ~x86"

DEPEND="
	x11-libs/libX11:=
	x11-libs/libXdamage:=
	x11-libs/libXcomposite:=
	x11-libs/libXrender:=
	x11-libs/libXext:=
	x11-libs/libXfixes:=
	x11-libs/libXxf86vm:=
	x11-libs/libXtst:=
	x11-libs/libXres:=
	x11-libs/libdrm:=
	dev-libs/wayland:=
	x11-libs/libxkbcommon:=
	sys-libs/libcap:=
	media-libs/libsdl2:=
	dev-libs/stb:=
	media-libs/vulkan-loader:=[X,wayland]
	>=gui-libs/wlroots-0.15.0:=[X]
	>=gui-libs/libliftoff-0.2.0:=
	screencast? ( >=media-video/pipewire-0.3.51:= )
"
RDEPEND="
	x11-base/xwayland
	${DEPEND}
"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	dev-util/vulkan-headers
	dev-util/glslang
"

src_prepare() {
	mkdir "${S}/subprojects/stb" || die
	cp "${FILESDIR}/stb.meson.build" "${S}/subprojects/stb/meson.build" || die
	default
}

src_configure() {
	local emesonargs=(
		$(meson_feature screencast pipewire)
		-Dforce_fallback_for=stb
	)
	meson_src_configure
}
