# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="U-Boot for Apple Silicon Macs"
HOMEPAGE="http://asahilinux.org"

COMMIT="asahi-v$(ver_cut 1-3)-$(ver_cut 5)"

SRC_URI="
	https://github.com/AsahiLinux/u-boot/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="~arm64"

DEPEND=""
RDEPEND="${DEPEND}"
# copy from kernel-2.eclass
BDEPEND="
	app-arch/cpio
	dev-lang/perl
	sys-devel/bc
	sys-devel/bc
	sys-devel/bison
	sys-devel/flex
	sys-devel/make
	>=sys-libs/ncurses-5.2
	virtual/libelf
	virtual/pkgconfig
	sys-apps/dtc
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
	sed -i "s/CONFIG_VIDEO_FONT_8X16=y/# CONFIG_VIDEO_FONT_8X16 is not set/" .config || die
	sed -i "s/# CONFIG_VIDEO_FONT_16X32 is not set/CONFIG_VIDEO_FONT_16X32=y/" .config || die
}

src_compile() {
	_emake
}

src_install() {
	insinto "/usr/lib/asahi-boot"
	doins u-boot-nodtb.bin
}
