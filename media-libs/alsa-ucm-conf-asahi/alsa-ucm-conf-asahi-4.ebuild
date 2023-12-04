# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ALSA ucm configuration files for Apple Silicon"
HOMEPAGE="https://github.com/AsahiLinux/alsa-ucm-conf-asahi"
SRC_URI="https://github.com/AsahiLinux/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	>=media-libs/alsa-topology-conf-1.2.5.1
	>=media-libs/alsa-lib-1.2.7.2
	>=media-plugins/alsa-plugins-1.2.7.1
	>=media-libs/alsa-ucm-conf-1.2.8
	>=media-video/pipewire-0.3.60
"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/alsa/ucm2/conf.d
	insopts -m644
	doins -r ucm2/conf.d/macaudio
}
