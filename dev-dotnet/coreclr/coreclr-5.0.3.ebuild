# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION=".NET Core Common Language Runtime (CoreCLR)"
HOMEPAGE="https://github.com/dotnet/runtime"
SRC_URI="https://github.com/dotnet/runtime/archive/v${PV}.tar.gz -> runtime-${PV}.tar.gz"

LICENSE="MIT"
SLOT="5.0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/coreclr-5.0-fix-atoll.patch
	"${FILESDIR}"/coreclr-5.0-runtime_version.patch
	"${FILESDIR}"/coreclr-5.0-remove-assert.patch
	"${FILESDIR}"/coreclr-5.0-static.patch
)

S="${WORKDIR}/runtime-${PV}/src/coreclr"

src_prepare() {
	pushd "${WORKDIR}/runtime-${PV}/src/libraries/Native/Unix/System.Globalization.Native" > /dev/null || die
		eapply "${FILESDIR}"/coreclr-5.0-icu.patch
	popd > /dev/null || die
	pushd "${WORKDIR}/runtime-${PV}" > /dev/null || die
		eapply "${FILESDIR}"/coreclr-5.0-fix-lld.patch
		eapply "${FILESDIR}"/coreclr-5.0-strip.patch
	popd > /dev/null || die
	cmake_src_prepare
}

src_configure() {
	versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"

	mkdir -p "${WORKDIR}/${P}_build"
	echo $versionSourceLine > "${WORKDIR}/${P}_build/version.c"

	mycmakeargs=(
		-DCLR_REPO_ROOT_DIR="${WORKDIR}/runtime-${PV}"
		-DCLR_ENG_NATIVE_DIR="${WORKDIR}/runtime-${PV}/eng/native"
		-DCMAKE_INSTALL_PREFIX="/opt/dotnet/shared/Microsoft.NETCore.App/${PV}"
	)

	cmake_src_configure
}
