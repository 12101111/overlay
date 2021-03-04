# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=".NET Core SDK ( prebuilt version )"
HOMEPAGE="https://dotnet.microsoft.com/"
SRC_URI="https://dotnetcli.azureedge.net/dotnet/Sdk/${PV}/dotnet-sdk-${PV}-linux-x64.tar.gz"
VER="3.1.12"

LICENSE="MIT"
SLOT="3.1"
KEYWORDS="~amd64"

DEPEND="
	=dev-dotnet/coreclr-${VER}
	=dev-dotnet/corefx-${VER}
	=dev-dotnet/corehost-${VER}
"
RDEPEND="${DEPEND}"
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
# 3. eselect dotnet and slot

src_prepare() {
	einfo "remove prebuilt native binary"
	rm -rfv dotnet
	rm -rfv host
	rm -rfv packs/Microsoft.NETCore.App.Host.linux-x64
	rm -rfv sdk/${PV}/AppHostTemplate
	rm -rfv shared/Microsoft.NETCore.App/${VER}/{createdump,*.so,nethost.h,SOS_README.md,*.a}
	default
}

_crossgen() {
	echo "crossgen $1"
	pushd "$( dirname "$1" )" > /dev/null || die
	framework="/opt/dotnetcore-sdk-bin-${VER}/shared/Microsoft.NETCore.App/${VER}"
	sdk="/opt/dotnetcore-sdk-bin-${VER}/sdk/${PV}"
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
	insinto /opt/dotnetcore-sdk-bin-${VER}
	doins -r .
}
