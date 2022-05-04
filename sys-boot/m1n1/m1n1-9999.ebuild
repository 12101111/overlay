# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="Asahi Linux bootloader"
HOMEPAGE="https://asahilinux.org"
EGIT_REPO_URI="https://github.com/AsahiLinux/m1n1.git"

LICENSE="MIT BSD-2 GPL-2 ZLIB BSD CC0-1.0 OFL-1.1 Apache-2.0 Unlicense"
SLOT="0"
#KEYWORDS="~arm64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/imagemagick-tools[png]
"

src_compile() {
	emake ARCH= RELEASE=1 \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		AS="$(tc-getAS)" \
		OBJCOPY="$(tc-getOBJCOPY)"
}

src_install() {
	insinto "/usr/lib/asahi-boot"
	doins "${S}/build/m1n1.bin"
}
