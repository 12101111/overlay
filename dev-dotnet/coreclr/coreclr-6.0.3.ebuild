# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION=".NET Core Common Language Runtime (CoreCLR)"
HOMEPAGE="https://github.com/dotnet/runtime"
SRC_URI="https://github.com/dotnet/runtime/archive/v${PV}.tar.gz -> runtime-${PV}.tar.gz"

LICENSE="MIT"
SLOT="6.0"
KEYWORDS="~amd64"

# 2.13.0 break coreclr https://github.com/dotnet/runtime/issues/57784
DEPEND="
	<dev-util/lttng-ust-2.13.0:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/coreclr-5.0-runtime_version.patch
)

S="${WORKDIR}/runtime-${PV}/src/coreclr"

src_prepare() {
	pushd "${WORKDIR}/runtime-${PV}" > /dev/null || die
		eapply "${FILESDIR}"/coreclr-6.0-cmake.patch
		eapply "${FILESDIR}"/coreclr-6.0-static.patch
	popd > /dev/null || die
	cmake_src_prepare
}

src_configure() {
	versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"
	version_path="${S}/inc/version.c"
	echo $versionSourceLine > "${version_path}"

	mycmakeargs=(
		-DCLR_REPO_ROOT_DIR="${WORKDIR}/runtime-${PV}"
		-DCLR_ENG_NATIVE_DIR="${WORKDIR}/runtime-${PV}/eng/native"
		-DCMAKE_INSTALL_PREFIX="/opt/dotnet/shared/Microsoft.NETCore.App/${PV}"
		-DCLR_CMAKE_KEEP_NATIVE_SYMBOLS=true
		-DVERSION_FILE_PATH="${version_path}"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	prefix="${ED}/opt/dotnet"
	framework="${prefix}/shared/Microsoft.NETCore.App/${PV}"
	native="${prefix}/packs/Microsoft.NETCore.App.Host.$(get_rid)/${PV}/runtimes/$(get_rid)/native"
	mkdir -p "${native}"
	mv "${framework}/corehost/singlefilehost" "${native}"
	rm -rfv "${framework}/corehost"
}

get_rid() {
	local arch
	case ${ABI} in
		amd64) arch=x64;;
		*) arch=${ABI}
	esac
	if use elibc_glibc; then
		echo "linux-$arch"
	elif use elibc_musl; then
		echo "linux-musl-$arch"
	else
	die "Unsupport libc"
	fi
}

