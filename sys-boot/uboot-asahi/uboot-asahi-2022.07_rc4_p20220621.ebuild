# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="U-Boot for Apple Silicon Macs"
HOMEPAGE="http://asahilinux.org"

COMMIT="756d0269dd3f57e3dc7caccf57b78403adbc1e68"

SRC_URI="https://github.com/AsahiLinux/u-boot/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="~arm64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bc
	virtual/imagemagick-tools
"
S="${WORKDIR}/u-boot-${COMMIT}"

_emake() {
	emake V=1 \
		CPP="$(tc-getPROG CPP cpp)" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		AR="$(tc-getAR)" \
		AS="$(tc-getAS)" \
		NM="$(tc-getNM)" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		RANLIB="$(tc-getRANLIB)" \
		OBJDUMP="$(tc-getOBJDUMP)" \
		STRIP="$(tc-getSTRIP)" \
		HOSTCC="$(tc-getBUILD_CC)" \
		"$@"
}

src_configure() {
	default
	_emake apple_m1_defconfig
}

src_compile() {
	_emake
}

src_install() {
	insinto "/usr/lib/asahi-boot"
	doins u-boot-nodtb.bin
}
