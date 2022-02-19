# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Emulator of x86-based machines based on PCem"
HOMEPAGE="https://github.com/86Box/86Box"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dinput experimental +fluidsynth +munt +dynarec new-dynarec +slirp +threads +qt wayland"

DEPEND="
	media-libs/freetype:2=
	media-libs/libpng:=
	media-libs/libsdl2
	media-libs/openal
	media-libs/rtmidi
	sys-libs/zlib
	x11-libs/libX11
	dev-libs/libevdev
	slirp? ( net-libs/libslirp )
	qt? (
		dev-qt/qtcore:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
	wayland? ( dev-libs/wayland	)
"

RDEPEND="
	${DEPEND}
	fluidsynth? ( media-sound/fluidsynth )
	munt? ( media-libs/munt-mt32emu )
	wayland? ( dev-util/wayland-scanner )
"

BDEPEND="
	virtual/pkgconfig
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules:5
"

src_configure() {
	local mycmakeargs=(
		-DCPPTHREADS="$(usex threads)"
		-DDEV_BRANCH="$(usex experimental)"
		-DDINPUT="$(usex dinput)"
		-DDYNAREC="$(usex dynarec)"
		-DFLUIDSYNTH="$(usex fluidsynth)"
		-DMINITRACE="OFF"
		-DMUNT="$(usex munt)"
		-DNEW_DYNAREC="$(usex new-dynarec)"
		-DPREFER_STATIC="OFF"
		-DRELEASE="ON"
		-DSLIRP_EXTERNAL="$(usex slirp)"
		-DQT="$(usex qt)"
	)

	cmake_src_configure
}

pkg_postinst() {
	elog "In order to use 86Box, you will need some roms for various emulated systems."
	elog "See https://github.com/86Box/roms for more information."
}
