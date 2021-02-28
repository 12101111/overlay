# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Generic driver for the .NET Core Command Line Interface"
HOMEPAGE="https://github.com/dotnet/core-setup"
SRC_URI="https://github.com/dotnet/core-setup/archive/v${PV}.tar.gz -> core-setup-${PV}.tar.gz"

COMMIT="0267ad09c6f2e2a37b23b7d230ffbf9e787dd388"
SDK="3.1.406"

LICENSE="MIT"
SLOT="3.1"
KEYWORDS="~amd64"

DEPEND="
	net-misc/curl:=
	dev-libs/icu:=
	virtual/krb5
	dev-libs/libgit2:=
	dev-util/lldb:=
	dev-util/lttng-ust:=
	dev-libs/openssl:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/core-setup-${PV}/src/corehost"

src_prepare() {
	default

	# don't build test
	sed -i \
		-e "/add_subdirectory(test_fx_ver)/d" \
		-e "/add_subdirectory(test)/d" \
		"${S}/cli/CMakeLists.txt" || die

	cmake_src_prepare
}

src_configure() {
	case ${ABI} in
        x86) nodearch="I386";;
        amd64) arch_define="AMD64";;
        arm) arch_define="ARM";;
        arm64) nodearch="ARM64";;
        *) die "unsupport ABI"
    esac

	versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"
	echo $versionSourceLine > "${WORKDIR}/version_file.c"

	mycmakeargs=(
		-DCLI_CMAKE_PORTABLE_BUILD=1
		-DCLI_CMAKE_PLATFORM_ARCH_${arch_define}=1
		-DVERSION_FILE_PATH:STRING="${WORKDIR}/version_file.c"
		-DCLI_CMAKE_HOST_VER:STRING="2.0.0"
		-DCLI_CMAKE_COMMON_HOST_VER:STRING="2.0.0"
		-DCLI_CMAKE_HOST_FXR_VER:STRING="2.0.0"
		-DCLI_CMAKE_HOST_POLICY_VER:STRING="2.0.0"
		-DCLI_CMAKE_PKG_RID:STRING="linux-${ABI}"
		-DCLI_CMAKE_COMMIT_HASH:STRING="${COMMIT}"
		-DCMAKE_INSTALL_PREFIX=/opt/dotnetcore-sdk-bin-${PV}
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	prefix="${ED}/opt/dotnetcore-sdk-bin-${PV}"
	framework="${prefix}/shared/Microsoft.NETCore.App/${PV}"
	native="${prefix}/packs/Microsoft.NETCore.App.Host.linux-x64/${PV}/runtimes/linux-x64/native"
	template="${prefix}/sdk/${SDK}/AppHostTemplate"
	mv "${prefix}/corehost/dotnet" "${prefix}"
	mkdir -p "${framework}"
	mv "${prefix}/corehost/libhostpolicy.so" "${framework}"
	mkdir -p "${native}"
	mv "${prefix}/corehost/apphost" "${native}"
	mkdir -p "${template}"
	ln -s "${native}/apphost" "${template}"
	mv "${prefix}/corehost/libnethost.so" "${native}"
	mv "${prefix}/corehost/nethost.h" "${native}"
	ln -s "${native}/nethost.h" "${framework}"
	mkdir -p "${prefix}/host/fxr/${PV}"
	mv "${prefix}/corehost/libhostfxr.so" "${prefix}/host/fxr/${PV}/"
	rm -rfv "${prefix}/corehost"
}

