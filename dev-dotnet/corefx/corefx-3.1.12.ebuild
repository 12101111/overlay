# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION=".NET Core Libraries (CoreFX)"
HOMEPAGE="https://github.com/dotnet/corefx"
SRC_URI="https://github.com/dotnet/corefx/archive/v${PV}.tar.gz -> corefx-${PV}.tar.gz"

LICENSE="MIT"
SLOT="3.1"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}/src/Native/Unix"

PATCHES=(
    "${FILESDIR}/gentoo-fix-3.1.12.patch"
)

src_configure() {
	versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"
	echo $versionSourceLine > "${WORKDIR}/version_file.c"

	mycmakeargs=(
		-DVERSION_FILE_PATH:STRING="${WORKDIR}/version_file.c"
		-DCMAKE_INSTALL_PREFIX="/opt/dotnet/shared/Microsoft.NETCore.App/${PV}"
	)

	cmake_src_configure
}
