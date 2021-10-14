# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Creating Electron app packages"
HOMEPAGE="https://github.com/electron/asar"

inherit yarn

# find . -name yarn.lock | xargs grep -h resolved  | sed 's/^[ ]*resolved \"\(.*\)\#.*\"\r*$/\1/g' | sort | uniq | wl-copy
YARNPKGS="
https://registry.yarnpkg.com/@types/events/-/events-3.0.0.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-7.1.1.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-3.0.3.tgz
https://registry.yarnpkg.com/@types/node/-/node-10.12.26.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz
https://registry.yarnpkg.com/chromium-pickle-js/-/chromium-pickle-js-0.2.0.tgz
https://registry.yarnpkg.com/commander/-/commander-5.0.0.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/glob/-/glob-7.1.6.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz
https://registry.yarnpkg.com/asar/-/asar-3.1.0.tgz
"

SRC_URI="$(yarn_uris ${YARNPKGS})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/nodejs"
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/yarn"

S="${WORKDIR}/package"

src_unpack() {
	unpack "${P}.tgz"
}

src_prepare() {
	yarn config set yarn-offline-mirror "${DISTDIR}"
	cp ${FILESDIR}/yarn.lock "${S}"
	eapply "${FILESDIR}/remove-dev.patch"
	default
}

src_compile() {
	yarn --offline --no-progress --frozen-lockfile --verbose || die
}

src_install() {
	local path="/usr/$(get_libdir)/node_modules/${PN}"
	insinto "${path}"
	doins -r .
	dosym "../$(get_libdir)/node_modules/${PN}/bin/${PN}.js" "/usr/bin/${PN}"

	while read -r -d '' path; do
        read -r shebang < "${ED}${path}" || die
        [[ "${shebang}" == \#\!* ]] || continue
        fperms +x "${path}"
    done < <(find "${ED}" -type f -printf '/%P\0' || die)
}
