# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="A window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://github.com/lbonn/rofi"
MY_PV="${PV%_p*}+wayland${PV#*_p}"
SRC_URI="https://github.com/lbonn/rofi/releases/download/${PV%_p*}%2Bwayland${PV#*_p}/rofi-${MY_PV}.tar.xz"
S="${WORKDIR}/rofi-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+drun test +windowmode +wayland +X"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-devel/bison
	>=sys-devel/flex-2.5.39
	virtual/pkgconfig
	>=dev-libs/wayland-protocols-1.17
"
RDEPEND="
	dev-libs/glib:2
	x11-libs/cairo[X,xcb(+)]
	x11-libs/gdk-pixbuf:2
	x11-libs/libxcb:=
	x11-libs/libxkbcommon[X]
	x11-libs/pango[X]
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-wm
	x11-misc/xkeyboard-config
	dev-libs/wayland
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	test? ( >=dev-libs/check-0.11 )
"

src_configure() {
	local emesonargs=(
		$(meson_use drun)
		$(meson_use windowmode window)
		$(meson_feature test check)
		$(meson_feature wayland)
		$(meson_feature X xcb)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
