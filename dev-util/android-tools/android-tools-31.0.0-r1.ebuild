# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

MY_PV="31.0.0p1"
DESCRIPTION="Android platform tools (adb, fastboot, and mkbootimg)"
HOMEPAGE="https://android.googlesource.com/platform/system/core.git/"
SRC_URI="https://github.com/nmeum/android-tools/releases/download/${MY_PV}/android-tools-${MY_PV}.tar.xz"

# The entire source code is Apache-2.0, except for fastboot which is BSD-2.
LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~x86-linux"
IUSE=""
RESTRICT="test mirror"
S="${WORKDIR}/${PN}-${MY_PV}"

DEPEND="sys-libs/zlib:=
	dev-libs/libpcre2:=
	virtual/libusb:1=
	app-arch/lz4:=
	app-arch/zstd:=
	app-arch/brotli:=
	dev-libs/protobuf:=
	dev-cpp/gtest:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/go
	dev-lang/perl
"

PATCHES=(
    "${FILESDIR}/static.patch"
)
