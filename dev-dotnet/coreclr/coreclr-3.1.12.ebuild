# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION=".NET Core Common Language Runtime (CoreCLR)"
HOMEPAGE="https://github.com/dotnet/coreclr"
SRC_URI="https://github.com/dotnet/coreclr/archive/v${PV}.tar.gz -> coreclr-${PV}.tar.gz"

LICENSE="MIT"
SLOT="3.1"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/gentoo-fix.patch"
)

src_configure() {
	versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"
	echo $versionSourceLine > "${WORKDIR}/version_file.c"

	mycmakeargs=(
		-DVERSION_FILE_PATH:STRING="${WORKDIR}/version_file.c"
		-DCMAKE_INSTALL_PREFIX="/opt/dotnetcore-sdk-bin-${PV}/shared/Microsoft.NETCore.App/${PV}"
	)

	cmake_src_configure
}
