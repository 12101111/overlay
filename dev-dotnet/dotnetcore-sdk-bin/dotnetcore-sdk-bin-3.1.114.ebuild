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
VER="3.1.14"

LICENSE="MIT"
SLOT="3.1"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="splitdebug"

RDEPEND="
	=dev-dotnet/coreclr-${VER}
	=dev-dotnet/corefx-${VER}
	>=dev-dotnet/dotnetcore-sdk-bin-common-${PV}
	>=sys-apps/lsb-release-1.4
	>=sys-devel/llvm-4.0
	>=dev-util/lldb-4.0
	!dev-dotnet/dotnetcore-sdk
	!dev-dotnet/dotnetcore-sdk-bin:0
	!dev-dotnet/dotnetcore-runtime-bin
	!dev-dotnet/dotnetcore-aspnet-bin
"
DEPEND="${REPEND}"
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
	rm -rfv shared/Microsoft.NETCore.App/${VER}/{createdump,*.so,nethost.h,SOS_README.md,*.a}
	rm -rf packs/NETStandard.Library.Ref
	default
}

_crossgen() {
	# crossgen don't work properly and generate a broken sdk
	if ! false; then
		return
	fi
	echo "crossgen $1"
	pushd "${T}" > /dev/null || die
	framework="/opt/dotnet/shared/Microsoft.NETCore.App/${VER}"
	sdk="/opt/dotnet/sdk/${PV}"
	timeout 120 ${framework}/crossgen /MissingDependenciesOK /Platform_Assemblies_Paths \
		${framework}:${sdk} /in $1 /out $1.ni >> $1.crossgen.log 2>&1
	exitCode=$?
	if [ "$exitCode" == "0" ]; then
        rm $1.crossgen.log
        mv $1.ni $1
    elif grep -q -e 'The module was expected to contain an assembly manifest' \
                 -e 'An attempt was made to load a program with an incorrect format.' \
                 -e 'File is PE32' $1.crossgen.log
    then
        rm $1.crossgen.log
        echo "skip \`$1\`"
    else
		mv $1 $1.x64
		${framework}/ildasm -raweh -out=$1.il $1.x64 >> $1.ildasm.log 2>&1
		${framework}/ilasm -output=$1 -DLL -QUIET -NOLOGO -DEBUG -OPTIMIZE $1.il >> $1.ilasm.log 2>&1
		exitCode=$?
		if [ "$exitCode" == "0" ]; then
			rm $1.x64
			rm $1.il
			rm $1.*.log
		else
			mv $1.x64 $1
			rm $1.il
			echo "fail to crossgen \`$1\`"
			cat $1.*.log
			rm $1.*.log
		fi
	fi
	popd > /dev/null || die
}

src_compile() {
	find ${S} -type f -name \*.dll -or -name \*.exe | while read -r dllpath; do
		_crossgen "$dllpath"
	done
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

