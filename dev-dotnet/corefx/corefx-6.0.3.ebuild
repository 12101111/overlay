# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION=".NET Core Libraries (CoreFX)"
HOMEPAGE="https://github.com/dotnet/runtime"
SRC_URI="https://github.com/dotnet/runtime/archive/v${PV}.tar.gz -> runtime-${PV}.tar.gz"

LICENSE="MIT"
SLOT="6.0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/openssl:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/runtime-${PV}/src/libraries/Native/Unix"

src_prepare() {
	pushd "${WORKDIR}/runtime-${PV}" > /dev/null || die
		eapply "${FILESDIR}"/corefx-6.0-cmake.patch
	popd > /dev/null || die
	cmake_src_prepare
}

src_configure() {
	versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"
	version_path="${WORKDIR}/version.c"
	echo $versionSourceLine > "${version_path}"

	mycmakeargs=(
		-DCLR_ENG_NATIVE_DIR="${WORKDIR}/runtime-${PV}/eng/native"
		-DCMAKE_INSTALL_PREFIX="/opt/dotnet/shared/Microsoft.NETCore.App/${PV}"
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=true
		-DVERSION_FILE_PATH="${version_path}"
	)

	cmake_src_configure
}

