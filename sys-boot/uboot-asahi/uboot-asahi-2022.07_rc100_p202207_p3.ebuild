# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="U-Boot for Apple Silicon Macs"
HOMEPAGE="http://asahilinux.org"

COMMIT="asahi-v2022.07-3"

SRC_URI="
	https://github.com/AsahiLinux/u-boot/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.alpinelinux.org/~mps/m1/apritzel-firt5-video.patch
	https://dev.alpinelinux.org/~mps/m1/mps-u-boot-ter12x24.patch
"

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
PATCHES=(
	"${DISTDIR}/apritzel-firt5-video.patch"
	"${DISTDIR}/mps-u-boot-ter12x24.patch"
)

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
	sed -i "s/CONFIG_VIDEO_FONT_8X16=y/# CONFIG_VIDEO_FONT_8X16 is not set/" .config || die
	sed -i "s/# CONFIG_VIDEO_FONT_TER16X32 is not set/CONFIG_VIDEO_FONT_TER16X32=y/" .config || die
}

src_compile() {
	_emake
}

src_install() {
	insinto "/usr/lib/asahi-boot"
	doins u-boot-nodtb.bin
}
