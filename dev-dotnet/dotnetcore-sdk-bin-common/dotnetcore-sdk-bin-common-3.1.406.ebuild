# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils

MY_PV="${PV}"
VER="3.1.12"

DESCRIPTION="Common files shared between multiple slots of .NET Core"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

SRC_URI="
amd64? (
	elibc_glibc? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-x64.tar.gz )
	elibc_musl? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-musl-x64.tar.gz )
)
arm? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-arm.tar.gz )
arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux-arm64.tar.gz )
"

SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="*"
RESTRICT="splitdebug"

RDEPEND="~dev-dotnet/corehost-${VER}"
S=${WORKDIR}

src_prepare() {
	default

	# For current .NET Core versions, all the directories contain versioned files,
	# but the top-level files (the dotnet binary for example) are shared between versions,
	# and those are backward-compatible.
	# The exception from this above rule is packs/NETStandard.Library.Ref which is shared between >=3.0 versions.
	# These common files are installed by the non-slotted dev-dotnet/dotnetcore-sdk-bin-common
	# package, while the directories are installed by dev-dotnet/dotnetcore-sdk-bin which uses
	# slots depending on major .NET Core version.
	# This makes it possible to install multiple major versions at the same time.

	# Skip the versioned files (which are located inside sub-directories)
	find . -maxdepth 1 -type d ! -name . ! -name packs -exec rm -rf {} \; || die
	find ./packs -maxdepth 1 -type d ! -name packs ! -name NETStandard.Library.Ref -exec rm -rf {} \; || die
	rm dotnet
}

src_install() {
	local dest="opt/dotnet"
	dodir "${dest}"

	local ddest="${D}/${dest}"
	cp -a "${S}"/* "${ddest}/" || die
	cp "/${dest}/dotnet-${VER}" "${ED}/${dest}/dotnet"
	dosym "/${dest}/dotnet" "/usr/bin/dotnet"

	# set an env-variable for 3rd party tools
	echo -n "DOTNET_ROOT=/${dest}" > "${T}/90dotnet"
	doenvd "${T}/90dotnet"
}
