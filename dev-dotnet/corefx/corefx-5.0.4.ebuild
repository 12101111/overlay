# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION=".NET Core Libraries (CoreFX)"
HOMEPAGE="https://github.com/dotnet/runtime"
SRC_URI="https://github.com/dotnet/runtime/archive/v${PV}.tar.gz -> runtime-${PV}.tar.gz"

LICENSE="MIT"
SLOT="5.0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/runtime-${PV}/src/libraries/Native/Unix"

PATCHES=(
	"${FILESDIR}/corefx-5.0-gentoo-build.patch"
)

src_prepare() {
	pushd "${WORKDIR}/runtime-${PV}" > /dev/null || die
		eapply "${FILESDIR}"/corefx-5.0-strip.patch
	popd > /dev/null || die
	cmake_src_prepare
}

src_configure() {
	versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"

	mkdir -p "${WORKDIR}/${P}_build"
	echo $versionSourceLine > "${WORKDIR}/${P}_build/version.c"

	mycmakeargs=(
		-DCLR_ENG_NATIVE_DIR="${WORKDIR}/runtime-${PV}/eng/native"
		-DCMAKE_INSTALL_PREFIX="/opt/dotnet/shared/Microsoft.NETCore.App/${PV}"
	)

	cmake_src_configure
}

