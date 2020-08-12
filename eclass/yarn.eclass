# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: yarn.eclass
# @MAINTAINER:
# 12101111
# @AUTHOR:
# 12101111
# @BLURB: functions to download yarn package
# @DESCRIPTION: functions to download yarn package

# @FUNCTION: yarn_uris
# @DESCRIPTION:
# Generates the URIs to put in SRC_URI to help fetch dependencies.
yarn_uris() {
	local -r regex='^https\:\/\/registry.yarnpkg.com\/(.+)\/\-\/([^/]+).tgz$'
	local -r namespace='^@([^@/]+)\/([^@/]+)$'
	local uri
	for uri in "$@"; do
		local name filename
		[[ $uri =~ $regex ]] || die "Could not parse url: ${uri}"
			name="${BASH_REMATCH[1]}"
			filename="${BASH_REMATCH[2]}"   
		if [[ $name =~ $namespace ]]; then
			local scope
			scope="${BASH_REMATCH[1]}"
			echo "${uri} -> @${scope}-${filename}.tgz"
		else
			echo "${uri} -> ${filename}.tgz"
		fi
	done
}
