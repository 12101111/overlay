# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=".NET Core SDK"
HOMEPAGE="https://dotnet.microsoft.com/"
MY_PV="${PV}-SDK"
SRC_URI="https://github.com/dotnet/source-build/archive/v${MY_PV}.tar.gz -> dotnet-source-build-${PV}.tar.gz"

LICENSE="MIT"
SLOT="3.1"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/source-build-${MY_PV}"

src_prepare() {
	git init -b build
	default
}

src_configure() {
	arcadeLine=`grep -m 1 'Microsoft\.DotNet\.Arcade\.Sdk' "global.json"`
	sdkLine=`grep -m 1 'dotnet' "global.json"`
	arcadePattern="\"Microsoft\.DotNet\.Arcade\.Sdk\" *: *\"(.*)\""
	sdkPattern="\"dotnet\" *: *\"(.*)\""
	if [[ $arcadeLine =~ $arcadePattern ]]; then
  		export ARCADE_BOOTSTRAP_VERSION=${BASH_REMATCH[1]}
	fi

	CUSTOM_SDK_DIR=/opt/dotnetcore-sdk-bin-3.1.12
	export SDK_VERSION=`"$CUSTOM_SDK_DIR/dotnet" --version`
	einfo "Using custom bootstrap SDK from '$CUSTOM_SDK_DIR', version $SDK_VERSION"
	CLIPATH="$CUSTOM_SDK_DIR"
	SDKPATH="$CLIPATH/sdk/$SDK_VERSION"
	export _InitializeDotNetCli="$CLIPATH"
	export CustomDotNetSdkDir="$CLIPATH"
	einfo "Found bootstrap SDK $SDK_VERSION, bootstrap Arcade $ARCADE_BOOTSTRAP_VERSION"
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
	export DOTNET_MULTILEVEL_LOOKUP=0
	export NUGET_PACKAGES="${S}/packages/restored/"
}

src_compile() {
	"./eng/common/build.sh" --restore --build -c Release --warnaserror false /bl:${WORKDIR}/artifacts/log/Debug/Build_$(date +"%m%d%H%M%S").binlog /flp:v=diag
	die "WIP"
}
