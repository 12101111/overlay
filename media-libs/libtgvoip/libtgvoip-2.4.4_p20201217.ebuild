# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

EGIT_COMMIT="37d98e984fd6fa389262307db826d52ab86c8241"

DESCRIPTION="VoIP library for Telegram clients"
HOMEPAGE="https://github.com/telegramdesktop/libtgvoip"
SRC_URI="https://github.com/telegramdesktop/libtgvoip/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="+dsp pulseaudio"

DEPEND="
	dev-libs/openssl:0=
	media-libs/opus:=
	media-libs/alsa-lib
	!pulseaudio? ( media-sound/apulse[sdk] )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	# https://bugs.gentoo.org/717210
	echo 'libtgvoip_la_LIBTOOLFLAGS = --tag=CXX' >> Makefile.am || die
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-static
		--with-alsa
		--with-pulse
		$(use_enable dsp)
	)
	use dsp && append-cxxflags '-DTGVOIP_USE_DESKTOP_DSP_BUNDLED'
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
