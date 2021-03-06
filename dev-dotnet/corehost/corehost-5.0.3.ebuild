# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Generic driver for the .NET Core Command Line Interface"
HOMEPAGE="https://github.com/dotnet/runtime"
SRC_URI="https://github.com/dotnet/runtime/archive/v${PV}.tar.gz -> runtime-${PV}.tar.gz"

COMMIT="c636bbdc8a2d393d07c0e9407a4f8923ba1a21cb"
SDK="5.0.200"

LICENSE="MIT"
SLOT="5.0"
KEYWORDS="~amd64"

DEPEND="
	~dev-dotnet/coreclr-${PV}
	~dev-dotnet/corefx-${PV}
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

PATCHES=( "${FILESDIR}/corehost-5.0-add-missing-lib.patch" )
S="${WORKDIR}/runtime-${PV}/src/installer/corehost"

src_prepare() {
	pushd "${WORKDIR}/runtime-${PV}" > /dev/null || die
		eapply "${FILESDIR}"/corehost-5.0-fix-lld.patch
		eapply "${FILESDIR}"/corehost-5.0-strip.patch
	popd > /dev/null || die

	# don't build test
	sed -i \
		-e "/add_subdirectory(test_fx_ver)/d" \
		-e "/add_subdirectory(test)/d" \
		"${S}/cli/CMakeLists.txt" || die

	cmake_src_prepare
}

src_configure() {
	versionSourceLine="static char sccsid[] __attribute__((used)) = \"@(#)No version information produced\";"
	echo $versionSourceLine > "${WORKDIR}/version_file.c"

	local arch
	case ${ABI} in
		amd64) arch="AMD64";;
		arm) arch="ARM";;
		arm64) arch="ARM64";;
		*) die "Unsupport ABI"
	esac

	mycmakeargs=(
		-DCLR_ENG_NATIVE_DIR="${WORKDIR}/runtime-${PV}/eng/native"
		-DCORECLR_ARTIFACTS="/opt/dotnet/shared/Microsoft.NETCore.App/${PV}"
		-DNATIVE_LIBS_ARTIFACTS="/opt/dotnet/shared/Microsoft.NETCore.App/${PV}"
		-DCLI_CMAKE_PORTABLE_BUILD=1
		-DVERSION_FILE_PATH:STRING="${WORKDIR}/version_file.c"
		-DCLI_CMAKE_HOST_VER:STRING="${PV}"
		-DCLI_CMAKE_COMMON_HOST_VER:STRING="${PV}"
		-DCLI_CMAKE_HOST_FXR_VER:STRING="${PV}"
		-DCLI_CMAKE_HOST_POLICY_VER:STRING="${PV}"
		-DCLI_CMAKE_PKG_RID:STRING="$(get_rid)"
		-DCLI_CMAKE_COMMIT_HASH:STRING="${COMMIT}"
		-DCMAKE_INSTALL_PREFIX=/opt/dotnet
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	prefix="${ED}/opt/dotnet"
	framework="${prefix}/shared/Microsoft.NETCore.App/${PV}"
	native="${prefix}/packs/Microsoft.NETCore.App.Host.$(get_rid)/${PV}/runtimes/$(get_rid)/native"
	template="${prefix}/sdk/${SDK}/AppHostTemplate"
	mv "${prefix}/corehost/dotnet" "${prefix}/dotnet-${PV}"
	mkdir -p "${framework}"
	mv "${prefix}/corehost/libhostpolicy.so" "${framework}"
	mkdir -p "${native}"
	mv "${prefix}/corehost/apphost" "${native}"
	mv "${prefix}/corehost/singlefilehost" "${native}"
	mkdir -p "${template}"
	ln -s "${native}/apphost" "${template}"
	mv "${prefix}/corehost/libnethost.so" "${native}"
	for p in nethost.h coreclr_delegates.h hostfxr.h libnethost.a;do
		mv "${prefix}/corehost/$p" "${framework}"
		ln -s "${framework}/$p" "${native}"
	done

	mkdir -p "${prefix}/host/fxr/${PV}"
	mv "${prefix}/corehost/libhostfxr.so" "${prefix}/host/fxr/${PV}/"
	rm -rfv "${prefix}/corehost"
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
