# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=".NET Core SDK ( prebuilt version )"
HOMEPAGE="https://dotnet.microsoft.com/"
SRC_URI="
amd64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-x64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-musl-x64.tar.gz )
)
arm? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm.tar.gz )
arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-arm64.tar.gz )
"
VER="6.0.3"

LICENSE="MIT"
SLOT="6.0"
KEYWORDS="~amd64 ~arm64"
IUSE=""
RESTRICT="splitdebug"

RDEPEND="
	app-crypt/mit-krb5
	=dev-dotnet/coreclr-${VER}
	=dev-dotnet/corefx-${VER}
	>=dev-dotnet/dotnetcore-sdk-bin-common-${PV}
	dev-libs/icu
	|| ( dev-libs/openssl dev-libs/openssl-compat:1.0.0 )
	dev-util/lldb
	net-misc/curl
	sys-apps/lsb-release
	sys-devel/llvm
	sys-libs/zlib
	!dev-dotnet/dotnetcore-sdk
	!dev-dotnet/dotnetcore-sdk-bin:0
	!dev-dotnet/dotnetcore-runtime-bin
	!dev-dotnet/dotnetcore-aspnet-bin
"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}"

# TODO:
# 1. rid modify
#   `rg "linux" -g "*.json" -l`
#   this ebuild:
#	sdk/3.1.406/RuntimeIdentifierGraph.json
#   shared/Microsoft.NETCore.App/3.1.12/Microsoft.NETCore.App.deps.json
#   shared/Microsoft.AspNetCore.App/3.1.12/Microsoft.AspNetCore.App.deps.json
#   corefx:
#   pkg/Microsoft.NETCore.Platforms/runtime.compatibility.json
#   pkg/Microsoft.NETCore.Platforms/runtime.json
#   pkg/Microsoft.Private.PackageBaseline/packageIndex.json
#	pkg/Microsoft.NETCore.Platforms/runtimeGroups.props
# 2. fix DEPEND

src_prepare() {
	einfo "remove prebuilt native binary and .NET Standard library"
	find . -maxdepth 1 -type f -exec rm -f {} \; || die
	rm -rfv host
	rm -rfv packs/Microsoft.NETCore.App.Host.$(get_rid)
	rm -rfv sdk/${PV}/AppHostTemplate
	rm -rfv shared/Microsoft.NETCore.App/${VER}/{createdump,*.so,*.h,SOS_README.md,*.a}
	rm -rf packs/NETStandard.Library.Ref || die
	default
}

src_install() {
	insinto /opt/dotnet
	doins -r .
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

