# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

TG_OWT_COMMIT="7f965710b93c4dadd7e6f1ac739e708694df7929"
LIBYUV_COMMIT="ad890067f661dc747a975bc55ba3767fe30d4452"
LIBVPX_COMMIT="5b63f0f821e94f8072eb483014cfc33b05978bb9"

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"
SRC_URI="
	https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://chromium.googlesource.com/libyuv/libyuv/+archive/${LIBYUV_COMMIT}.tar.gz -> libyuv-${LIBYUV_COMMIT}.tar.gz
	https://chromium.googlesource.com/webm/libvpx/+archive/${LIBVPX_COMMIT}.tar.gz -> libvpx-${LIBVPX_COMMIT}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="pulseaudio"

# some things from this list are bundled
# work on unbundling in progress
DEPEND="
	dev-libs/openssl:=
	dev-libs/protobuf:=
	media-libs/alsa-lib
	media-libs/libjpeg-turbo:=
	media-libs/openh264:=
	media-libs/opus
	dev-libs/protobuf:=
	x11-libs/libXtst:=
	media-video/ffmpeg:=
	!pulseaudio? ( media-sound/apulse[sdk] )
	pulseaudio? ( media-sound/pulseaudio )
"

RDEPEND="${DEPEND}"

BDEPEND="
	virtual/pkgconfig
	amd64? ( dev-lang/yasm )
"

#PATCHES=( "${FILESDIR}/system-vpx.patch" )

S="${WORKDIR}/${PN}-${TG_OWT_COMMIT}"

src_unpack() {
	unpack ${P}.tar.gz || die
	tar xzf "${DISTDIR}/libyuv-${LIBYUV_COMMIT}.tar.gz" -C "${S}/src/third_party/libyuv" || die
	tar xzf "${DISTDIR}/libvpx-${LIBVPX_COMMIT}.tar.gz" -C "${S}/src/third_party/libvpx/source/libvpx" || die
}

src_configure() {
	# lacks nop, can't restore toc
	append-flags '-fPIC'
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=TRUE
		-DTG_OWT_PACKAGED_BUILD=TRUE
		-DTG_OWT_USE_PROTOBUF=TRUE
	)
	cmake_src_configure
}
