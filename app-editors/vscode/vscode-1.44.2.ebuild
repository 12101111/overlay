# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 xdg-utils savedconfig

DESCRIPTION="Visual Studio Code - Open Source"
HOMEPAGE="https://code.visualstudio.com/"

RG_PREBUILT="https://github.com/microsoft/ripgrep-prebuilt/releases/download"
RG_VERSION="11.0.1-2"
VSCODE_RIPGREP_VERSION="1.5.8 1.5.7"

ELECTRON_PREBUILT="https://github.com/electron/electron/releases/download"
ELECTRON_VERSION="7.2.3"
ELECTRON_SLOT="${ELECTRON_VERSION%%[.+]*}"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"
IUSE="system-electron system-ripgrep"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

SRC_URI="
	https://github.com/microsoft/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/12101111/overlay/releases/download/v2020-04-26/vscode-builtin-extensions.tar.xz
	https://github.com/12101111/overlay/releases/download/v2020-04-26/vscode-yarn-offline-cache.tar.xz
	!system-ripgrep? (
		amd64? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz )
		x86? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-i686-unknown-linux-musl.tar.gz )
		arm? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-arm-unknown-linux-gnueabihf.tar.gz )
		arm64? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-aarch64-unknown-linux-gnu.tar.gz )
		ppc64? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-powerpc64le-unknown-linux-gnu.tar.gz )
	)
	https://atom.io/download/electron/v${ELECTRON_VERSION}/node-v${ELECTRON_VERSION}-headers.tar.gz -> electron-v${ELECTRON_VERSION}-headers.tar.gz
	amd64? ( ${ELECTRON_PREBUILT}/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-x64.zip )
	x86? ( ${ELECTRON_PREBUILT}/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-ia32.zip )
	arm? ( ${ELECTRON_PREBUILT}/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-armv7l.zip )
	arm64? ( ${ELECTRON_PREBUILT}/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-arm64.zip )
"

BDEPEND="
	sys-apps/yarn
	>=net-libs/nodejs-10.19.0:=
"

DEPEND="
	>=app-crypt/libsecret-0.18.6:=
	>=app-text/hunspell-1.3.3:=
	>=dev-db/sqlite-3.24:=
	>=dev-libs/glib-2.52.0:=
	>=dev-libs/libgit2-0.23:=[ssh]
	>=dev-libs/libpcre2-10.22:=[jit,pcre16]
	>=dev-libs/oniguruma-6.6.0:=
	x11-libs/libxkbfile
	system-ripgrep? ( sys-apps/ripgrep )
	system-electron? ( dev-util/electron:${ELECTRON_SLOT} )
"

RDEPEND="
	${DEPEND}
	>=dev-util/ctags-5.8
	dev-vcs/git
"

PATCHES=(
	"${FILESDIR}/build_npm_postinstall.patch"
	"${FILESDIR}/disable_bundle_marketplace_extensions_build.patch"
	"${FILESDIR}/dont-download-ffmpeg.patch"
	"${FILESDIR}/fix-mac-address.patch"
	"${FILESDIR}/node-version.patch"
	"${FILESDIR}/product_json.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	# Dont't unpack ripgrep and electron
	unpack ${P}.tar.gz

	# How to download builtin extensions?
	# 1. yarn download-builtin-extensions
	# 2. cd .build
	# 3. tar cJf builtin-extensions.tar.xz builtInExtensions
	unpack vscode-builtin-extensions.tar.xz

	# How to crate yarn cache?
	# 1. echo 'yarn-offline-mirror "offline-cache"' >> .yarnrc
	# 2. yarn --frozen-lockfile --ignore-scripts
	# 3. yarn postinstall --frozen-lockfile
	# 4. tar cJf yarn-offline-cache.tar.xz offline-cache
	unpack vscode-yarn-offline-cache.tar.xz
}

src_prepare() {
	python_setup
	default

	export PATH="/usr/$(get_libdir)/node_modules/npm/bin/node-gyp-bin:${PATH}"
	local electron_cache_path="${TMPDIR}/gulp-electron-cache/atom/electron/"
	mkdir -p "${electron_cache_path}"
	local electron_zip="$(get_electron_prebuilt_zip_name)"
	#if use system-electron; then
		# Build native modules for system electron
	#	local electron_target="$(get_local_electron_version)"
	#	einfo "Build against Electron ${electron_target}"
	#	sed -i "s/^target .*/target \"${electron_target//v/}\"/" ${S}/.yarnrc

		# use local electron node headers
	#	echo "nodedir $(get_electron_nodedir)" >> ${S}/.yarnrc
	#	echo "nodedir /usr/include/node/" >> ${S}/remote/.yarnrc

		# make a fake electron zip
	#	mkdir ${WORKDIR}/electron
	#	pushd ${WORKDIR}/electron > /dev/null || die
		# crate_fake_bin "$(get_electron_dir)/electron" electron
	#	cp -r $(get_electron_dir)/{electron,*.pak,*.bin,version,locales} .
	#	zip -y "${electron_zip}" *

		# move electron zip to cache directory
		# https://github.com/joaomoreno/gulp-atom-electron/blob/master/src/download.js#L16
	#	mv "${electron_zip}" "${electron_cache_path}"

	#	popd > /dev/null || die
	#else
		# Build native modules for cached electron
		einfo "Build against Electron v${ELECTRON_VERSION}"
		sed -i "s/^target .*/target \"${ELECTRON_VERSION//v/}\"/" "${S}/.yarnrc"

		# use predownload electron node headers
		node-gyp install --target="${ELECTRON_VERSION}" --tarball="${DISTDIR}/electron-v${ELECTRON_VERSION}-headers.tar.gz"
		echo "nodedir /usr/include/node/" >> "${S}/remote/.yarnrc"

		cp "${DISTDIR}/${electron_zip}" "${electron_cache_path}"
	#fi

	# use offline cache
	echo 'yarn-offline-mirror "../offline-cache"' >> ${S}/.yarnrc

	# move ripgrep tarball to cache directory
	# https://github.com/microsoft/vscode-ripgrep/blob/master/lib/download.js#L13
	pushd "${WORKDIR}" > /dev/null || die
	local rg_tar_path="${DISTDIR}/$(get_rg_tar_name)"
	if use system-ripgrep; then
		crate_fake_bin /usr/bin/rg rg
		tar cf "$(get_rg_tar_name)" rg
		rg_tar_path="${WORKDIR}/$(get_rg_tar_name)"
	fi
	for version in ${VSCODE_RIPGREP_VERSION}; do
		local rg_cache_path="${TMPDIR}/vscode-ripgrep-cache-${version}"
		mkdir -p "${rg_cache_path}"
		cp "${rg_tar_path}" "${rg_cache_path}"
	done
	popd > /dev/null || die

	# FIXME: really useful?
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

	restore_config product.json
}

src_configure() {
	yarn install --frozen-lockfile --offline --verbose || die
}

src_compile() {
	yarn gulp vscode-linux-x64-min || die
}

src_install() {
	save_config product.json

	local vscode_path="/usr/$(get_libdir)/vscode"
	insinto "${vscode_path}"

	if use system-electron ; then
		doins -r "${WORKDIR}/VSCode-linux-x64/resources"
		doins -r "${WORKDIR}/VSCode-linux-x64/bin"
	else
		insinto "/usr/$(get_libdir)"
		doins -r "${WORKDIR}/VSCode-linux-x64"
		mv "${ED}usr/$(get_libdir)/VSCode-linux-x64" "${ED}${vscode_path}"
		insinto "${vscode_path}"
	fi

	local app_name="$(ls ${ED}${vscode_path}/bin)"
	mv "${ED}${vscode_path}/bin/${app_name}" "${ED}${vscode_path}/bin/code"
	sed -i "s/VSCODE_PATH=\"\/usr\/share\/${app_name}\"/VSCODE_PATH=\"\/usr\/$(get_libdir)\/vscode\"/g" \
		"${ED}${vscode_path}/bin/code"

	if use system-electron; then
		sed -i "s/ELECTRON=\"\$VSCODE_PATH\/${app_name}\"/ELECTRON=\"\/usr\/$(get_libdir)\/electron-${ELECTRON_SLOT}\/electron\"/g" \
			"${ED}${vscode_path}/bin/code"
		sed -i "s/\"\$CLI\"/\"\$CLI\" --app=\"\${VSCODE_PATH}\/resources\/app\"/g" \
			"${ED}${vscode_path}/bin/code"
	fi

	if use system-ripgrep; then
		rm "${ED}${vscode_path}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
		ln -s /usr/bin/rg "${ED}${vscode_path}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	fi

	fperms -R 755 ${vscode_path}/bin/code
	fperms -R 755 ${vscode_path}/resources/app/node_modules.asar.unpacked/
	dosym ${vscode_path}/bin/code /usr/bin/code
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

get_electron_dir() {
	echo "/usr/$(get_libdir)/electron-${ELECTRON_SLOT}"
}

get_local_electron_version() {
	echo "$(<$(get_electron_dir)/version)"
}

get_electron_nodedir() {
	echo "/usr/include/electron-${ELECTRON_SLOT}/node"
}

get_rg_tar_name() {
	local myarch=""
	case ${ABI} in
		amd64) myarch="x86_64-unknown-linux-musl";;
		x86) myarch="i686-unknown-linux-musl";;
		arm) myarch="arm-unknown-linux-gnueabihf";;
		arm64) myarch="aarch64-unknown-linux-gnu";;
		ppc64) myarch="powerpc64le-unknown-linux-gnu";;
		*);;
	esac
	echo "ripgrep-v${RG_VERSION}-${myarch}.tar.gz"
}

get_electron_prebuilt_zip_name() {
	local myarch=""
	case ${ABI} in
		amd64) myarch="x64";;
		x86) myarch="ia32";;
		arm) myarch="armv7l";;
		arm64) myarch="arm64";;
		*);;
	esac
	echo "electron-v${ELECTRON_VERSION}-linux-${myarch}.zip"
}

crate_fake_bin() {
	echo "#!/bin/sh" > "$2"
	echo "${1} \$@" >> "$2"
	chmod +x "$2"
}
