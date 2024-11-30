#!/usr/bin/env bash

# jq -r '.builtInExtensions[] | .name +":"+ .version' product.json | sed -r 's/([^\.]*)\.([a-z0-9\-]*)\:([0-9\.]*)/["\2"]="\3"/g'
declare -A BUILTINEXTS=(
["js-debug-companion"]="1.1.3"
["js-debug"]="1.95.3"
["vscode-js-profile-table"]="1.0.10"
)

DISTDIR=$(portageq envvar DISTDIR)

# https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher}/vsextensions/${name}/${version}/vspackage
for k in "${!BUILTINEXTS[@]}"; do
	URL="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode/vsextensions/${k}/${BUILTINEXTS[${k}]}/vspackage"
	NAME="ms-vscode.${k}-${BUILTINEXTS[${k}]}.zip.gz"
	# header is from build/lib/extensions.ts
	wget \
	--header="X-Market-Client-Id: VSCode Build" \
	--header="User-Agent: VSCode Build" \
	--header="X-Market-User-Id: 291C1CD0-051A-4123-9B4B-30D60EF52EE2" \
	$URL -O "${DISTDIR}/${NAME}"
done
