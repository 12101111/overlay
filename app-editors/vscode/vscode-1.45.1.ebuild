# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils savedconfig

DESCRIPTION="Visual Studio Code - Open Source"
HOMEPAGE="https://code.visualstudio.com/"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"
IUSE="system-electron system-ripgrep"
REQUIRED_USE="!system-electron? ( elibc_glibc )"

COMMIT="5763d909d5f12fe19f215cbfdd29a91c0fa9208a"

RG_PREBUILT="https://github.com/microsoft/ripgrep-prebuilt/releases/download"
RG_VERSION="11.0.1-2"
VSCODE_RIPGREP_VERSION="1.5.8 1.5.7"

ELECTRON_PREBUILT="https://github.com/electron/electron/releases/download"
ELECTRON_VERSION="7.2.4"
ELECTRON_SLOT="${ELECTRON_VERSION%%[.+]*}"

SRC_URI="
	https://github.com/microsoft/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/12101111/overlay/releases/download/v2020-05-11/vscode-builtin-extensions.tar.xz -> ${P}-builtin-extensions.tar.xz
	https://github.com/12101111/overlay/releases/download/v2020-05-11/vscode-yarn-offline-cache.tar.xz -> ${P}-yarn-offline-cache.tar.xz
	!system-ripgrep? (
		amd64? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz )
		x86? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-i686-unknown-linux-musl.tar.gz )
		arm? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-arm-unknown-linux-gnueabihf.tar.gz )
		arm64? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-aarch64-unknown-linux-gnu.tar.gz )
		ppc64? ( ${RG_PREBUILT}/v${RG_VERSION}/ripgrep-v${RG_VERSION}-powerpc64le-unknown-linux-gnu.tar.gz )
	)
	!system-electron? (
		https://atom.io/download/electron/v${ELECTRON_VERSION}/node-v${ELECTRON_VERSION}-headers.tar.gz -> electron-v${ELECTRON_VERSION}-headers.tar.gz
		amd64? ( ${ELECTRON_PREBUILT}/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-x64.zip )
		x86? ( ${ELECTRON_PREBUILT}/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-ia32.zip )
		arm? ( ${ELECTRON_PREBUILT}/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-armv7l.zip )
		arm64? ( ${ELECTRON_PREBUILT}/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-arm64.zip )
	)
"

BDEPEND="
	>=sys-apps/yarn-1.22.0:=
	>=net-libs/nodejs-10.19.0:=[npm]
"

DEPEND="
	>=app-crypt/libsecret-0.18.8:=
	>=x11-libs/libX11-1.6.9:=
	>=x11-libs/libxkbfile-1.1.0:=
	system-ripgrep? ( sys-apps/ripgrep )
	system-electron? (
		dev-util/electron:${ELECTRON_SLOT}
		app-arch/zip
	)
"

RDEPEND="${DEPEND}
	!system-electron? (
		>=x11-libs/gtk+-3.24.16:3[X]
		>=media-libs/alsa-lib-1.2.1
		>=net-print/cups-2.2.13
		x11-libs/libnotify
		dev-libs/nss
		app-accessibility/at-spi2-atk
		x11-libs/libXScrnSaver
		x11-libs/libXtst
		app-crypt/libsecret[crypt]
	)"

PATCHES=(
	"${FILESDIR}/0001-remove-playwright-as-it-s-only-used-in-unit-test.patch"
	"${FILESDIR}/0002-Don-t-download-bundle-marketplace-extensions-in-gulp.patch"
	"${FILESDIR}/0003-Don-t-download-prebuilt-ffmpeg.patch"
	"${FILESDIR}/0004-Fix-paths-of-ifconfig-and-ip-command-on-Gentoo-Linux.patch"
	"${FILESDIR}/0005-Allow-build-using-nodejs-14.patch"
	"${FILESDIR}/0006-Allow-offline-in-args.patch"
	"${FILESDIR}/0007-Don-t-run-yarn-install-for-web-remote-test.patch"
	"${FILESDIR}/0008-Add-install-script-for-Gentoo.patch"
	"${FILESDIR}/0009-Run-yarn-install-in-offline-mode.patch"
	"${FILESDIR}/0010-update-product.json.patch"
)

src_unpack() {
	# Dont't unpack ripgrep and electron
	unpack ${P}.tar.gz

	# How to download builtin extensions?
	# 1. yarn download-builtin-extensions
	# 2. cd .build
	# 3. tar cJf vscode-builtin-extensions.tar.xz builtInExtensions
	unpack ${P}-builtin-extensions.tar.xz

	# How to crate yarn cache?
	# 1. echo 'yarn-offline-mirror "offline-cache"' >> .yarnrc
	# 2. yarn --frozen-lockfile --ignore-scripts
	# 3. yarn postinstall --frozen-lockfile
	# 4. tar cJf vscode-yarn-offline-cache.tar.xz offline-cache
	unpack ${P}-yarn-offline-cache.tar.xz
}

src_prepare() {
	default

	export PATH="/usr/$(get_libdir)/node_modules/npm/bin/node-gyp-bin:${PATH}"
	# https://github.com/joaomoreno/gulp-atom-electron/blob/master/src/download.js#L16
	local electron_cache_path="${TMPDIR}/gulp-electron-cache/atom/electron/"
	mkdir -p "${electron_cache_path}"
	if use system-electron; then
		# Build native modules for system electron
		local electron_version="$(get_local_electron_version)"
		local electron_zip="$(get_electron_prebuilt_zip_name ${electron_version})"
		einfo "Build against Electron ${electron_version}"
		sed -i "s/^target .*/target \"${electron_version//v/}\"/" "${S}"/.yarnrc

		# use local electron node headers
		echo "nodedir $(get_electron_nodedir)" >> ${S}/.yarnrc
		echo "nodedir /usr/include/node/" >> ${S}/remote/.yarnrc

		einfo "making a ${electron_zip} from local electron"
		pushd "$(get_electron_dir)" > /dev/null || die
		zip -0yr "${electron_cache_path}/${electron_zip}" * \
			--exclude="chrome-sandbox" --exclude="chromedriver" --exclude="mksnapshot" \
			--exclude="npm/*" --exclude="resources/*"
		popd > /dev/null || die
	else
		# Build native modules for cached electron
		local electron_zip="$(get_electron_prebuilt_zip_name ${ELECTRON_VERSION})"
		einfo "Build against Electron v${ELECTRON_VERSION}"
		sed -i "s/^target .*/target \"${ELECTRON_VERSION//v/}\"/" "${S}/.yarnrc"

		# use predownload electron node headers
		node-gyp install --target="${ELECTRON_VERSION}" --tarball="${DISTDIR}/electron-v${ELECTRON_VERSION}-headers.tar.gz"
		echo "nodedir /usr/include/node/" >> "${S}/remote/.yarnrc"

		cp "${DISTDIR}/${electron_zip}" "${electron_cache_path}"
	fi

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

	restore_config product.json
}

src_configure() {
	yarn install --ignore-optional --frozen-lockfile --offline \
		--no-progress || die
}

src_compile() {
	yarn gulp vscode-linux-$(get_arch)-min || die
}

src_install() {
	export DESTDIR=${ED}
	export LIBDIR=$(get_libdir)
	export XDG_CACHE_HOME=${TMPDIR}
	yarn gulp vscode-linux-$(get_arch)-install-gentoo

	local vscode_path="/usr/$(get_libdir)/vscode"
	local app_name="$(ls ${ED}${vscode_path}/bin)"

	insinto "${vscode_path}/resources/app/extensions"
	doins -r "${WORKDIR}"/builtInExtensions/*

	sed -i "2i	\"commit\": \"${COMMIT}\"," "${ED}${vscode_path}/resources/app/product.json"
	if use system-electron; then
		cp "${FILESDIR}/code.js" "${ED}${vscode_path}/resources/app"
		sed -i "s/ELECTRON=\"\$VSCODE_PATH\/${app_name}\"/ELECTRON=\"\/usr\/$(get_libdir)\/electron-${ELECTRON_SLOT}\/electron\"/g" \
			"${ED}${vscode_path}/bin/${app_name}"
		sed -i "s/\"\$CLI\"/\"\$CLI\" \"\${VSCODE_PATH}\/resources\/app\/code.js\"/g" \
			"${ED}${vscode_path}/bin/${app_name}"
	fi

	if use system-ripgrep; then
		rm "${ED}${vscode_path}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
		ln -s /usr/bin/rg "${ED}${vscode_path}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	fi

	if use system-electron; then
		pushd "${ED}${vscode_path}" > /dev/null || die
			find . -type f,d -maxdepth 1 \
				-not \( -name '.*' -or -name 'bin' -or -name 'resources' \) \
				-exec rm -r "{}" +
		popd > /dev/null || die
	fi
	rm -rf "${ED}/usr/local"
	dosym ${vscode_path}/bin/${app_name} /usr/bin/${app_name}
	save_config product.json
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

get_arch() {
	case ${ABI} in
		amd64) echo "x64";;
		arm) echo "arm";;
		arm64) echo "arm64";;
		*);;
	esac
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
	echo "electron-v$1-linux-${myarch}.zip"
}

crate_fake_bin() {
	echo "#\!/bin/sh" > "$2"
	echo "${1} \$@" >> "$2"
	chmod +x "$2"
}
