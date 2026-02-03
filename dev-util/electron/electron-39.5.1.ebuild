# Copyright 2009-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GN_MIN_VER=0.2235

VIRTUALX_REQUIRED="pgo"

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

LLVM_COMPAT=( 20 21 )
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="xml(+)"
RUST_MIN_VER=1.87.0
RUST_NEEDS_LLVM="yes please"

inherit check-reqs chromium-2 desktop flag-o-matic llvm-r1 multiprocessing ninja-utils pax-utils
inherit python-any-r1 readme.gentoo-r1 rust toolchain-funcs virtualx xdg-utils
inherit rust-toolchain

# Keep this in sync with DEPS:chromium_version
# find least version of available snapshot in
# https://gsdview.appspot.com/chromium-browser-official/?marker=chromium-137.0.7151.8.tar.xz.hashe%40
# the website is dead now
CHROMIUM_VERSION="142.0.7444.234"
# Keep this in sync with DEPS:node_version
NODE_VERSION="22.22.0"

DESCRIPTION="Cross platform application development framework based on web technologies"
HOMEPAGE="https://electronjs.org/"

# ./files/yarnv4.sh yarn.lock | wl-copy
YARNPKGS="
https://registry.npmjs.org/@antfu/install-pkg/-/install-pkg-1.1.0.tgz -> @antfu-install-pkg-1.1.0.tgz
https://registry.npmjs.org/@azure/abort-controller/-/abort-controller-1.0.4.tgz -> @azure-abort-controller-1.0.4.tgz
https://registry.npmjs.org/@azure/abort-controller/-/abort-controller-2.1.2.tgz -> @azure-abort-controller-2.1.2.tgz
https://registry.npmjs.org/@azure/core-auth/-/core-auth-1.10.0.tgz -> @azure-core-auth-1.10.0.tgz
https://registry.npmjs.org/@azure/core-client/-/core-client-1.10.0.tgz -> @azure-core-client-1.10.0.tgz
https://registry.npmjs.org/@azure/core-http-compat/-/core-http-compat-2.3.0.tgz -> @azure-core-http-compat-2.3.0.tgz
https://registry.npmjs.org/@azure/core-lro/-/core-lro-2.2.4.tgz -> @azure-core-lro-2.2.4.tgz
https://registry.npmjs.org/@azure/core-paging/-/core-paging-1.6.2.tgz -> @azure-core-paging-1.6.2.tgz
https://registry.npmjs.org/@azure/core-rest-pipeline/-/core-rest-pipeline-1.22.0.tgz -> @azure-core-rest-pipeline-1.22.0.tgz
https://registry.npmjs.org/@azure/core-tracing/-/core-tracing-1.0.0-preview.13.tgz -> @azure-core-tracing-1.0.0-preview.13.tgz
https://registry.npmjs.org/@azure/core-tracing/-/core-tracing-1.3.0.tgz -> @azure-core-tracing-1.3.0.tgz
https://registry.npmjs.org/@azure/core-util/-/core-util-1.13.0.tgz -> @azure-core-util-1.13.0.tgz
https://registry.npmjs.org/@azure/core-xml/-/core-xml-1.5.0.tgz -> @azure-core-xml-1.5.0.tgz
https://registry.npmjs.org/@azure/logger/-/logger-1.3.0.tgz -> @azure-logger-1.3.0.tgz
https://registry.npmjs.org/@azure/storage-blob/-/storage-blob-12.28.0.tgz -> @azure-storage-blob-12.28.0.tgz
https://registry.npmjs.org/@azure/storage-common/-/storage-common-12.0.0.tgz -> @azure-storage-common-12.0.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.25.7.tgz -> @babel-code-frame-7.25.7.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.7.tgz -> @babel-helper-validator-identifier-7.25.7.tgz
https://registry.npmjs.org/@babel/highlight/-/highlight-7.25.7.tgz -> @babel-highlight-7.25.7.tgz
https://registry.npmjs.org/@datadog/datadog-ci-base/-/datadog-ci-base-4.1.2.tgz -> @datadog-datadog-ci-base-4.1.2.tgz
https://registry.npmjs.org/@datadog/datadog-ci-plugin-deployment/-/datadog-ci-plugin-deployment-4.1.2.tgz -> @datadog-datadog-ci-plugin-deployment-4.1.2.tgz
https://registry.npmjs.org/@datadog/datadog-ci-plugin-dora/-/datadog-ci-plugin-dora-4.1.2.tgz -> @datadog-datadog-ci-plugin-dora-4.1.2.tgz
https://registry.npmjs.org/@datadog/datadog-ci-plugin-gate/-/datadog-ci-plugin-gate-4.1.2.tgz -> @datadog-datadog-ci-plugin-gate-4.1.2.tgz
https://registry.npmjs.org/@datadog/datadog-ci-plugin-sarif/-/datadog-ci-plugin-sarif-4.1.2.tgz -> @datadog-datadog-ci-plugin-sarif-4.1.2.tgz
https://registry.npmjs.org/@datadog/datadog-ci-plugin-sbom/-/datadog-ci-plugin-sbom-4.1.2.tgz -> @datadog-datadog-ci-plugin-sbom-4.1.2.tgz
https://registry.npmjs.org/@datadog/datadog-ci-plugin-synthetics/-/datadog-ci-plugin-synthetics-4.1.2.tgz -> @datadog-datadog-ci-plugin-synthetics-4.1.2.tgz
https://registry.npmjs.org/@datadog/datadog-ci/-/datadog-ci-4.1.2.tgz -> @datadog-datadog-ci-4.1.2.tgz
https://registry.npmjs.org/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz -> @discoveryjs-json-ext-0.5.7.tgz
https://registry.npmjs.org/@dsanders11/vscode-markdown-languageservice/-/vscode-markdown-languageservice-0.3.0.tgz -> @dsanders11-vscode-markdown-languageservice-0.3.0.tgz
https://registry.npmjs.org/@electron/asar/-/asar-3.2.13.tgz -> @electron-asar-3.2.13.tgz
https://registry.npmjs.org/@electron/asar/-/asar-3.4.1.tgz -> @electron-asar-3.4.1.tgz
https://registry.npmjs.org/@electron/docs-parser/-/docs-parser-2.0.0.tgz -> @electron-docs-parser-2.0.0.tgz
https://registry.npmjs.org/@electron/fiddle-core/-/fiddle-core-1.3.4.tgz -> @electron-fiddle-core-1.3.4.tgz
https://registry.npmjs.org/@electron/fuses/-/fuses-1.8.0.tgz -> @electron-fuses-1.8.0.tgz
https://registry.npmjs.org/@electron/get/-/get-2.0.2.tgz -> @electron-get-2.0.2.tgz
https://registry.npmjs.org/@electron/get/-/get-3.1.0.tgz -> @electron-get-3.1.0.tgz
https://registry.npmjs.org/@electron/github-app-auth/-/github-app-auth-3.2.0.tgz -> @electron-github-app-auth-3.2.0.tgz
https://registry.npmjs.org/@electron/lint-roller/-/lint-roller-3.2.0.tgz -> @electron-lint-roller-3.2.0.tgz
https://registry.npmjs.org/@electron/notarize/-/notarize-2.5.0.tgz -> @electron-notarize-2.5.0.tgz
https://registry.npmjs.org/@electron/osx-sign/-/osx-sign-1.3.3.tgz -> @electron-osx-sign-1.3.3.tgz
https://registry.npmjs.org/@electron/packager/-/packager-18.4.4.tgz -> @electron-packager-18.4.4.tgz
https://registry.npmjs.org/@electron/typescript-definitions/-/typescript-definitions-9.1.5.tgz -> @electron-typescript-definitions-9.1.5.tgz
https://registry.npmjs.org/@electron/universal/-/universal-2.0.3.tgz -> @electron-universal-2.0.3.tgz
https://registry.npmjs.org/@electron/windows-sign/-/windows-sign-1.2.2.tgz -> @electron-windows-sign-1.2.2.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz -> @eslint-community-eslint-utils-4.4.0.tgz
https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.7.0.tgz -> @eslint-community-eslint-utils-4.7.0.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.11.1.tgz -> @eslint-community-regexpp-4.11.1.tgz
https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.1.4.tgz -> @eslint-eslintrc-2.1.4.tgz
https://registry.npmjs.org/@eslint/js/-/js-8.57.1.tgz -> @eslint-js-8.57.1.tgz
https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.13.0.tgz -> @humanwhocodes-config-array-0.13.0.tgz
https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz -> @humanwhocodes-module-importer-1.0.1.tgz
https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-2.0.3.tgz -> @humanwhocodes-object-schema-2.0.3.tgz
https://registry.npmjs.org/@inquirer/external-editor/-/external-editor-1.0.2.tgz -> @inquirer-external-editor-1.0.2.tgz
https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz -> @isaacs-cliui-8.0.2.tgz
https://registry.npmjs.org/@isaacs/fs-minipass/-/fs-minipass-4.0.1.tgz -> @isaacs-fs-minipass-4.0.1.tgz
https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz -> @jridgewell-gen-mapping-0.3.5.tgz
https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz -> @jridgewell-resolve-uri-3.1.2.tgz
https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz -> @jridgewell-set-array-1.2.1.tgz
https://registry.npmjs.org/@jridgewell/source-map/-/source-map-0.3.6.tgz -> @jridgewell-source-map-0.3.6.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz -> @jridgewell-sourcemap-codec-1.4.14.tgz
https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz -> @jridgewell-sourcemap-codec-1.5.0.tgz
https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz -> @jridgewell-trace-mapping-0.3.25.tgz
https://registry.npmjs.org/@kwsites/file-exists/-/file-exists-1.1.1.tgz -> @kwsites-file-exists-1.1.1.tgz
https://registry.npmjs.org/@kwsites/promise-deferred/-/promise-deferred-1.1.1.tgz -> @kwsites-promise-deferred-1.1.1.tgz
https://registry.npmjs.org/@malept/cross-spawn-promise/-/cross-spawn-promise-2.0.0.tgz -> @malept-cross-spawn-promise-2.0.0.tgz
https://registry.npmjs.org/@mapbox/node-pre-gyp/-/node-pre-gyp-1.0.11.tgz -> @mapbox-node-pre-gyp-1.0.11.tgz
https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz -> @nodelib-fs.scandir-2.1.5.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.3.tgz -> @nodelib-fs.stat-2.0.3.tgz
https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz -> @nodelib-fs.stat-2.0.5.tgz
https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz -> @nodelib-fs.walk-1.2.8.tgz
https://registry.npmjs.org/@nornagon/put/-/put-0.0.8.tgz -> @nornagon-put-0.0.8.tgz
https://registry.npmjs.org/@npmcli/agent/-/agent-3.0.0.tgz -> @npmcli-agent-3.0.0.tgz
https://registry.npmjs.org/@npmcli/config/-/config-8.3.4.tgz -> @npmcli-config-8.3.4.tgz
https://registry.npmjs.org/@npmcli/fs/-/fs-4.0.0.tgz -> @npmcli-fs-4.0.0.tgz
https://registry.npmjs.org/@npmcli/git/-/git-5.0.8.tgz -> @npmcli-git-5.0.8.tgz
https://registry.npmjs.org/@npmcli/map-workspaces/-/map-workspaces-3.0.6.tgz -> @npmcli-map-workspaces-3.0.6.tgz
https://registry.npmjs.org/@npmcli/name-from-folder/-/name-from-folder-2.0.0.tgz -> @npmcli-name-from-folder-2.0.0.tgz
https://registry.npmjs.org/@npmcli/package-json/-/package-json-5.2.1.tgz -> @npmcli-package-json-5.2.1.tgz
https://registry.npmjs.org/@npmcli/promise-spawn/-/promise-spawn-7.0.2.tgz -> @npmcli-promise-spawn-7.0.2.tgz
https://registry.npmjs.org/@octokit/auth-app/-/auth-app-8.1.2.tgz -> @octokit-auth-app-8.1.2.tgz
https://registry.npmjs.org/@octokit/auth-oauth-app/-/auth-oauth-app-9.0.3.tgz -> @octokit-auth-oauth-app-9.0.3.tgz
https://registry.npmjs.org/@octokit/auth-oauth-device/-/auth-oauth-device-8.0.3.tgz -> @octokit-auth-oauth-device-8.0.3.tgz
https://registry.npmjs.org/@octokit/auth-oauth-user/-/auth-oauth-user-6.0.2.tgz -> @octokit-auth-oauth-user-6.0.2.tgz
https://registry.npmjs.org/@octokit/auth-token/-/auth-token-4.0.0.tgz -> @octokit-auth-token-4.0.0.tgz
https://registry.npmjs.org/@octokit/auth-token/-/auth-token-6.0.0.tgz -> @octokit-auth-token-6.0.0.tgz
https://registry.npmjs.org/@octokit/core/-/core-5.2.2.tgz -> @octokit-core-5.2.2.tgz
https://registry.npmjs.org/@octokit/core/-/core-7.0.6.tgz -> @octokit-core-7.0.6.tgz
https://registry.npmjs.org/@octokit/endpoint/-/endpoint-11.0.2.tgz -> @octokit-endpoint-11.0.2.tgz
https://registry.npmjs.org/@octokit/endpoint/-/endpoint-9.0.6.tgz -> @octokit-endpoint-9.0.6.tgz
https://registry.npmjs.org/@octokit/graphql/-/graphql-7.1.1.tgz -> @octokit-graphql-7.1.1.tgz
https://registry.npmjs.org/@octokit/graphql/-/graphql-9.0.3.tgz -> @octokit-graphql-9.0.3.tgz
https://registry.npmjs.org/@octokit/oauth-authorization-url/-/oauth-authorization-url-8.0.0.tgz -> @octokit-oauth-authorization-url-8.0.0.tgz
https://registry.npmjs.org/@octokit/oauth-methods/-/oauth-methods-6.0.2.tgz -> @octokit-oauth-methods-6.0.2.tgz
https://registry.npmjs.org/@octokit/openapi-types/-/openapi-types-24.2.0.tgz -> @octokit-openapi-types-24.2.0.tgz
https://registry.npmjs.org/@octokit/openapi-types/-/openapi-types-27.0.0.tgz -> @octokit-openapi-types-27.0.0.tgz
https://registry.npmjs.org/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-11.4.4-cjs.2.tgz -> @octokit-plugin-paginate-rest-11.4.4-cjs.2.tgz
https://registry.npmjs.org/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-14.0.0.tgz -> @octokit-plugin-paginate-rest-14.0.0.tgz
https://registry.npmjs.org/@octokit/plugin-request-log/-/plugin-request-log-4.0.1.tgz -> @octokit-plugin-request-log-4.0.1.tgz
https://registry.npmjs.org/@octokit/plugin-request-log/-/plugin-request-log-6.0.0.tgz -> @octokit-plugin-request-log-6.0.0.tgz
https://registry.npmjs.org/@octokit/plugin-rest-endpoint-methods/-/plugin-rest-endpoint-methods-13.3.2-cjs.1.tgz -> @octokit-plugin-rest-endpoint-methods-13.3.2-cjs.1.tgz
https://registry.npmjs.org/@octokit/plugin-rest-endpoint-methods/-/plugin-rest-endpoint-methods-17.0.0.tgz -> @octokit-plugin-rest-endpoint-methods-17.0.0.tgz
https://registry.npmjs.org/@octokit/request-error/-/request-error-5.1.1.tgz -> @octokit-request-error-5.1.1.tgz
https://registry.npmjs.org/@octokit/request-error/-/request-error-7.1.0.tgz -> @octokit-request-error-7.1.0.tgz
https://registry.npmjs.org/@octokit/request/-/request-10.0.7.tgz -> @octokit-request-10.0.7.tgz
https://registry.npmjs.org/@octokit/request/-/request-8.4.1.tgz -> @octokit-request-8.4.1.tgz
https://registry.npmjs.org/@octokit/rest/-/rest-20.1.2.tgz -> @octokit-rest-20.1.2.tgz
https://registry.npmjs.org/@octokit/rest/-/rest-22.0.1.tgz -> @octokit-rest-22.0.1.tgz
https://registry.npmjs.org/@octokit/types/-/types-13.10.0.tgz -> @octokit-types-13.10.0.tgz
https://registry.npmjs.org/@octokit/types/-/types-16.0.0.tgz -> @octokit-types-16.0.0.tgz
https://registry.npmjs.org/@opentelemetry/api/-/api-1.0.4.tgz -> @opentelemetry-api-1.0.4.tgz
https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz -> @pkgjs-parseargs-0.11.0.tgz
https://registry.npmjs.org/@primer/octicons/-/octicons-10.0.0.tgz -> @primer-octicons-10.0.0.tgz
https://registry.npmjs.org/@rtsao/scc/-/scc-1.1.0.tgz -> @rtsao-scc-1.1.0.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-4.6.0.tgz -> @sindresorhus-is-4.6.0.tgz
https://registry.npmjs.org/@sindresorhus/merge-streams/-/merge-streams-2.3.0.tgz -> @sindresorhus-merge-streams-2.3.0.tgz
https://registry.npmjs.org/@sinonjs/commons/-/commons-1.8.6.tgz -> @sinonjs-commons-1.8.6.tgz
https://registry.npmjs.org/@sinonjs/fake-timers/-/fake-timers-6.0.1.tgz -> @sinonjs-fake-timers-6.0.1.tgz
https://registry.npmjs.org/@sinonjs/samsam/-/samsam-5.3.1.tgz -> @sinonjs-samsam-5.3.1.tgz
https://registry.npmjs.org/@sinonjs/text-encoding/-/text-encoding-0.7.3.tgz -> @sinonjs-text-encoding-0.7.3.tgz
https://registry.npmjs.org/@szmarczak/http-timer/-/http-timer-4.0.6.tgz -> @szmarczak-http-timer-4.0.6.tgz
https://registry.npmjs.org/@tootallnate/quickjs-emscripten/-/quickjs-emscripten-0.23.0.tgz -> @tootallnate-quickjs-emscripten-0.23.0.tgz
https://registry.npmjs.org/@types/basic-auth/-/basic-auth-1.1.8.tgz -> @types-basic-auth-1.1.8.tgz
https://registry.npmjs.org/@types/body-parser/-/body-parser-1.19.6.tgz -> @types-body-parser-1.19.6.tgz
https://registry.npmjs.org/@types/busboy/-/busboy-1.5.4.tgz -> @types-busboy-1.5.4.tgz
https://registry.npmjs.org/@types/cacheable-request/-/cacheable-request-6.0.2.tgz -> @types-cacheable-request-6.0.2.tgz
https://registry.npmjs.org/@types/chai-as-promised/-/chai-as-promised-7.1.8.tgz -> @types-chai-as-promised-7.1.8.tgz
https://registry.npmjs.org/@types/chai/-/chai-4.3.20.tgz -> @types-chai-4.3.20.tgz
https://registry.npmjs.org/@types/chai/-/chai-5.2.3.tgz -> @types-chai-5.2.3.tgz
https://registry.npmjs.org/@types/color-name/-/color-name-1.1.1.tgz -> @types-color-name-1.1.1.tgz
https://registry.npmjs.org/@types/concat-stream/-/concat-stream-2.0.3.tgz -> @types-concat-stream-2.0.3.tgz
https://registry.npmjs.org/@types/connect/-/connect-3.4.38.tgz -> @types-connect-3.4.38.tgz
https://registry.npmjs.org/@types/datadog-metrics/-/datadog-metrics-0.6.1.tgz -> @types-datadog-metrics-0.6.1.tgz
https://registry.npmjs.org/@types/debug/-/debug-4.1.7.tgz -> @types-debug-4.1.7.tgz
https://registry.npmjs.org/@types/deep-eql/-/deep-eql-4.0.2.tgz -> @types-deep-eql-4.0.2.tgz
https://registry.npmjs.org/@types/dirty-chai/-/dirty-chai-2.0.5.tgz -> @types-dirty-chai-2.0.5.tgz
https://registry.npmjs.org/@types/estree-jsx/-/estree-jsx-1.0.5.tgz -> @types-estree-jsx-1.0.5.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.5.tgz -> @types-estree-1.0.5.tgz
https://registry.npmjs.org/@types/estree/-/estree-1.0.8.tgz -> @types-estree-1.0.8.tgz
https://registry.npmjs.org/@types/express-serve-static-core/-/express-serve-static-core-4.19.7.tgz -> @types-express-serve-static-core-4.19.7.tgz
https://registry.npmjs.org/@types/express/-/express-4.17.23.tgz -> @types-express-4.17.23.tgz
https://registry.npmjs.org/@types/glob/-/glob-7.2.0.tgz -> @types-glob-7.2.0.tgz
https://registry.npmjs.org/@types/hast/-/hast-3.0.4.tgz -> @types-hast-3.0.4.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.0.1.tgz -> @types-http-cache-semantics-4.0.1.tgz
https://registry.npmjs.org/@types/http-errors/-/http-errors-2.0.5.tgz -> @types-http-errors-2.0.5.tgz
https://registry.npmjs.org/@types/is-empty/-/is-empty-1.2.0.tgz -> @types-is-empty-1.2.0.tgz
https://registry.npmjs.org/@types/json-buffer/-/json-buffer-3.0.0.tgz -> @types-json-buffer-3.0.0.tgz
https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.11.tgz -> @types-json-schema-7.0.11.tgz
https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz -> @types-json5-0.0.29.tgz
https://registry.npmjs.org/@types/katex/-/katex-0.16.7.tgz -> @types-katex-0.16.7.tgz
https://registry.npmjs.org/@types/keyv/-/keyv-3.1.4.tgz -> @types-keyv-3.1.4.tgz
https://registry.npmjs.org/@types/linkify-it/-/linkify-it-5.0.0.tgz -> @types-linkify-it-5.0.0.tgz
https://registry.npmjs.org/@types/markdown-it/-/markdown-it-14.1.2.tgz -> @types-markdown-it-14.1.2.tgz
https://registry.npmjs.org/@types/mdast/-/mdast-3.0.15.tgz -> @types-mdast-3.0.15.tgz
https://registry.npmjs.org/@types/mdast/-/mdast-4.0.4.tgz -> @types-mdast-4.0.4.tgz
https://registry.npmjs.org/@types/mdurl/-/mdurl-2.0.0.tgz -> @types-mdurl-2.0.0.tgz
https://registry.npmjs.org/@types/mime/-/mime-1.3.5.tgz -> @types-mime-1.3.5.tgz
https://registry.npmjs.org/@types/minimatch/-/minimatch-3.0.3.tgz -> @types-minimatch-3.0.3.tgz
https://registry.npmjs.org/@types/minimist/-/minimist-1.2.5.tgz -> @types-minimist-1.2.5.tgz
https://registry.npmjs.org/@types/mocha/-/mocha-7.0.2.tgz -> @types-mocha-7.0.2.tgz
https://registry.npmjs.org/@types/ms/-/ms-0.7.31.tgz -> @types-ms-0.7.31.tgz
https://registry.npmjs.org/@types/node/-/node-20.16.12.tgz -> @types-node-20.16.12.tgz
https://registry.npmjs.org/@types/node/-/node-22.19.1.tgz -> @types-node-22.19.1.tgz
https://registry.npmjs.org/@types/node/-/node-22.7.7.tgz -> @types-node-22.7.7.tgz
https://registry.npmjs.org/@types/qs/-/qs-6.14.0.tgz -> @types-qs-6.14.0.tgz
https://registry.npmjs.org/@types/range-parser/-/range-parser-1.2.7.tgz -> @types-range-parser-1.2.7.tgz
https://registry.npmjs.org/@types/responselike/-/responselike-1.0.0.tgz -> @types-responselike-1.0.0.tgz
https://registry.npmjs.org/@types/semver/-/semver-7.5.8.tgz -> @types-semver-7.5.8.tgz
https://registry.npmjs.org/@types/send/-/send-0.14.7.tgz -> @types-send-0.14.7.tgz
https://registry.npmjs.org/@types/send/-/send-0.17.5.tgz -> @types-send-0.17.5.tgz
https://registry.npmjs.org/@types/send/-/send-1.2.0.tgz -> @types-send-1.2.0.tgz
https://registry.npmjs.org/@types/serve-static/-/serve-static-1.15.9.tgz -> @types-serve-static-1.15.9.tgz
https://registry.npmjs.org/@types/sinon/-/sinon-9.0.11.tgz -> @types-sinon-9.0.11.tgz
https://registry.npmjs.org/@types/sinonjs__fake-timers/-/sinonjs__fake-timers-15.0.0.tgz -> @types-sinonjs__fake-timers-15.0.0.tgz
https://registry.npmjs.org/@types/stream-chain/-/stream-chain-2.0.0.tgz -> @types-stream-chain-2.0.0.tgz
https://registry.npmjs.org/@types/stream-json/-/stream-json-1.7.8.tgz -> @types-stream-json-1.7.8.tgz
https://registry.npmjs.org/@types/supports-color/-/supports-color-8.1.1.tgz -> @types-supports-color-8.1.1.tgz
https://registry.npmjs.org/@types/temp/-/temp-0.9.4.tgz -> @types-temp-0.9.4.tgz
https://registry.npmjs.org/@types/text-table/-/text-table-0.2.2.tgz -> @types-text-table-0.2.2.tgz
https://registry.npmjs.org/@types/unist/-/unist-2.0.11.tgz -> @types-unist-2.0.11.tgz
https://registry.npmjs.org/@types/unist/-/unist-2.0.3.tgz -> @types-unist-2.0.3.tgz
https://registry.npmjs.org/@types/unist/-/unist-2.0.6.tgz -> @types-unist-2.0.6.tgz
https://registry.npmjs.org/@types/unist/-/unist-3.0.2.tgz -> @types-unist-3.0.2.tgz
https://registry.npmjs.org/@types/uuid/-/uuid-3.4.13.tgz -> @types-uuid-3.4.13.tgz
https://registry.npmjs.org/@types/uuid/-/uuid-9.0.8.tgz -> @types-uuid-9.0.8.tgz
https://registry.npmjs.org/@types/w3c-web-serial/-/w3c-web-serial-1.0.8.tgz -> @types-w3c-web-serial-1.0.8.tgz
https://registry.npmjs.org/@types/ws/-/ws-7.4.7.tgz -> @types-ws-7.4.7.tgz
https://registry.npmjs.org/@types/yauzl/-/yauzl-2.10.0.tgz -> @types-yauzl-2.10.0.tgz
https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-8.32.1.tgz -> @typescript-eslint-eslint-plugin-8.32.1.tgz
https://registry.npmjs.org/@typescript-eslint/parser/-/parser-8.7.0.tgz -> @typescript-eslint-parser-8.7.0.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-8.32.1.tgz -> @typescript-eslint-scope-manager-8.32.1.tgz
https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-8.7.0.tgz -> @typescript-eslint-scope-manager-8.7.0.tgz
https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-8.32.1.tgz -> @typescript-eslint-type-utils-8.32.1.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-8.32.1.tgz -> @typescript-eslint-types-8.32.1.tgz
https://registry.npmjs.org/@typescript-eslint/types/-/types-8.7.0.tgz -> @typescript-eslint-types-8.7.0.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-8.32.1.tgz -> @typescript-eslint-typescript-estree-8.32.1.tgz
https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-8.7.0.tgz -> @typescript-eslint-typescript-estree-8.7.0.tgz
https://registry.npmjs.org/@typescript-eslint/utils/-/utils-8.32.1.tgz -> @typescript-eslint-utils-8.32.1.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-8.32.1.tgz -> @typescript-eslint-visitor-keys-8.32.1.tgz
https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-8.7.0.tgz -> @typescript-eslint-visitor-keys-8.7.0.tgz
https://registry.npmjs.org/@typespec/ts-http-runtime/-/ts-http-runtime-0.3.0.tgz -> @typespec-ts-http-runtime-0.3.0.tgz
https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.2.0.tgz -> @ungap-structured-clone-1.2.0.tgz
https://registry.npmjs.org/@vscode/l10n/-/l10n-0.0.10.tgz -> @vscode-l10n-0.0.10.tgz
https://registry.npmjs.org/@webassemblyjs/ast/-/ast-1.12.1.tgz -> @webassemblyjs-ast-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.6.tgz -> @webassemblyjs-floating-point-hex-parser-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.6.tgz -> @webassemblyjs-helper-api-error-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-buffer/-/helper-buffer-1.12.1.tgz -> @webassemblyjs-helper-buffer-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.6.tgz -> @webassemblyjs-helper-numbers-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.6.tgz -> @webassemblyjs-helper-wasm-bytecode-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.12.1.tgz -> @webassemblyjs-helper-wasm-section-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/ieee754/-/ieee754-1.11.6.tgz -> @webassemblyjs-ieee754-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/leb128/-/leb128-1.11.6.tgz -> @webassemblyjs-leb128-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/utf8/-/utf8-1.11.6.tgz -> @webassemblyjs-utf8-1.11.6.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-edit/-/wasm-edit-1.12.1.tgz -> @webassemblyjs-wasm-edit-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-gen/-/wasm-gen-1.12.1.tgz -> @webassemblyjs-wasm-gen-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-opt/-/wasm-opt-1.12.1.tgz -> @webassemblyjs-wasm-opt-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/wasm-parser/-/wasm-parser-1.12.1.tgz -> @webassemblyjs-wasm-parser-1.12.1.tgz
https://registry.npmjs.org/@webassemblyjs/wast-printer/-/wast-printer-1.12.1.tgz -> @webassemblyjs-wast-printer-1.12.1.tgz
https://registry.npmjs.org/@webpack-cli/configtest/-/configtest-2.1.1.tgz -> @webpack-cli-configtest-2.1.1.tgz
https://registry.npmjs.org/@webpack-cli/info/-/info-2.0.2.tgz -> @webpack-cli-info-2.0.2.tgz
https://registry.npmjs.org/@webpack-cli/serve/-/serve-2.0.5.tgz -> @webpack-cli-serve-2.0.5.tgz
https://registry.npmjs.org/@xmldom/xmldom/-/xmldom-0.8.11.tgz -> @xmldom-xmldom-0.8.11.tgz
https://registry.npmjs.org/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> @xtuc-ieee754-1.2.0.tgz
https://registry.npmjs.org/@xtuc/long/-/long-4.2.2.tgz -> @xtuc-long-4.2.2.tgz
https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz
https://registry.npmjs.org/abbrev/-/abbrev-2.0.0.tgz
https://registry.npmjs.org/abbrev/-/abbrev-3.0.1.tgz
https://registry.npmjs.org/accepts/-/accepts-1.3.8.tgz
https://registry.npmjs.org/acorn-import-attributes/-/acorn-import-attributes-1.9.5.tgz
https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz
https://registry.npmjs.org/acorn/-/acorn-8.12.1.tgz
https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.1.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.4.tgz
https://registry.npmjs.org/ajv-formats/-/ajv-formats-2.1.1.tgz
https://registry.npmjs.org/ajv-keywords/-/ajv-keywords-3.5.2.tgz
https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz
https://registry.npmjs.org/ajv/-/ajv-8.17.1.tgz
https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.3.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-4.3.2.tgz
https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-7.0.0.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-3.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz
https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.0.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.2.1.tgz
https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.0.3.tgz
https://registry.npmjs.org/anymatch/-/anymatch-3.1.2.tgz
https://registry.npmjs.org/aproba/-/aproba-2.1.0.tgz
https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz
https://registry.npmjs.org/argparse/-/argparse-1.0.10.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz
https://registry.npmjs.org/array-buffer-byte-length/-/array-buffer-byte-length-1.0.2.tgz
https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.6.tgz
https://registry.npmjs.org/array-includes/-/array-includes-3.1.9.tgz
https://registry.npmjs.org/array-unique/-/array-unique-0.3.2.tgz
https://registry.npmjs.org/array.prototype.findlastindex/-/array.prototype.findlastindex-1.2.6.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz
https://registry.npmjs.org/array.prototype.flat/-/array.prototype.flat-1.3.3.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz
https://registry.npmjs.org/array.prototype.flatmap/-/array.prototype.flatmap-1.3.3.tgz
https://registry.npmjs.org/array.prototype.tosorted/-/array.prototype.tosorted-1.1.1.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz
https://registry.npmjs.org/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.4.tgz
https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz
https://registry.npmjs.org/asn1/-/asn1-0.2.6.tgz
https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz
https://registry.npmjs.org/assertion-error/-/assertion-error-1.1.0.tgz
https://registry.npmjs.org/assertion-error/-/assertion-error-2.0.1.tgz
https://registry.npmjs.org/ast-types/-/ast-types-0.13.4.tgz
https://registry.npmjs.org/async-function/-/async-function-1.0.0.tgz
https://registry.npmjs.org/async-retry/-/async-retry-1.3.1.tgz
https://registry.npmjs.org/async/-/async-3.2.4.tgz
https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz
https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz
https://registry.npmjs.org/author-regex/-/author-regex-1.0.0.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz
https://registry.npmjs.org/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz
https://registry.npmjs.org/axios/-/axios-1.13.2.tgz
https://registry.npmjs.org/bail/-/bail-2.0.1.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz
https://registry.npmjs.org/balanced-match/-/balanced-match-3.0.1.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz
https://registry.npmjs.org/basic-auth/-/basic-auth-2.0.1.tgz
https://registry.npmjs.org/basic-ftp/-/basic-ftp-5.0.5.tgz
https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.2.tgz
https://registry.npmjs.org/before-after-hook/-/before-after-hook-2.2.3.tgz
https://registry.npmjs.org/before-after-hook/-/before-after-hook-4.0.0.tgz
https://registry.npmjs.org/big.js/-/big.js-5.2.2.tgz
https://registry.npmjs.org/bignumber.js/-/bignumber.js-9.3.1.tgz
https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.1.0.tgz
https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz
https://registry.npmjs.org/bl/-/bl-4.1.0.tgz
https://registry.npmjs.org/bluebird/-/bluebird-3.7.2.tgz
https://registry.npmjs.org/body-parser/-/body-parser-1.20.3.tgz
https://registry.npmjs.org/boolean/-/boolean-3.2.0.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.12.tgz
https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.2.tgz
https://registry.npmjs.org/braces/-/braces-3.0.3.tgz
https://registry.npmjs.org/browser-stdout/-/browser-stdout-1.3.1.tgz
https://registry.npmjs.org/browserslist/-/browserslist-4.23.3.tgz
https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.1.tgz
https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz
https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz
https://registry.npmjs.org/buffer/-/buffer-6.0.3.tgz
https://registry.npmjs.org/buildcheck/-/buildcheck-0.0.6.tgz
https://registry.npmjs.org/builtin-modules/-/builtin-modules-3.3.0.tgz
https://registry.npmjs.org/builtins/-/builtins-5.0.1.tgz
https://registry.npmjs.org/busboy/-/busboy-1.6.0.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz
https://registry.npmjs.org/cacache/-/cacache-19.0.1.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-7.0.2.tgz
https://registry.npmjs.org/call-bind-apply-helpers/-/call-bind-apply-helpers-1.0.2.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.2.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.7.tgz
https://registry.npmjs.org/call-bind/-/call-bind-1.0.8.tgz
https://registry.npmjs.org/call-bound/-/call-bound-1.0.4.tgz
https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz
https://registry.npmjs.org/camelcase/-/camelcase-6.3.0.tgz
https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001659.tgz
https://registry.npmjs.org/canvas/-/canvas-2.11.2.tgz
https://registry.npmjs.org/ccount/-/ccount-2.0.1.tgz
https://registry.npmjs.org/chai-as-promised/-/chai-as-promised-7.1.2.tgz
https://registry.npmjs.org/chai/-/chai-4.5.0.tgz
https://registry.npmjs.org/chai/-/chai-5.1.1.tgz
https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz
https://registry.npmjs.org/chalk/-/chalk-3.0.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.0.tgz
https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz
https://registry.npmjs.org/chalk/-/chalk-5.3.0.tgz
https://registry.npmjs.org/chalk/-/chalk-5.4.1.tgz
https://registry.npmjs.org/character-entities-html4/-/character-entities-html4-2.1.0.tgz
https://registry.npmjs.org/character-entities-legacy/-/character-entities-legacy-1.1.4.tgz
https://registry.npmjs.org/character-entities-legacy/-/character-entities-legacy-3.0.0.tgz
https://registry.npmjs.org/character-entities/-/character-entities-1.2.4.tgz
https://registry.npmjs.org/character-entities/-/character-entities-2.0.0.tgz
https://registry.npmjs.org/character-reference-invalid/-/character-reference-invalid-1.1.4.tgz
https://registry.npmjs.org/character-reference-invalid/-/character-reference-invalid-2.0.0.tgz
https://registry.npmjs.org/chardet/-/chardet-2.1.1.tgz
https://registry.npmjs.org/charenc/-/charenc-0.0.2.tgz
https://registry.npmjs.org/check-error/-/check-error-1.0.3.tgz
https://registry.npmjs.org/check-error/-/check-error-2.1.1.tgz
https://registry.npmjs.org/check-for-leaks/-/check-for-leaks-1.2.1.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.5.2.tgz
https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz
https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz
https://registry.npmjs.org/chownr/-/chownr-3.0.0.tgz
https://registry.npmjs.org/chrome-trace-event/-/chrome-trace-event-1.0.2.tgz
https://registry.npmjs.org/ci-info/-/ci-info-4.0.0.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-3.1.0.tgz
https://registry.npmjs.org/cli-cursor/-/cli-cursor-5.0.0.tgz
https://registry.npmjs.org/cli-spinners/-/cli-spinners-2.9.2.tgz
https://registry.npmjs.org/cli-truncate/-/cli-truncate-4.0.0.tgz
https://registry.npmjs.org/cli-width/-/cli-width-3.0.0.tgz
https://registry.npmjs.org/clipanion/-/clipanion-3.2.1.tgz
https://registry.npmjs.org/cliui/-/cliui-7.0.4.tgz
https://registry.npmjs.org/clone-deep/-/clone-deep-4.0.1.tgz
https://registry.npmjs.org/clone-response/-/clone-response-1.0.2.tgz
https://registry.npmjs.org/clone/-/clone-1.0.4.tgz
https://registry.npmjs.org/coffeescript/-/coffeescript-2.7.0.tgz
https://registry.npmjs.org/collapse-white-space/-/collapse-white-space-2.1.0.tgz
https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz
https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz
https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz
https://registry.npmjs.org/color-support/-/color-support-1.1.3.tgz
https://registry.npmjs.org/colorette/-/colorette-2.0.20.tgz
https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz
https://registry.npmjs.org/comma-separated-tokens/-/comma-separated-tokens-2.0.3.tgz
https://registry.npmjs.org/commander/-/commander-10.0.1.tgz
https://registry.npmjs.org/commander/-/commander-14.0.0.tgz
https://registry.npmjs.org/commander/-/commander-2.20.3.tgz
https://registry.npmjs.org/commander/-/commander-5.1.0.tgz
https://registry.npmjs.org/commander/-/commander-8.3.0.tgz
https://registry.npmjs.org/commander/-/commander-9.5.0.tgz
https://registry.npmjs.org/compare-version/-/compare-version-0.1.2.tgz
https://registry.npmjs.org/compress-brotli/-/compress-brotli-1.3.8.tgz
https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz
https://registry.npmjs.org/concat-stream/-/concat-stream-2.0.0.tgz
https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz
https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.4.tgz
https://registry.npmjs.org/content-type/-/content-type-1.0.5.tgz
https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz
https://registry.npmjs.org/cookie/-/cookie-0.7.1.tgz
https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz
https://registry.npmjs.org/cpu-features/-/cpu-features-0.0.10.tgz
https://registry.npmjs.org/cross-dirname/-/cross-dirname-0.1.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz
https://registry.npmjs.org/crypt/-/crypt-0.0.2.tgz
https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz
https://registry.npmjs.org/data-uri-to-buffer/-/data-uri-to-buffer-6.0.2.tgz
https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.1.tgz
https://registry.npmjs.org/data-view-buffer/-/data-view-buffer-1.0.2.tgz
https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.1.tgz
https://registry.npmjs.org/data-view-byte-length/-/data-view-byte-length-1.0.2.tgz
https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.0.tgz
https://registry.npmjs.org/data-view-byte-offset/-/data-view-byte-offset-1.0.1.tgz
https://registry.npmjs.org/datadog-metrics/-/datadog-metrics-0.9.3.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz
https://registry.npmjs.org/debug/-/debug-3.1.0.tgz
https://registry.npmjs.org/debug/-/debug-3.2.7.tgz
https://registry.npmjs.org/debug/-/debug-4.4.0.tgz
https://registry.npmjs.org/debug/-/debug-4.4.1.tgz
https://registry.npmjs.org/debug/-/debug-4.4.3.tgz
https://registry.npmjs.org/decamelize/-/decamelize-4.0.0.tgz
https://registry.npmjs.org/decode-named-character-reference/-/decode-named-character-reference-1.0.2.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-4.2.1.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz
https://registry.npmjs.org/deep-eql/-/deep-eql-4.1.4.tgz
https://registry.npmjs.org/deep-eql/-/deep-eql-5.0.2.tgz
https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz
https://registry.npmjs.org/deep-is/-/deep-is-0.1.3.tgz
https://registry.npmjs.org/defaults/-/defaults-1.0.4.tgz
https://registry.npmjs.org/defer-to-connect/-/defer-to-connect-2.0.1.tgz
https://registry.npmjs.org/define-data-property/-/define-data-property-1.1.4.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.0.tgz
https://registry.npmjs.org/define-properties/-/define-properties-1.2.1.tgz
https://registry.npmjs.org/degenerator/-/degenerator-5.0.1.tgz
https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz
https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz
https://registry.npmjs.org/deprecation/-/deprecation-2.3.1.tgz
https://registry.npmjs.org/dequal/-/dequal-2.0.3.tgz
https://registry.npmjs.org/destroy/-/destroy-1.2.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.1.2.tgz
https://registry.npmjs.org/detect-node/-/detect-node-2.1.0.tgz
https://registry.npmjs.org/devlop/-/devlop-1.1.0.tgz
https://registry.npmjs.org/diff/-/diff-3.5.0.tgz
https://registry.npmjs.org/diff/-/diff-4.0.2.tgz
https://registry.npmjs.org/diff/-/diff-5.2.0.tgz
https://registry.npmjs.org/dir-compare/-/dir-compare-4.2.0.tgz
https://registry.npmjs.org/dirty-chai/-/dirty-chai-2.0.1.tgz
https://registry.npmjs.org/doctrine/-/doctrine-2.1.0.tgz
https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz
https://registry.npmjs.org/dogapi/-/dogapi-2.8.4.tgz
https://registry.npmjs.org/dunder-proto/-/dunder-proto-1.0.1.tgz
https://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz
https://registry.npmjs.org/duplexer/-/duplexer-0.1.2.tgz
https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz
https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.2.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz
https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.18.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-10.4.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz
https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz
https://registry.npmjs.org/emojis-list/-/emojis-list-3.0.0.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.2.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-2.0.0.tgz
https://registry.npmjs.org/encoding/-/encoding-0.1.13.tgz
https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.4.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-4.1.0.tgz
https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.17.1.tgz
https://registry.npmjs.org/ensure-posix-path/-/ensure-posix-path-1.1.1.tgz
https://registry.npmjs.org/entities/-/entities-4.5.0.tgz
https://registry.npmjs.org/env-paths/-/env-paths-2.2.1.tgz
https://registry.npmjs.org/envinfo/-/envinfo-7.20.0.tgz
https://registry.npmjs.org/environment/-/environment-1.1.0.tgz
https://registry.npmjs.org/err-code/-/err-code-2.0.3.tgz
https://registry.npmjs.org/errno/-/errno-0.1.7.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.2.tgz
https://registry.npmjs.org/error-ex/-/error-ex-1.3.4.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.21.2.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.23.3.tgz
https://registry.npmjs.org/es-abstract/-/es-abstract-1.24.0.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.0.tgz
https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.1.tgz
https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz
https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-1.5.4.tgz
https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.0.0.tgz
https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.1.1.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.0.3.tgz
https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.1.0.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.0.2.tgz
https://registry.npmjs.org/es-shim-unscopables/-/es-shim-unscopables-1.1.0.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.2.1.tgz
https://registry.npmjs.org/es-to-primitive/-/es-to-primitive-1.3.0.tgz
https://registry.npmjs.org/es6-error/-/es6-error-4.1.1.tgz
https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz
https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz
https://registry.npmjs.org/escodegen/-/escodegen-2.1.0.tgz
https://registry.npmjs.org/eslint-compat-utils/-/eslint-compat-utils-0.5.1.tgz
https://registry.npmjs.org/eslint-config-standard-jsx/-/eslint-config-standard-jsx-11.0.0.tgz
https://registry.npmjs.org/eslint-config-standard/-/eslint-config-standard-17.0.0.tgz
https://registry.npmjs.org/eslint-config-standard/-/eslint-config-standard-17.1.0.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz
https://registry.npmjs.org/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.9.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.12.1.tgz
https://registry.npmjs.org/eslint-module-utils/-/eslint-module-utils-2.8.0.tgz
https://registry.npmjs.org/eslint-plugin-es-x/-/eslint-plugin-es-x-7.8.0.tgz
https://registry.npmjs.org/eslint-plugin-es/-/eslint-plugin-es-3.0.1.tgz
https://registry.npmjs.org/eslint-plugin-es/-/eslint-plugin-es-4.1.0.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz
https://registry.npmjs.org/eslint-plugin-import/-/eslint-plugin-import-2.32.0.tgz
https://registry.npmjs.org/eslint-plugin-markdown/-/eslint-plugin-markdown-5.1.0.tgz
https://registry.npmjs.org/eslint-plugin-mocha/-/eslint-plugin-mocha-10.5.0.tgz
https://registry.npmjs.org/eslint-plugin-n/-/eslint-plugin-n-15.7.0.tgz
https://registry.npmjs.org/eslint-plugin-n/-/eslint-plugin-n-16.6.2.tgz
https://registry.npmjs.org/eslint-plugin-node/-/eslint-plugin-node-11.1.0.tgz
https://registry.npmjs.org/eslint-plugin-promise/-/eslint-plugin-promise-6.1.1.tgz
https://registry.npmjs.org/eslint-plugin-promise/-/eslint-plugin-promise-6.6.0.tgz
https://registry.npmjs.org/eslint-plugin-react/-/eslint-plugin-react-7.32.2.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz
https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.2.2.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-2.1.0.tgz
https://registry.npmjs.org/eslint-utils/-/eslint-utils-3.0.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-1.1.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-2.0.0.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz
https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-4.2.0.tgz
https://registry.npmjs.org/eslint/-/eslint-8.57.1.tgz
https://registry.npmjs.org/espree/-/espree-9.6.1.tgz
https://registry.npmjs.org/esprima/-/esprima-4.0.1.tgz
https://registry.npmjs.org/esquery/-/esquery-1.5.0.tgz
https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.1.0.tgz
https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz
https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz
https://registry.npmjs.org/event-stream/-/event-stream-4.0.1.tgz
https://registry.npmjs.org/eventemitter3/-/eventemitter3-5.0.1.tgz
https://registry.npmjs.org/events-to-array/-/events-to-array-1.1.2.tgz
https://registry.npmjs.org/events/-/events-3.3.0.tgz
https://registry.npmjs.org/exponential-backoff/-/exponential-backoff-3.1.3.tgz
https://registry.npmjs.org/express/-/express-4.21.2.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz
https://registry.npmjs.org/extract-zip/-/extract-zip-2.0.1.tgz
https://registry.npmjs.org/fast-content-type-parse/-/fast-content-type-parse-3.0.0.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz
https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.3.tgz
https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz
https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-3.0.0.tgz
https://registry.npmjs.org/fast-uri/-/fast-uri-3.0.1.tgz
https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-4.5.3.tgz
https://registry.npmjs.org/fast-xml-parser/-/fast-xml-parser-5.2.5.tgz
https://registry.npmjs.org/fastest-levenshtein/-/fastest-levenshtein-1.0.14.tgz
https://registry.npmjs.org/fastest-levenshtein/-/fastest-levenshtein-1.0.16.tgz
https://registry.npmjs.org/fastq/-/fastq-1.8.0.tgz
https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz
https://registry.npmjs.org/fdir/-/fdir-6.5.0.tgz
https://registry.npmjs.org/figures/-/figures-3.2.0.tgz
https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz
https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz
https://registry.npmjs.org/filename-reserved-regex/-/filename-reserved-regex-2.0.0.tgz
https://registry.npmjs.org/filenamify/-/filenamify-4.3.0.tgz
https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz
https://registry.npmjs.org/finalhandler/-/finalhandler-1.3.1.tgz
https://registry.npmjs.org/find-up/-/find-up-2.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-3.0.0.tgz
https://registry.npmjs.org/find-up/-/find-up-4.1.0.tgz
https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz
https://registry.npmjs.org/flat-cache/-/flat-cache-3.0.4.tgz
https://registry.npmjs.org/flat/-/flat-5.0.2.tgz
https://registry.npmjs.org/flatted/-/flatted-3.2.7.tgz
https://registry.npmjs.org/flora-colossus/-/flora-colossus-2.0.0.tgz
https://registry.npmjs.org/folder-hash/-/folder-hash-4.1.1.tgz
https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.11.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.3.tgz
https://registry.npmjs.org/for-each/-/for-each-0.3.5.tgz
https://registry.npmjs.org/foreground-child/-/foreground-child-3.1.1.tgz
https://registry.npmjs.org/form-data/-/form-data-4.0.4.tgz
https://registry.npmjs.org/forwarded/-/forwarded-0.2.0.tgz
https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz
https://registry.npmjs.org/from/-/from-0.1.7.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-11.3.2.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz
https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz
https://registry.npmjs.org/fs-minipass/-/fs-minipass-3.0.3.tgz
https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz
https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz
https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.5.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.6.tgz
https://registry.npmjs.org/function.prototype.name/-/function.prototype.name-1.1.8.tgz
https://registry.npmjs.org/functions-have-names/-/functions-have-names-1.2.3.tgz
https://registry.npmjs.org/galactus/-/galactus-1.0.0.tgz
https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz
https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz
https://registry.npmjs.org/get-east-asian-width/-/get-east-asian-width-1.2.0.tgz
https://registry.npmjs.org/get-func-name/-/get-func-name-2.0.2.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.1.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.2.4.tgz
https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.3.0.tgz
https://registry.npmjs.org/get-package-info/-/get-package-info-1.0.0.tgz
https://registry.npmjs.org/get-proto/-/get-proto-1.0.1.tgz
https://registry.npmjs.org/get-stdin/-/get-stdin-8.0.0.tgz
https://registry.npmjs.org/get-stream/-/get-stream-5.2.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.0.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.0.2.tgz
https://registry.npmjs.org/get-symbol-description/-/get-symbol-description-1.1.0.tgz
https://registry.npmjs.org/get-tsconfig/-/get-tsconfig-4.8.1.tgz
https://registry.npmjs.org/get-uri/-/get-uri-6.0.5.tgz
https://registry.npmjs.org/get-value/-/get-value-4.0.1.tgz
https://registry.npmjs.org/getos/-/getos-3.2.1.tgz
https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz
https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz
https://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz
https://registry.npmjs.org/glob/-/glob-10.4.5.tgz
https://registry.npmjs.org/glob/-/glob-7.2.0.tgz
https://registry.npmjs.org/glob/-/glob-8.1.0.tgz
https://registry.npmjs.org/glob/-/glob-9.3.5.tgz
https://registry.npmjs.org/global-agent/-/global-agent-3.0.0.tgz
https://registry.npmjs.org/globals/-/globals-13.20.0.tgz
https://registry.npmjs.org/globals/-/globals-13.24.0.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.3.tgz
https://registry.npmjs.org/globalthis/-/globalthis-1.0.4.tgz
https://registry.npmjs.org/globby/-/globby-14.1.0.tgz
https://registry.npmjs.org/gopd/-/gopd-1.0.1.tgz
https://registry.npmjs.org/gopd/-/gopd-1.2.0.tgz
https://registry.npmjs.org/got/-/got-11.8.5.tgz
https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz
https://registry.npmjs.org/graphemer/-/graphemer-1.4.0.tgz
https://registry.npmjs.org/has-bigints/-/has-bigints-1.0.2.tgz
https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz
https://registry.npmjs.org/has-flag/-/has-flag-5.0.1.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz
https://registry.npmjs.org/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.1.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.0.3.tgz
https://registry.npmjs.org/has-proto/-/has-proto-1.2.0.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.0.3.tgz
https://registry.npmjs.org/has-symbols/-/has-symbols-1.1.0.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.0.tgz
https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz
https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz
https://registry.npmjs.org/has/-/has-1.0.3.tgz
https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz
https://registry.npmjs.org/hast-util-from-html/-/hast-util-from-html-2.0.1.tgz
https://registry.npmjs.org/hast-util-from-parse5/-/hast-util-from-parse5-8.0.1.tgz
https://registry.npmjs.org/hast-util-parse-selector/-/hast-util-parse-selector-4.0.0.tgz
https://registry.npmjs.org/hastscript/-/hastscript-8.0.0.tgz
https://registry.npmjs.org/he/-/he-1.2.0.tgz
https://registry.npmjs.org/hexy/-/hexy-0.2.11.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.8.9.tgz
https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-7.0.2.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.2.0.tgz
https://registry.npmjs.org/http-errors/-/http-errors-2.0.0.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-1.0.3.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.5.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.6.tgz
https://registry.npmjs.org/husky/-/husky-9.1.7.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz
https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.7.0.tgz
https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz
https://registry.npmjs.org/ignore/-/ignore-5.3.1.tgz
https://registry.npmjs.org/ignore/-/ignore-7.0.4.tgz
https://registry.npmjs.org/immediate/-/immediate-3.0.6.tgz
https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz
https://registry.npmjs.org/import-local/-/import-local-3.1.0.tgz
https://registry.npmjs.org/import-meta-resolve/-/import-meta-resolve-4.1.0.tgz
https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz
https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz
https://registry.npmjs.org/ini/-/ini-1.3.8.tgz
https://registry.npmjs.org/ini/-/ini-4.1.3.tgz
https://registry.npmjs.org/inquirer/-/inquirer-8.2.7.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.5.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.0.7.tgz
https://registry.npmjs.org/internal-slot/-/internal-slot-1.1.0.tgz
https://registry.npmjs.org/interpret/-/interpret-3.1.1.tgz
https://registry.npmjs.org/ip-address/-/ip-address-10.0.1.tgz
https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.9.1.tgz
https://registry.npmjs.org/is-alphabetical/-/is-alphabetical-1.0.4.tgz
https://registry.npmjs.org/is-alphabetical/-/is-alphabetical-2.0.0.tgz
https://registry.npmjs.org/is-alphanumerical/-/is-alphanumerical-1.0.4.tgz
https://registry.npmjs.org/is-alphanumerical/-/is-alphanumerical-2.0.0.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.2.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.4.tgz
https://registry.npmjs.org/is-array-buffer/-/is-array-buffer-3.0.5.tgz
https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz
https://registry.npmjs.org/is-async-function/-/is-async-function-2.1.1.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.0.4.tgz
https://registry.npmjs.org/is-bigint/-/is-bigint-1.1.0.tgz
https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.1.2.tgz
https://registry.npmjs.org/is-boolean-object/-/is-boolean-object-1.2.2.tgz
https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.6.tgz
https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-3.2.1.tgz
https://registry.npmjs.org/is-callable/-/is-callable-1.2.7.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.12.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.16.1.tgz
https://registry.npmjs.org/is-core-module/-/is-core-module-2.9.0.tgz
https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.1.tgz
https://registry.npmjs.org/is-data-view/-/is-data-view-1.0.2.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.0.5.tgz
https://registry.npmjs.org/is-date-object/-/is-date-object-1.1.0.tgz
https://registry.npmjs.org/is-decimal/-/is-decimal-1.0.4.tgz
https://registry.npmjs.org/is-decimal/-/is-decimal-2.0.0.tgz
https://registry.npmjs.org/is-empty/-/is-empty-1.2.0.tgz
https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz
https://registry.npmjs.org/is-finalizationregistry/-/is-finalizationregistry-1.1.1.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-4.0.0.tgz
https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-5.0.0.tgz
https://registry.npmjs.org/is-generator-function/-/is-generator-function-1.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-3.1.0.tgz
https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz
https://registry.npmjs.org/is-hexadecimal/-/is-hexadecimal-1.0.4.tgz
https://registry.npmjs.org/is-hexadecimal/-/is-hexadecimal-2.0.0.tgz
https://registry.npmjs.org/is-interactive/-/is-interactive-1.0.0.tgz
https://registry.npmjs.org/is-interactive/-/is-interactive-2.0.0.tgz
https://registry.npmjs.org/is-map/-/is-map-2.0.3.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.2.tgz
https://registry.npmjs.org/is-negative-zero/-/is-negative-zero-2.0.3.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.0.7.tgz
https://registry.npmjs.org/is-number-object/-/is-number-object-1.1.1.tgz
https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz
https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-2.1.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.0.0.tgz
https://registry.npmjs.org/is-plain-object/-/is-plain-object-2.0.4.tgz
https://registry.npmjs.org/is-primitive/-/is-primitive-3.0.1.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.1.4.tgz
https://registry.npmjs.org/is-regex/-/is-regex-1.2.1.tgz
https://registry.npmjs.org/is-set/-/is-set-2.0.3.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz
https://registry.npmjs.org/is-shared-array-buffer/-/is-shared-array-buffer-1.0.4.tgz
https://registry.npmjs.org/is-string/-/is-string-1.0.7.tgz
https://registry.npmjs.org/is-string/-/is-string-1.1.1.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.0.4.tgz
https://registry.npmjs.org/is-symbol/-/is-symbol-1.1.1.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.10.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.13.tgz
https://registry.npmjs.org/is-typed-array/-/is-typed-array-1.1.15.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-0.1.0.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-1.3.0.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-2.1.0.tgz
https://registry.npmjs.org/is-weakmap/-/is-weakmap-2.0.2.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.0.2.tgz
https://registry.npmjs.org/is-weakref/-/is-weakref-1.1.1.tgz
https://registry.npmjs.org/is-weakset/-/is-weakset-2.0.4.tgz
https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz
https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz
https://registry.npmjs.org/isarray/-/isarray-2.0.5.tgz
https://registry.npmjs.org/isbinaryfile/-/isbinaryfile-4.0.10.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz
https://registry.npmjs.org/isexe/-/isexe-3.1.1.tgz
https://registry.npmjs.org/isobject/-/isobject-3.0.1.tgz
https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz
https://registry.npmjs.org/jest-worker/-/jest-worker-27.5.1.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-3.13.1.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz
https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz
https://registry.npmjs.org/json-bigint/-/json-bigint-1.0.0.tgz
https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz
https://registry.npmjs.org/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz
https://registry.npmjs.org/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.2.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz
https://registry.npmjs.org/json5/-/json5-1.0.2.tgz
https://registry.npmjs.org/json5/-/json5-2.2.3.tgz
https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-3.3.1.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz
https://registry.npmjs.org/jsonfile/-/jsonfile-6.0.1.tgz
https://registry.npmjs.org/jsx-ast-utils/-/jsx-ast-utils-3.3.3.tgz
https://registry.npmjs.org/jszip/-/jszip-3.10.1.tgz
https://registry.npmjs.org/junk/-/junk-3.1.0.tgz
https://registry.npmjs.org/just-extend/-/just-extend-4.2.1.tgz
https://registry.npmjs.org/katex/-/katex-0.16.22.tgz
https://registry.npmjs.org/keyv/-/keyv-4.3.1.tgz
https://registry.npmjs.org/kind-of/-/kind-of-6.0.3.tgz
https://registry.npmjs.org/levn/-/levn-0.4.1.tgz
https://registry.npmjs.org/lie/-/lie-3.3.0.tgz
https://registry.npmjs.org/lilconfig/-/lilconfig-3.1.3.tgz
https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-2.0.4.tgz
https://registry.npmjs.org/linkify-it/-/linkify-it-5.0.0.tgz
https://registry.npmjs.org/lint-staged/-/lint-staged-16.1.0.tgz
https://registry.npmjs.org/listr2/-/listr2-8.3.3.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-2.0.0.tgz
https://registry.npmjs.org/load-json-file/-/load-json-file-5.3.0.tgz
https://registry.npmjs.org/load-plugin/-/load-plugin-6.0.3.tgz
https://registry.npmjs.org/loader-runner/-/loader-runner-4.3.0.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-1.4.2.tgz
https://registry.npmjs.org/loader-utils/-/loader-utils-2.0.4.tgz
https://registry.npmjs.org/locate-path/-/locate-path-2.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-3.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-5.0.0.tgz
https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz
https://registry.npmjs.org/lodash.camelcase/-/lodash.camelcase-4.3.0.tgz
https://registry.npmjs.org/lodash.get/-/lodash.get-4.4.2.tgz
https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz
https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-4.1.0.tgz
https://registry.npmjs.org/log-symbols/-/log-symbols-6.0.0.tgz
https://registry.npmjs.org/log-update/-/log-update-6.1.0.tgz
https://registry.npmjs.org/long/-/long-4.0.0.tgz
https://registry.npmjs.org/longest-streak/-/longest-streak-3.0.0.tgz
https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz
https://registry.npmjs.org/loupe/-/loupe-2.3.7.tgz
https://registry.npmjs.org/loupe/-/loupe-3.1.1.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-2.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.2.2.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-7.18.3.tgz
https://registry.npmjs.org/lru-cache/-/lru-cache-9.1.1.tgz
https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz
https://registry.npmjs.org/make-error/-/make-error-1.3.5.tgz
https://registry.npmjs.org/make-fetch-happen/-/make-fetch-happen-14.0.3.tgz
https://registry.npmjs.org/map-stream/-/map-stream-0.0.7.tgz
https://registry.npmjs.org/markdown-extensions/-/markdown-extensions-2.0.0.tgz
https://registry.npmjs.org/markdown-it/-/markdown-it-14.1.0.tgz
https://registry.npmjs.org/markdownlint-cli2-formatter-default/-/markdownlint-cli2-formatter-default-0.0.5.tgz
https://registry.npmjs.org/markdownlint-cli2/-/markdownlint-cli2-0.18.0.tgz
https://registry.npmjs.org/markdownlint/-/markdownlint-0.38.0.tgz
https://registry.npmjs.org/matcher-collection/-/matcher-collection-1.1.2.tgz
https://registry.npmjs.org/matcher/-/matcher-3.0.0.tgz
https://registry.npmjs.org/math-intrinsics/-/math-intrinsics-1.1.0.tgz
https://registry.npmjs.org/md5/-/md5-2.3.0.tgz
https://registry.npmjs.org/mdast-comment-marker/-/mdast-comment-marker-3.0.0.tgz
https://registry.npmjs.org/mdast-util-directive/-/mdast-util-directive-3.1.0.tgz
https://registry.npmjs.org/mdast-util-from-markdown/-/mdast-util-from-markdown-0.8.5.tgz
https://registry.npmjs.org/mdast-util-from-markdown/-/mdast-util-from-markdown-2.0.2.tgz
https://registry.npmjs.org/mdast-util-heading-style/-/mdast-util-heading-style-3.0.0.tgz
https://registry.npmjs.org/mdast-util-mdx-expression/-/mdast-util-mdx-expression-2.0.1.tgz
https://registry.npmjs.org/mdast-util-mdx-jsx/-/mdast-util-mdx-jsx-3.2.0.tgz
https://registry.npmjs.org/mdast-util-mdx/-/mdast-util-mdx-3.0.0.tgz
https://registry.npmjs.org/mdast-util-mdxjs-esm/-/mdast-util-mdxjs-esm-2.0.1.tgz
https://registry.npmjs.org/mdast-util-phrasing/-/mdast-util-phrasing-4.1.0.tgz
https://registry.npmjs.org/mdast-util-to-markdown/-/mdast-util-to-markdown-2.1.0.tgz
https://registry.npmjs.org/mdast-util-to-string/-/mdast-util-to-string-2.0.0.tgz
https://registry.npmjs.org/mdast-util-to-string/-/mdast-util-to-string-4.0.0.tgz
https://registry.npmjs.org/mdurl/-/mdurl-2.0.0.tgz
https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz
https://registry.npmjs.org/memory-fs/-/memory-fs-0.4.1.tgz
https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.3.tgz
https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz
https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz
https://registry.npmjs.org/methods/-/methods-1.1.2.tgz
https://registry.npmjs.org/micromark-core-commonmark/-/micromark-core-commonmark-2.0.1.tgz
https://registry.npmjs.org/micromark-core-commonmark/-/micromark-core-commonmark-2.0.3.tgz
https://registry.npmjs.org/micromark-extension-directive/-/micromark-extension-directive-4.0.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-autolink-literal/-/micromark-extension-gfm-autolink-literal-2.1.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-footnote/-/micromark-extension-gfm-footnote-2.1.0.tgz
https://registry.npmjs.org/micromark-extension-gfm-table/-/micromark-extension-gfm-table-2.1.1.tgz
https://registry.npmjs.org/micromark-extension-math/-/micromark-extension-math-3.1.0.tgz
https://registry.npmjs.org/micromark-factory-destination/-/micromark-factory-destination-2.0.0.tgz
https://registry.npmjs.org/micromark-factory-label/-/micromark-factory-label-2.0.0.tgz
https://registry.npmjs.org/micromark-factory-space/-/micromark-factory-space-2.0.0.tgz
https://registry.npmjs.org/micromark-factory-title/-/micromark-factory-title-2.0.0.tgz
https://registry.npmjs.org/micromark-factory-whitespace/-/micromark-factory-whitespace-2.0.0.tgz
https://registry.npmjs.org/micromark-util-character/-/micromark-util-character-2.1.0.tgz
https://registry.npmjs.org/micromark-util-chunked/-/micromark-util-chunked-2.0.0.tgz
https://registry.npmjs.org/micromark-util-classify-character/-/micromark-util-classify-character-2.0.0.tgz
https://registry.npmjs.org/micromark-util-combine-extensions/-/micromark-util-combine-extensions-2.0.0.tgz
https://registry.npmjs.org/micromark-util-decode-numeric-character-reference/-/micromark-util-decode-numeric-character-reference-2.0.1.tgz
https://registry.npmjs.org/micromark-util-decode-string/-/micromark-util-decode-string-2.0.0.tgz
https://registry.npmjs.org/micromark-util-encode/-/micromark-util-encode-2.0.0.tgz
https://registry.npmjs.org/micromark-util-html-tag-name/-/micromark-util-html-tag-name-2.0.0.tgz
https://registry.npmjs.org/micromark-util-normalize-identifier/-/micromark-util-normalize-identifier-2.0.0.tgz
https://registry.npmjs.org/micromark-util-resolve-all/-/micromark-util-resolve-all-2.0.0.tgz
https://registry.npmjs.org/micromark-util-sanitize-uri/-/micromark-util-sanitize-uri-2.0.0.tgz
https://registry.npmjs.org/micromark-util-subtokenize/-/micromark-util-subtokenize-2.0.1.tgz
https://registry.npmjs.org/micromark-util-symbol/-/micromark-util-symbol-2.0.0.tgz
https://registry.npmjs.org/micromark-util-types/-/micromark-util-types-2.0.0.tgz
https://registry.npmjs.org/micromark-util-types/-/micromark-util-types-2.0.2.tgz
https://registry.npmjs.org/micromark/-/micromark-2.11.4.tgz
https://registry.npmjs.org/micromark/-/micromark-4.0.0.tgz
https://registry.npmjs.org/micromark/-/micromark-4.0.2.tgz
https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz
https://registry.npmjs.org/mime/-/mime-1.6.0.tgz
https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz
https://registry.npmjs.org/mimic-function/-/mimic-function-5.0.1.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-1.0.1.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-2.1.0.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz
https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz
https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz
https://registry.npmjs.org/minimatch/-/minimatch-7.4.6.tgz
https://registry.npmjs.org/minimatch/-/minimatch-8.0.4.tgz
https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz
https://registry.npmjs.org/minimist/-/minimist-0.2.4.tgz
https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz
https://registry.npmjs.org/minipass-collect/-/minipass-collect-2.0.1.tgz
https://registry.npmjs.org/minipass-fetch/-/minipass-fetch-4.0.1.tgz
https://registry.npmjs.org/minipass-flush/-/minipass-flush-1.0.5.tgz
https://registry.npmjs.org/minipass-pipeline/-/minipass-pipeline-1.2.4.tgz
https://registry.npmjs.org/minipass-sized/-/minipass-sized-1.0.3.tgz
https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz
https://registry.npmjs.org/minipass/-/minipass-4.2.8.tgz
https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz
https://registry.npmjs.org/minipass/-/minipass-6.0.2.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.0.tgz
https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz
https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz
https://registry.npmjs.org/minizlib/-/minizlib-3.1.0.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.5.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.6.tgz
https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz
https://registry.npmjs.org/mocha-junit-reporter/-/mocha-junit-reporter-1.23.3.tgz
https://registry.npmjs.org/mocha-multi-reporters/-/mocha-multi-reporters-1.5.1.tgz
https://registry.npmjs.org/mocha/-/mocha-10.8.2.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz
https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.8.tgz
https://registry.npmjs.org/nan/-/nan-2.23.0.tgz
https://registry.npmjs.org/nano-spawn/-/nano-spawn-1.0.2.tgz
https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.3.tgz
https://registry.npmjs.org/negotiator/-/negotiator-1.0.0.tgz
https://registry.npmjs.org/neo-async/-/neo-async-2.6.2.tgz
https://registry.npmjs.org/netmask/-/netmask-2.0.2.tgz
https://registry.npmjs.org/nise/-/nise-4.1.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.0.0.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.7.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.8.tgz
https://registry.npmjs.org/node-gyp/-/node-gyp-11.5.0.tgz
https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz
https://registry.npmjs.org/nopt/-/nopt-5.0.0.tgz
https://registry.npmjs.org/nopt/-/nopt-7.2.1.tgz
https://registry.npmjs.org/nopt/-/nopt-8.1.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.5.0.tgz
https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-6.0.2.tgz
https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-6.1.0.tgz
https://registry.npmjs.org/npm-install-checks/-/npm-install-checks-6.3.0.tgz
https://registry.npmjs.org/npm-normalize-package-bin/-/npm-normalize-package-bin-3.0.1.tgz
https://registry.npmjs.org/npm-package-arg/-/npm-package-arg-11.0.3.tgz
https://registry.npmjs.org/npm-pick-manifest/-/npm-pick-manifest-9.1.0.tgz
https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz
https://registry.npmjs.org/null-loader/-/null-loader-4.0.1.tgz
https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.12.3.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.2.tgz
https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.4.tgz
https://registry.npmjs.org/object-keys/-/object-keys-1.1.1.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.4.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.5.tgz
https://registry.npmjs.org/object.assign/-/object.assign-4.1.7.tgz
https://registry.npmjs.org/object.entries/-/object.entries-1.1.6.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.6.tgz
https://registry.npmjs.org/object.fromentries/-/object.fromentries-2.0.8.tgz
https://registry.npmjs.org/object.groupby/-/object.groupby-1.0.3.tgz
https://registry.npmjs.org/object.hasown/-/object.hasown-1.1.2.tgz
https://registry.npmjs.org/object.values/-/object.values-1.1.6.tgz
https://registry.npmjs.org/object.values/-/object.values-1.2.1.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.4.1.tgz
https://registry.npmjs.org/once/-/once-1.4.0.tgz
https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz
https://registry.npmjs.org/onetime/-/onetime-7.0.0.tgz
https://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz
https://registry.npmjs.org/optionator/-/optionator-0.9.4.tgz
https://registry.npmjs.org/ora/-/ora-5.4.1.tgz
https://registry.npmjs.org/ora/-/ora-8.1.0.tgz
https://registry.npmjs.org/own-keys/-/own-keys-1.0.1.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-2.1.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-1.3.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.2.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-2.3.0.tgz
https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-2.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-3.0.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-4.1.0.tgz
https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz
https://registry.npmjs.org/p-map/-/p-map-7.0.3.tgz
https://registry.npmjs.org/p-try/-/p-try-1.0.0.tgz
https://registry.npmjs.org/p-try/-/p-try-2.2.0.tgz
https://registry.npmjs.org/pac-proxy-agent/-/pac-proxy-agent-7.2.0.tgz
https://registry.npmjs.org/pac-resolver/-/pac-resolver-7.0.1.tgz
https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz
https://registry.npmjs.org/package-manager-detector/-/package-manager-detector-1.5.0.tgz
https://registry.npmjs.org/packageurl-js/-/packageurl-js-2.0.1.tgz
https://registry.npmjs.org/pako/-/pako-1.0.11.tgz
https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz
https://registry.npmjs.org/parse-author/-/parse-author-2.0.0.tgz
https://registry.npmjs.org/parse-entities/-/parse-entities-2.0.0.tgz
https://registry.npmjs.org/parse-entities/-/parse-entities-4.0.2.tgz
https://registry.npmjs.org/parse-gitignore/-/parse-gitignore-0.4.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-4.0.0.tgz
https://registry.npmjs.org/parse-json/-/parse-json-7.1.1.tgz
https://registry.npmjs.org/parse-ms/-/parse-ms-4.0.0.tgz
https://registry.npmjs.org/parse5/-/parse5-7.1.2.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz
https://registry.npmjs.org/path-exists/-/path-exists-3.0.0.tgz
https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz
https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz
https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz
https://registry.npmjs.org/path-scurry/-/path-scurry-1.9.2.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.12.tgz
https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-1.9.0.tgz
https://registry.npmjs.org/path-type/-/path-type-2.0.0.tgz
https://registry.npmjs.org/path-type/-/path-type-6.0.0.tgz
https://registry.npmjs.org/path2d/-/path2d-0.2.2.tgz
https://registry.npmjs.org/pathval/-/pathval-1.1.1.tgz
https://registry.npmjs.org/pathval/-/pathval-2.0.0.tgz
https://registry.npmjs.org/pause-stream/-/pause-stream-0.0.11.tgz
https://registry.npmjs.org/pdfjs-dist/-/pdfjs-dist-4.2.67.tgz
https://registry.npmjs.org/pe-library/-/pe-library-1.0.1.tgz
https://registry.npmjs.org/pend/-/pend-1.2.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.0.7.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.2.2.tgz
https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-4.0.3.tgz
https://registry.npmjs.org/pidtree/-/pidtree-0.6.0.tgz
https://registry.npmjs.org/pify/-/pify-2.3.0.tgz
https://registry.npmjs.org/pify/-/pify-4.0.1.tgz
https://registry.npmjs.org/pkg-conf/-/pkg-conf-3.1.0.tgz
https://registry.npmjs.org/pkg-dir/-/pkg-dir-4.2.0.tgz
https://registry.npmjs.org/plist/-/plist-3.1.0.tgz
https://registry.npmjs.org/pluralize/-/pluralize-8.0.0.tgz
https://registry.npmjs.org/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz
https://registry.npmjs.org/postject/-/postject-1.0.0-alpha.6.tgz
https://registry.npmjs.org/pre-flight/-/pre-flight-2.0.0.tgz
https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz
https://registry.npmjs.org/prettier/-/prettier-3.6.2.tgz
https://registry.npmjs.org/pretty-ms/-/pretty-ms-9.1.0.tgz
https://registry.npmjs.org/proc-log/-/proc-log-4.2.0.tgz
https://registry.npmjs.org/proc-log/-/proc-log-5.0.0.tgz
https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-2.0.1.tgz
https://registry.npmjs.org/process/-/process-0.11.10.tgz
https://registry.npmjs.org/progress/-/progress-2.0.3.tgz
https://registry.npmjs.org/promise-inflight/-/promise-inflight-1.0.1.tgz
https://registry.npmjs.org/promise-retry/-/promise-retry-2.0.1.tgz
https://registry.npmjs.org/prop-types/-/prop-types-15.8.1.tgz
https://registry.npmjs.org/property-information/-/property-information-6.5.0.tgz
https://registry.npmjs.org/proxy-addr/-/proxy-addr-2.0.7.tgz
https://registry.npmjs.org/proxy-agent/-/proxy-agent-6.5.0.tgz
https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-1.1.0.tgz
https://registry.npmjs.org/prr/-/prr-1.0.1.tgz
https://registry.npmjs.org/ps-list/-/ps-list-7.2.0.tgz
https://registry.npmjs.org/pump/-/pump-3.0.0.tgz
https://registry.npmjs.org/punycode.js/-/punycode.js-2.3.1.tgz
https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz
https://registry.npmjs.org/punycode/-/punycode-2.1.1.tgz
https://registry.npmjs.org/q/-/q-1.5.1.tgz
https://registry.npmjs.org/qs/-/qs-6.13.0.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz
https://registry.npmjs.org/quotation/-/quotation-2.0.3.tgz
https://registry.npmjs.org/rambda/-/rambda-7.5.0.tgz
https://registry.npmjs.org/randombytes/-/randombytes-2.1.0.tgz
https://registry.npmjs.org/range-parser/-/range-parser-1.2.1.tgz
https://registry.npmjs.org/raw-body/-/raw-body-2.5.2.tgz
https://registry.npmjs.org/rc/-/rc-1.2.8.tgz
https://registry.npmjs.org/react-is/-/react-is-16.13.1.tgz
https://registry.npmjs.org/read-package-json-fast/-/read-package-json-fast-3.0.2.tgz
https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-2.0.0.tgz
https://registry.npmjs.org/read-pkg/-/read-pkg-2.0.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.6.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.0.tgz
https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz
https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz
https://registry.npmjs.org/rechoir/-/rechoir-0.8.0.tgz
https://registry.npmjs.org/reflect.getprototypeof/-/reflect.getprototypeof-1.0.10.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.0.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.2.tgz
https://registry.npmjs.org/regexp.prototype.flags/-/regexp.prototype.flags-1.5.4.tgz
https://registry.npmjs.org/regexpp/-/regexpp-3.0.0.tgz
https://registry.npmjs.org/remark-cli/-/remark-cli-12.0.1.tgz
https://registry.npmjs.org/remark-lint-blockquote-indentation/-/remark-lint-blockquote-indentation-4.0.1.tgz
https://registry.npmjs.org/remark-lint-code-block-style/-/remark-lint-code-block-style-4.0.1.tgz
https://registry.npmjs.org/remark-lint-definition-case/-/remark-lint-definition-case-4.0.1.tgz
https://registry.npmjs.org/remark-lint-definition-spacing/-/remark-lint-definition-spacing-4.0.1.tgz
https://registry.npmjs.org/remark-lint-emphasis-marker/-/remark-lint-emphasis-marker-4.0.1.tgz
https://registry.npmjs.org/remark-lint-fenced-code-flag/-/remark-lint-fenced-code-flag-4.2.0.tgz
https://registry.npmjs.org/remark-lint-fenced-code-marker/-/remark-lint-fenced-code-marker-4.0.1.tgz
https://registry.npmjs.org/remark-lint-file-extension/-/remark-lint-file-extension-3.0.1.tgz
https://registry.npmjs.org/remark-lint-final-definition/-/remark-lint-final-definition-4.0.2.tgz
https://registry.npmjs.org/remark-lint-hard-break-spaces/-/remark-lint-hard-break-spaces-4.1.1.tgz
https://registry.npmjs.org/remark-lint-heading-increment/-/remark-lint-heading-increment-4.0.1.tgz
https://registry.npmjs.org/remark-lint-heading-style/-/remark-lint-heading-style-4.0.1.tgz
https://registry.npmjs.org/remark-lint-link-title-style/-/remark-lint-link-title-style-4.0.1.tgz
https://registry.npmjs.org/remark-lint-list-item-content-indent/-/remark-lint-list-item-content-indent-4.0.1.tgz
https://registry.npmjs.org/remark-lint-list-item-indent/-/remark-lint-list-item-indent-4.0.1.tgz
https://registry.npmjs.org/remark-lint-list-item-spacing/-/remark-lint-list-item-spacing-5.0.1.tgz
https://registry.npmjs.org/remark-lint-maximum-heading-length/-/remark-lint-maximum-heading-length-4.1.1.tgz
https://registry.npmjs.org/remark-lint-maximum-line-length/-/remark-lint-maximum-line-length-4.1.1.tgz
https://registry.npmjs.org/remark-lint-no-blockquote-without-marker/-/remark-lint-no-blockquote-without-marker-6.0.1.tgz
https://registry.npmjs.org/remark-lint-no-consecutive-blank-lines/-/remark-lint-no-consecutive-blank-lines-5.0.1.tgz
https://registry.npmjs.org/remark-lint-no-duplicate-headings/-/remark-lint-no-duplicate-headings-4.0.1.tgz
https://registry.npmjs.org/remark-lint-no-emphasis-as-heading/-/remark-lint-no-emphasis-as-heading-4.0.1.tgz
https://registry.npmjs.org/remark-lint-no-file-name-articles/-/remark-lint-no-file-name-articles-3.0.1.tgz
https://registry.npmjs.org/remark-lint-no-file-name-consecutive-dashes/-/remark-lint-no-file-name-consecutive-dashes-3.0.1.tgz
https://registry.npmjs.org/remark-lint-no-file-name-irregular-characters/-/remark-lint-no-file-name-irregular-characters-3.0.1.tgz
https://registry.npmjs.org/remark-lint-no-file-name-mixed-case/-/remark-lint-no-file-name-mixed-case-3.0.1.tgz
https://registry.npmjs.org/remark-lint-no-file-name-outer-dashes/-/remark-lint-no-file-name-outer-dashes-3.0.1.tgz
https://registry.npmjs.org/remark-lint-no-heading-punctuation/-/remark-lint-no-heading-punctuation-4.0.1.tgz
https://registry.npmjs.org/remark-lint-no-literal-urls/-/remark-lint-no-literal-urls-4.0.1.tgz
https://registry.npmjs.org/remark-lint-no-multiple-toplevel-headings/-/remark-lint-no-multiple-toplevel-headings-4.0.1.tgz
https://registry.npmjs.org/remark-lint-no-shell-dollars/-/remark-lint-no-shell-dollars-4.0.1.tgz
https://registry.npmjs.org/remark-lint-no-shortcut-reference-image/-/remark-lint-no-shortcut-reference-image-4.0.1.tgz
https://registry.npmjs.org/remark-lint-no-shortcut-reference-link/-/remark-lint-no-shortcut-reference-link-4.0.1.tgz
https://registry.npmjs.org/remark-lint-no-table-indentation/-/remark-lint-no-table-indentation-5.0.1.tgz
https://registry.npmjs.org/remark-lint-ordered-list-marker-style/-/remark-lint-ordered-list-marker-style-4.0.1.tgz
https://registry.npmjs.org/remark-lint-ordered-list-marker-value/-/remark-lint-ordered-list-marker-value-4.0.1.tgz
https://registry.npmjs.org/remark-lint-rule-style/-/remark-lint-rule-style-4.0.1.tgz
https://registry.npmjs.org/remark-lint-strong-marker/-/remark-lint-strong-marker-4.0.1.tgz
https://registry.npmjs.org/remark-lint-table-cell-padding/-/remark-lint-table-cell-padding-5.1.1.tgz
https://registry.npmjs.org/remark-lint-table-pipe-alignment/-/remark-lint-table-pipe-alignment-4.1.1.tgz
https://registry.npmjs.org/remark-lint-table-pipes/-/remark-lint-table-pipes-5.0.1.tgz
https://registry.npmjs.org/remark-lint-unordered-list-marker-style/-/remark-lint-unordered-list-marker-style-4.0.1.tgz
https://registry.npmjs.org/remark-lint/-/remark-lint-10.0.1.tgz
https://registry.npmjs.org/remark-message-control/-/remark-message-control-8.0.0.tgz
https://registry.npmjs.org/remark-parse/-/remark-parse-11.0.0.tgz
https://registry.npmjs.org/remark-preset-lint-markdown-style-guide/-/remark-preset-lint-markdown-style-guide-6.0.1.tgz
https://registry.npmjs.org/remark-stringify/-/remark-stringify-11.0.0.tgz
https://registry.npmjs.org/remark/-/remark-15.0.1.tgz
https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz
https://registry.npmjs.org/resedit/-/resedit-2.0.3.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve-cwd/-/resolve-cwd-3.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz
https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz
https://registry.npmjs.org/resolve-pkg-maps/-/resolve-pkg-maps-1.0.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.17.0.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.11.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.2.tgz
https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz
https://registry.npmjs.org/resolve/-/resolve-2.0.0-next.4.tgz
https://registry.npmjs.org/responselike/-/responselike-2.0.0.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-3.1.0.tgz
https://registry.npmjs.org/restore-cursor/-/restore-cursor-5.1.0.tgz
https://registry.npmjs.org/retry/-/retry-0.12.0.tgz
https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz
https://registry.npmjs.org/rfdc/-/rfdc-1.4.1.tgz
https://registry.npmjs.org/rimraf/-/rimraf-2.6.3.tgz
https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz
https://registry.npmjs.org/rimraf/-/rimraf-4.4.1.tgz
https://registry.npmjs.org/roarr/-/roarr-2.15.4.tgz
https://registry.npmjs.org/run-async/-/run-async-2.4.1.tgz
https://registry.npmjs.org/run-parallel/-/run-parallel-1.1.9.tgz
https://registry.npmjs.org/rxjs/-/rxjs-7.8.2.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.2.tgz
https://registry.npmjs.org/safe-array-concat/-/safe-array-concat-1.1.3.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz
https://registry.npmjs.org/safe-push-apply/-/safe-push-apply-1.0.0.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.0.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.0.3.tgz
https://registry.npmjs.org/safe-regex-test/-/safe-regex-test-1.1.0.tgz
https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz
https://registry.npmjs.org/sax/-/sax-1.4.1.tgz
https://registry.npmjs.org/schema-utils/-/schema-utils-3.3.0.tgz
https://registry.npmjs.org/semver-compare/-/semver-compare-1.0.0.tgz
https://registry.npmjs.org/semver/-/semver-5.7.2.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz
https://registry.npmjs.org/semver/-/semver-7.5.2.tgz
https://registry.npmjs.org/semver/-/semver-7.6.3.tgz
https://registry.npmjs.org/semver/-/semver-7.7.3.tgz
https://registry.npmjs.org/send/-/send-0.19.0.tgz
https://registry.npmjs.org/send/-/send-0.19.1.tgz
https://registry.npmjs.org/serialize-error/-/serialize-error-7.0.1.tgz
https://registry.npmjs.org/serialize-javascript/-/serialize-javascript-6.0.2.tgz
https://registry.npmjs.org/serve-static/-/serve-static-1.16.2.tgz
https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz
https://registry.npmjs.org/set-function-length/-/set-function-length-1.2.2.tgz
https://registry.npmjs.org/set-function-name/-/set-function-name-2.0.2.tgz
https://registry.npmjs.org/set-proto/-/set-proto-1.0.0.tgz
https://registry.npmjs.org/set-value/-/set-value-4.1.0.tgz
https://registry.npmjs.org/setimmediate/-/setimmediate-1.0.5.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz
https://registry.npmjs.org/shallow-clone/-/shallow-clone-3.0.1.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz
https://registry.npmjs.org/side-channel-list/-/side-channel-list-1.0.0.tgz
https://registry.npmjs.org/side-channel-map/-/side-channel-map-1.0.1.tgz
https://registry.npmjs.org/side-channel-weakmap/-/side-channel-weakmap-1.0.2.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.4.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.0.6.tgz
https://registry.npmjs.org/side-channel/-/side-channel-1.1.0.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz
https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz
https://registry.npmjs.org/simple-get/-/simple-get-3.1.1.tgz
https://registry.npmjs.org/simple-git/-/simple-git-3.16.0.tgz
https://registry.npmjs.org/sinon/-/sinon-9.2.4.tgz
https://registry.npmjs.org/slash/-/slash-5.1.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-5.0.0.tgz
https://registry.npmjs.org/slice-ansi/-/slice-ansi-7.1.0.tgz
https://registry.npmjs.org/smart-buffer/-/smart-buffer-4.2.0.tgz
https://registry.npmjs.org/socks-proxy-agent/-/socks-proxy-agent-8.0.5.tgz
https://registry.npmjs.org/socks/-/socks-2.8.7.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.19.tgz
https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz
https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz
https://registry.npmjs.org/space-separated-tokens/-/space-separated-tokens-2.0.2.tgz
https://registry.npmjs.org/spdx-correct/-/spdx-correct-3.2.0.tgz
https://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz
https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz
https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz
https://registry.npmjs.org/split/-/split-1.0.1.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz
https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.2.tgz
https://registry.npmjs.org/ssh2/-/ssh2-1.17.0.tgz
https://registry.npmjs.org/sshpk/-/sshpk-1.16.1.tgz
https://registry.npmjs.org/ssri/-/ssri-12.0.0.tgz
https://registry.npmjs.org/standard-engine/-/standard-engine-15.0.0.tgz
https://registry.npmjs.org/standard/-/standard-17.0.0.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.1.tgz
https://registry.npmjs.org/stdin-discarder/-/stdin-discarder-0.2.2.tgz
https://registry.npmjs.org/stop-iteration-iterator/-/stop-iteration-iterator-1.1.0.tgz
https://registry.npmjs.org/stream-chain/-/stream-chain-2.2.5.tgz
https://registry.npmjs.org/stream-combiner/-/stream-combiner-0.2.2.tgz
https://registry.npmjs.org/stream-json/-/stream-json-1.9.1.tgz
https://registry.npmjs.org/streamsearch/-/streamsearch-1.1.0.tgz
https://registry.npmjs.org/string-argv/-/string-argv-0.3.2.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.0.tgz
https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz
https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz
https://registry.npmjs.org/string-width/-/string-width-6.1.0.tgz
https://registry.npmjs.org/string-width/-/string-width-7.2.0.tgz
https://registry.npmjs.org/string.prototype.matchall/-/string.prototype.matchall-4.0.8.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.10.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz
https://registry.npmjs.org/string.prototype.trim/-/string.prototype.trim-1.2.9.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.8.tgz
https://registry.npmjs.org/string.prototype.trimend/-/string.prototype.trimend-1.0.9.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz
https://registry.npmjs.org/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.1.1.tgz
https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz
https://registry.npmjs.org/stringify-entities/-/stringify-entities-4.0.4.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-4.0.0.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz
https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz
https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz
https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz
https://registry.npmjs.org/strip-outer/-/strip-outer-1.0.1.tgz
https://registry.npmjs.org/strnum/-/strnum-1.1.2.tgz
https://registry.npmjs.org/strnum/-/strnum-2.1.1.tgz
https://registry.npmjs.org/sumchecker/-/sumchecker-3.0.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.1.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz
https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz
https://registry.npmjs.org/supports-color/-/supports-color-9.0.2.tgz
https://registry.npmjs.org/supports-hyperlinks/-/supports-hyperlinks-2.3.0.tgz
https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.npmjs.org/tap-parser/-/tap-parser-1.2.2.tgz
https://registry.npmjs.org/tap-xunit/-/tap-xunit-2.4.1.tgz
https://registry.npmjs.org/tapable/-/tapable-1.1.3.tgz
https://registry.npmjs.org/tapable/-/tapable-2.2.1.tgz
https://registry.npmjs.org/tar/-/tar-6.2.1.tgz
https://registry.npmjs.org/tar/-/tar-7.5.1.tgz
https://registry.npmjs.org/temp/-/temp-0.9.4.tgz
https://registry.npmjs.org/terminal-link/-/terminal-link-2.1.1.tgz
https://registry.npmjs.org/terser-webpack-plugin/-/terser-webpack-plugin-5.3.10.tgz
https://registry.npmjs.org/terser/-/terser-5.32.0.tgz
https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz
https://registry.npmjs.org/through/-/through-2.3.8.tgz
https://registry.npmjs.org/through2/-/through2-2.0.5.tgz
https://registry.npmjs.org/timers-browserify/-/timers-browserify-1.4.2.tgz
https://registry.npmjs.org/tiny-async-pool/-/tiny-async-pool-2.1.0.tgz
https://registry.npmjs.org/tinyexec/-/tinyexec-1.0.2.tgz
https://registry.npmjs.org/tinyglobby/-/tinyglobby-0.2.15.tgz
https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz
https://registry.npmjs.org/toad-cache/-/toad-cache-3.7.0.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz
https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz
https://registry.npmjs.org/trim-repeated/-/trim-repeated-1.0.0.tgz
https://registry.npmjs.org/trough/-/trough-2.0.2.tgz
https://registry.npmjs.org/ts-api-utils/-/ts-api-utils-1.3.0.tgz
https://registry.npmjs.org/ts-api-utils/-/ts-api-utils-2.1.0.tgz
https://registry.npmjs.org/ts-loader/-/ts-loader-8.0.2.tgz
https://registry.npmjs.org/ts-node/-/ts-node-6.2.0.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz
https://registry.npmjs.org/tsconfig-paths/-/tsconfig-paths-3.15.0.tgz
https://registry.npmjs.org/tslib/-/tslib-1.10.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.8.1.tgz
https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz
https://registry.npmjs.org/typanion/-/typanion-3.14.0.tgz
https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.0.8.tgz
https://registry.npmjs.org/type-detect/-/type-detect-4.1.0.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.13.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.21.3.tgz
https://registry.npmjs.org/type-fest/-/type-fest-0.3.1.tgz
https://registry.npmjs.org/type-fest/-/type-fest-3.13.1.tgz
https://registry.npmjs.org/type-is/-/type-is-1.6.18.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz
https://registry.npmjs.org/typed-array-buffer/-/typed-array-buffer-1.0.3.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz
https://registry.npmjs.org/typed-array-byte-length/-/typed-array-byte-length-1.0.3.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.2.tgz
https://registry.npmjs.org/typed-array-byte-offset/-/typed-array-byte-offset-1.0.4.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.4.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.6.tgz
https://registry.npmjs.org/typed-array-length/-/typed-array-length-1.0.7.tgz
https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz
https://registry.npmjs.org/typescript/-/typescript-5.9.3.tgz
https://registry.npmjs.org/uc.micro/-/uc.micro-2.1.0.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.0.2.tgz
https://registry.npmjs.org/unbox-primitive/-/unbox-primitive-1.1.0.tgz
https://registry.npmjs.org/undici-types/-/undici-types-6.19.8.tgz
https://registry.npmjs.org/undici-types/-/undici-types-6.21.0.tgz
https://registry.npmjs.org/unicorn-magic/-/unicorn-magic-0.3.0.tgz
https://registry.npmjs.org/unified-args/-/unified-args-11.0.1.tgz
https://registry.npmjs.org/unified-engine/-/unified-engine-11.2.1.tgz
https://registry.npmjs.org/unified-lint-rule/-/unified-lint-rule-3.0.1.tgz
https://registry.npmjs.org/unified-message-control/-/unified-message-control-5.0.0.tgz
https://registry.npmjs.org/unified/-/unified-11.0.5.tgz
https://registry.npmjs.org/unique-filename/-/unique-filename-4.0.0.tgz
https://registry.npmjs.org/unique-slug/-/unique-slug-5.0.0.tgz
https://registry.npmjs.org/unist-util-inspect/-/unist-util-inspect-8.1.0.tgz
https://registry.npmjs.org/unist-util-is/-/unist-util-is-6.0.0.tgz
https://registry.npmjs.org/unist-util-position/-/unist-util-position-5.0.0.tgz
https://registry.npmjs.org/unist-util-stringify-position/-/unist-util-stringify-position-2.0.1.tgz
https://registry.npmjs.org/unist-util-stringify-position/-/unist-util-stringify-position-4.0.0.tgz
https://registry.npmjs.org/unist-util-visit-parents/-/unist-util-visit-parents-6.0.1.tgz
https://registry.npmjs.org/unist-util-visit/-/unist-util-visit-5.0.0.tgz
https://registry.npmjs.org/universal-github-app-jwt/-/universal-github-app-jwt-2.2.2.tgz
https://registry.npmjs.org/universal-user-agent/-/universal-user-agent-6.0.0.tgz
https://registry.npmjs.org/universal-user-agent/-/universal-user-agent-7.0.3.tgz
https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz
https://registry.npmjs.org/universalify/-/universalify-1.0.0.tgz
https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz
https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz
https://registry.npmjs.org/upath/-/upath-2.0.1.tgz
https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.0.tgz
https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz
https://registry.npmjs.org/url/-/url-0.11.4.tgz
https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz
https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.1.tgz
https://registry.npmjs.org/uuid/-/uuid-3.4.0.tgz
https://registry.npmjs.org/uuid/-/uuid-9.0.1.tgz
https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz
https://registry.npmjs.org/validate-npm-package-name/-/validate-npm-package-name-5.0.1.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz
https://registry.npmjs.org/vfile-location/-/vfile-location-5.0.3.tgz
https://registry.npmjs.org/vfile-message/-/vfile-message-4.0.2.tgz
https://registry.npmjs.org/vfile-reporter/-/vfile-reporter-8.1.1.tgz
https://registry.npmjs.org/vfile-sort/-/vfile-sort-4.0.0.tgz
https://registry.npmjs.org/vfile-statistics/-/vfile-statistics-3.0.0.tgz
https://registry.npmjs.org/vfile/-/vfile-6.0.2.tgz
https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-8.1.0.tgz
https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.3.tgz
https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.8.tgz
https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.2.tgz
https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.3.tgz
https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-8.1.0.tgz
https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.1.0.tgz
https://registry.npmjs.org/walk-sync/-/walk-sync-0.3.4.tgz
https://registry.npmjs.org/walk-up-path/-/walk-up-path-3.0.1.tgz
https://registry.npmjs.org/watchpack/-/watchpack-2.4.2.tgz
https://registry.npmjs.org/wcwidth/-/wcwidth-1.0.1.tgz
https://registry.npmjs.org/web-namespaces/-/web-namespaces-2.0.1.tgz
https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz
https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.4.tgz
https://registry.npmjs.org/webpack-merge/-/webpack-merge-5.10.0.tgz
https://registry.npmjs.org/webpack-sources/-/webpack-sources-3.2.3.tgz
https://registry.npmjs.org/webpack/-/webpack-5.95.0.tgz
https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz
https://registry.npmjs.org/which-boxed-primitive/-/which-boxed-primitive-1.1.1.tgz
https://registry.npmjs.org/which-builtin-type/-/which-builtin-type-1.2.1.tgz
https://registry.npmjs.org/which-collection/-/which-collection-1.0.2.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.15.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.19.tgz
https://registry.npmjs.org/which-typed-array/-/which-typed-array-1.1.9.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz
https://registry.npmjs.org/which/-/which-4.0.0.tgz
https://registry.npmjs.org/which/-/which-5.0.0.tgz
https://registry.npmjs.org/wide-align/-/wide-align-1.1.5.tgz
https://registry.npmjs.org/wildcard/-/wildcard-2.0.1.tgz
https://registry.npmjs.org/winreg/-/winreg-1.2.4.tgz
https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz
https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.3.tgz
https://registry.npmjs.org/workerpool/-/workerpool-6.5.1.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-6.2.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz
https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-9.0.0.tgz
https://registry.npmjs.org/wrapper-webpack-plugin/-/wrapper-webpack-plugin-2.2.2.tgz
https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz
https://registry.npmjs.org/ws/-/ws-7.5.10.tgz
https://registry.npmjs.org/xdg-basedir/-/xdg-basedir-4.0.0.tgz
https://registry.npmjs.org/xml/-/xml-1.0.1.tgz
https://registry.npmjs.org/xml2js/-/xml2js-0.5.0.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-11.0.1.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-15.1.1.tgz
https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-4.2.1.tgz
https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz
https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz
https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz
https://registry.npmjs.org/yallist/-/yallist-5.0.0.tgz
https://registry.npmjs.org/yaml/-/yaml-2.8.0.tgz
https://registry.npmjs.org/yamux-js/-/yamux-js-0.1.2.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-20.2.9.tgz
https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz
https://registry.npmjs.org/yargs-unparser/-/yargs-unparser-2.0.0.tgz
https://registry.npmjs.org/yargs/-/yargs-16.2.0.tgz
https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz
https://registry.npmjs.org/yn/-/yn-2.0.0.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz
https://registry.npmjs.org/zwitch/-/zwitch-2.0.2.tgz
"

CHROMIUM_P="chromium-${CHROMIUM_VERSION}"
NODE_P="node-${NODE_VERSION}"
PATCH_V="${CHROMIUM_VERSION%%\.*}"
PATCHSET_NAME="chromium-patches-${PATCH_V}"
PPC64_HASH="a85b64f07b489b8c6fdb13ecf79c16c56c560fc6"
COPIUM_COMMIT="46d68912da04d9ed14856c50db986d5c8e786a4b"
PATCHSET_LOONG_PV="134.0.6998.39"
PATCHSET_LOONG="chromium-${PATCHSET_LOONG_PV}-1"

#Official tarball: https://commondatastorage.googleapis.com/chromium-browser-official/${CHROMIUM_P}.tar.xz
#Downstream tarball : https://github.com/chromium-linux-tarballs/chromium-tarballs/releases/download/${CHROMIUM_VERSION}/chromium-${CHROMIUM_VERSION}-linux.tar.xz
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/${CHROMIUM_P}.tar.xz
	https://gitlab.com/Matt.Jolly/chromium-patches/-/archive/${PATCH_V}/${PATCHSET_NAME}.tar.bz2
	https://codeberg.org/selfisekai/copium/archive/${COPIUM_COMMIT}.tar.gz
			-> chromium-patches-copium-${COPIUM_COMMIT:0:10}.tar.gz
	https://github.com/electron/electron/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/nodejs/node/archive/v${NODE_VERSION}.tar.gz -> electron-${NODE_P}.tar.gz
	loong? (
		https://github.com/AOSC-Dev/chromium-loongarch64/archive/refs/tags/${PATCHSET_LOONG}.tar.gz -> chromium-loongarch64-aosc-patches-${PATCHSET_LOONG}.tar.gz
	)
	ppc64? (
		https://gitlab.raptorengineering.com/raptor-engineering-public/chromium/openpower-patches/-/archive/${PPC64_HASH}/openpower-patches-${PPC64_HASH}.tar.bz2 -> chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	)
	https://codeload.github.com/nodejs/nan/tar.gz/e14bdcd1f72d62bca1d541b66da43130384ec213
	${YARNPKGS}
"

S="${WORKDIR}/${CHROMIUM_P}"
NODE_S="${S}/third_party/electron_node"

LICENSE="BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Base64 Boost-1.0 CC-BY-3.0 CC-BY-4.0 Clear-BSD"
LICENSE+=" FFT2D FTL IJG ISC LGPL-2 LGPL-2.1 libpng libpng2 MIT MPL-1.1 MPL-2.0 Ms-PL openssl PSF-2"
LICENSE+=" SGI-B-2.0 SSLeay SunSoft Unicode-3.0 Unicode-DFS-2015 Unlicense UoI-NCSA X11-Lucent"
SLOT="${PV%%[.+]*}"
KEYWORDS="~amd64 ~arm64 ~loong"
IUSE_SYSTEM_LIBS="+system-harfbuzz +system-icu +system-png"
IUSE="hevc +X custom-cflags ${IUSE_SYSTEM_LIBS} bindist cups debug ffmpeg-chromium headless kerberos +official pax-kernel pgo +proprietary-codecs pulseaudio"
IUSE+=" +screencast selinux +vaapi +wayland cpu_flags_ppc_vsx3"
RESTRICT="
	!bindist? ( bindist )
	test
"

REQUIRED_USE="
	!headless? ( || ( X wayland ) )
	screencast? ( wayland )
	ffmpeg-chromium? ( bindist proprietary-codecs )
	hevc? ( official vaapi proprietary-codecs )
"

COMMON_X_DEPEND="
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXtst:=
	x11-libs/libxshmfence:=
"

# sys-libs/zlib: https://bugs.gentoo.org/930365; -ng is not compatible.
COMMON_SNAPSHOT_DEPEND="
	system-icu? ( >=dev-libs/icu-73.0:= )
	>=dev-libs/libxml2-2.12.4:=[icu]
	dev-libs/nspr:=
	>=dev-libs/nss-3.26:=
	dev-libs/libxslt:=
	media-libs/fontconfig:=
	>=media-libs/freetype-2.11.0-r1:=
	system-harfbuzz? ( >=media-libs/harfbuzz-3:0=[icu(-)] )
	media-libs/libjpeg-turbo:=
	system-png? ( media-libs/libpng:=[-apng(-)] )
	>=media-libs/libwebp-0.4.0:=
	media-libs/mesa:=[gbm(+)]
	>=media-libs/openh264-1.6.0:=
	sys-libs/zlib:=
	!headless? (
		dev-libs/glib:2
		>=media-libs/alsa-lib-1.0.19:=
		pulseaudio? ( media-libs/libpulse:= )
		sys-apps/pciutils:=
		kerberos? ( virtual/krb5 )
		vaapi? ( >=media-libs/libva-2.7:=[X?,wayland?] )
		X? (
			x11-base/xorg-proto:=
			x11-libs/libX11:=
			x11-libs/libxcb:=
			x11-libs/libXext:=
		)
		x11-libs/libxkbcommon:=
		wayland? (
			dev-libs/libffi:=
			dev-libs/wayland:=
			screencast? ( media-video/pipewire:= )
		)
	)
"

COMMON_DEPEND="
	${COMMON_SNAPSHOT_DEPEND}
	app-arch/bzip2:=
	dev-libs/expat:=
	net-misc/curl[ssl]
	sys-apps/dbus:=
	media-libs/flac:=
	sys-libs/zlib:=[minizip]
	!headless? (
		>=app-accessibility/at-spi2-core-2.46.0:2
		media-libs/mesa:=[X?,wayland?]
		virtual/udev
		x11-libs/cairo:=
		x11-libs/gdk-pixbuf:2
		x11-libs/pango:=
		cups? ( >=net-print/cups-1.3.11:= )
		X? ( ${COMMON_X_DEPEND} )
	)
	elibc_musl? (
		sys-libs/musl-legacy-compat
		sys-libs/libexecinfo
		sys-libs/libucontext
	)
	x11-libs/libnotify:=
	>=app-arch/brotli-1.0.9:=
	>=net-dns/c-ares-1.19.0:=
	>=net-libs/nghttp2-1.51.0:=
	dev-libs/libevent:=
	>=dev-libs/openssl-1.1.1:0=
"
RDEPEND="${COMMON_DEPEND}
	!headless? ( x11-libs/gtk+:3[X,wayland?] )
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	bindist? (
		!ffmpeg-chromium? ( >=media-video/ffmpeg-6.1-r1:0/58.60.60[chromium] )
		ffmpeg-chromium? ( media-video/ffmpeg-chromium:${CHROMIUM_VERSION%%\.*} )
	)
"
DEPEND="${COMMON_DEPEND}
	!headless? ( x11-libs/gtk+:3[X,wayland?] )
"

BDEPEND="
	${COMMON_SNAPSHOT_DEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	>=app-arch/gzip-1.7
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/llvm:${LLVM_SLOT}
		llvm-core/lld:${LLVM_SLOT}
		official? (
			!ppc64? ( llvm-runtimes/compiler-rt-sanitizers:${LLVM_SLOT}[cfi] )
		)
	')
	>=dev-util/bindgen-0.68.0
	>=dev-build/gn-${GN_MIN_VER}
	app-alternatives/ninja
	dev-lang/perl
	>=dev-util/gperf-3.2
	dev-vcs/git
	>=net-libs/nodejs-22.13.0[inspector]
	sys-apps/hwdata
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
	app-misc/jq
"

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

python_check_deps() {
	python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pre_build_checks() {
	if use elibc_musl && has_version "<sys-libs/musl-1.2.4" ; then
		local patched
		if command -v llvm-objdump > /dev/null 2>&1; then
			patched=$(llvm-objdump --disassemble-symbols=pthread_atfork ${EPREFIX}/usr/lib/libc.so 2>&1 | grep __libc_malloc)
		else
			patched=$(objdump --disassemble=pthread_atfork ${EPREFIX}/usr/lib/libc.so 2>&1 | grep __libc_malloc)
		fi
		if [[ -z "$patched" ]]; then
			eerror "You need patch musl libc to use chromium's PartitionAlloc. You can choose:"
			eerror "(1) Upgrade to sys-libs/musl-1.2.4"
			eerror "(2) Install musl from this overlay: emerge sys-libs/musl::12101111-overlay"
			eerror "(3) Patch musl yourself. Copy the patch file to /etc/portage/patches/sys-libs/musl/"
			eerror "Patch file is at <This overlay>/sys-libs/musl/files/fix-pamalloc.patch"
			eerror "Otherwise the build will deadlock and hang."
			die "chromium's PartitionAlloc can't work with unpatched musl!"
		fi
	fi

	# Check build requirements: bugs #471810, #541816, #914220
	# We're going to start doing maths here on the size of an unpacked source tarball,
	# this should make updates easier as chromium continues to balloon in size.
	# xz -l /var/cache/distfiles/chromium-${PV}*.tar.xz
	local base_disk=9 # Round up
	local extra_disk=1 # Always include a little extra space
	local memory=4
	tc-is-cross-compiler && extra_disk=$((extra_disk * 2))
	if tc-is-lto || use pgo; then
		memory=$((memory * 2 + 1))
		tc-is-cross-compiler && extra_disk=$((extra_disk * 2)) # Double the requirements
		use pgo && extra_disk=$((extra_disk + 4))
	fi
	if is-flagq '-g?(gdb)?([1-9])'; then
		if use custom-cflags; then
			extra_disk=$((extra_disk + 5))
		fi
		memory=$((memory * 2))
	fi
	local CHECKREQS_MEMORY="${memory}G"
	local CHECKREQS_DISK_BUILD="$((base_disk + extra_disk))G"
	check-reqs_${EBUILD_PHASE_FUNC}
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# The pre_build_checks are all about compilation resources, no need to run it for a binpkg
		pre_build_checks
	fi

	if use headless; then
		ewarn Headless electron is untested!
		local headless_unused_flags=("cups" "kerberos" "pulseaudio" "vaapi" "wayland")
		for myiuse in ${headless_unused_flags[@]}; do
			use ${myiuse} && ewarn "Ignoring USE=${myiuse}, USE=headless is set."
		done
	fi

	if ! use bindist && use ffmpeg-chromium; then
		ewarn "Ignoring USE=ffmpeg-chromium, USE=bindist is not set."
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# The pre_build_checks are all about compilation resources, no need to run it for a binpkg
		pre_build_checks

		# The linux:unbundle toolchain in GN grabs CC, CXX, CPP (etc) from the environment
		# We'll set these to clang here then use llvm-utils functions to very explicitly set these
		# to a sane value.
		# This is effectively the 'force-clang' path if GCC support is re-added.
		# TODO: check if the user has already selected a specific impl via make.conf and respect that.
		use_lto="false"
		if tc-is-lto; then
			use_lto="true"
			# We can rely on GN to do this for us; anecdotally without this builds
			# take significantly longer with LTO enabled and it doesn't hurt anything.
			filter-lto
		fi

		if [ "$use_lto" = "false" ] && use official; then
			einfo "USE=official selected and LTO not detected."
			einfo "It is _highly_ recommended that LTO be enabled for performance reasons"
			einfo "and to be consistent with the upstream \"official\" build optimisations."
		fi

		export use_lto

		# 936858
		if tc-ld-is-mold; then
			eerror "Your toolchain is using the mold linker."
			eerror "This is not supported by Chromium."
			die "Please switch to a different linker."
		fi

		llvm-r1_pkg_setup
		rust_pkg_setup

		# Forcing clang; respect llvm_slot_x to enable selection of impl from LLVM_COMPAT
		AR=llvm-ar
		CPP="${CHOST}-clang++-${LLVM_SLOT} -E"
		NM=llvm-nm
		CC="${CHOST}-clang-${LLVM_SLOT}"
		CXX="${CHOST}-clang++-${LLVM_SLOT}"

		if tc-is-cross-compiler; then
			use pgo && die "The pgo USE flag cannot be used when cross-compiling"
			CPP="${CBUILD}-clang++-${LLVM_SLOT} -E"
		fi

		einfo "Using LLVM/Clang slot ${LLVM_SLOT} to build"
		einfo "Using Rust slot ${RUST_SLOT}, ${RUST_TYPE} to build"

		# I hate doing this but upstream Rust have yet to come up with a better solution for
		# us poor packagers. Required for Split LTO units, which are required for CFI.
		export RUSTC_BOOTSTRAP=1

		# Users should never hit this, it's purely a development convenience
		if ver_test $(gn --version || die) -lt ${GN_MIN_VER}; then
			die "dev-build/gn >= ${GN_MIN_VER} is required to build this Chromium"
		fi
	fi

	chromium_suid_sandbox_check_kernel_config
}

_get_install_suffix() {
	local c=(${SLOT//\// })
	local slot=${c[0]}
	local suffix

	if [[ "${slot}" == "0" ]]; then
		suffix=""
	else
		suffix="-${slot}"
	fi

	echo -n "${suffix}"
}

_get_install_dir() {
	echo -n "/usr/$(get_libdir)/electron$(_get_install_suffix)"
}

src_unpack() {
	unpack chromium-${CHROMIUM_VERSION}.tar.xz
	unpack ${P}.tar.gz
	unpack "electron-${NODE_P}.tar.gz"
	unpack "${PATCHSET_NAME}.tar.bz2"
	unpack chromium-patches-copium-${COPIUM_COMMIT:0:10}.tar.gz
	if use ppc64; then
		unpack chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	fi
	use loong && unpack "chromium-loongarch64-aosc-patches-${PATCHSET_LOONG}.tar.gz"
}

remove_compiler_builtins() {
	# We can't use the bundled compiler builtins with the system toolchain
	# We used to `grep` then `sed`, but it was indirect. Combining the two into a single
	# `awk` command is more efficient and lets us document the logic more clearly.

	local pattern='    configs += [ "//build/config/clang:compiler_builtins" ]'
	local target='build/config/compiler/BUILD.gn'

	local tmpfile
	tmpfile=$(mktemp) || die "Failed to create temporary file."

	if awk -v pat="${pattern}" '
	BEGIN {
		match_found = 0
	}

	# If the delete countdown is active, decrement it and skip to the next line.
	d > 0 { d--; next }

	# If the current line matches the pattern...
	$0 == pat {
		match_found = 1   # ...set our flag to true.
		d = 2             # Set delete counter for this line and the next two.
		prev = ""         # Clear the buffered previous line so it is not printed.
		next
	}

	# For any other line, print the buffered previous line.
	NR > 1 { print prev }

	# Buffer the current line to be printed on the next cycle.
	{ prev = $0 }

	END {
		# Print the last line if it was not part of a deleted block.
		if (d == 0) { print prev }

		# If the pattern was never found, exit with a failure code.
		if (match_found == 0) {
		exit 1
		}
	}
	' "${target}" > "${tmpfile}"; then
		# AWK SUCCEEDED (exit code 0): The pattern was found and edited.
		# This is to avoid gawk's `-i inplace` option which users complain about.
		mv "${tmpfile}" "${target}"
	else
		# AWK FAILED (exit code 1): The pattern was not found.
		rm -f "${tmpfile}"
		die "Awk patch failed: Pattern not found in ${target}."
	fi
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Electron's scripts expect the top dir to be called src/"
	ln -s "${S}" "${WORKDIR}/src" || die
	mv "${WORKDIR}/${NODE_P}/" "${NODE_S}/" || die
	mv "${WORKDIR}/${P}" "${S}/electron" || die

	eapply "${FILESDIR}/${SLOT}/chromium/"

	if use elibc_musl; then
		eapply "${FILESDIR}/${SLOT}/musl"
		echo "$(rust_abi)" >> build/rust/known-target-triples.txt
	fi

	if tc-is-clang && ( has_version "llvm-core/clang-common[default-compiler-rt]" || is-flagq -rtlib=compiler-rt ); then
		eapply "${FILESDIR}/${SLOT}/remove-libatomic.patch"
	fi

	# https://issues.chromium.org/issues/442698344
	# Unreleased fontconfig changed magic numbers and google have rolled to this version
	if has_version "<=media-libs/fontconfig-2.17.1"; then
		PATCHES+=( "${FILESDIR}/${SLOT}/chromium-142-work-with-old-fontconfig.patch" )
	fi

	shopt -s globstar nullglob
	# 130: moved the PPC64 patches into the chromium-patches repo
	local patch
	for patch in "${WORKDIR}/chromium-patches-${PATCH_V}"/**/*.patch; do
			if [[ ${patch} == *"ppc64le"* ]]; then
					use ppc64 && eapply "${patch}"
			else
					eapply "${patch}"
			fi
	done
	shopt -u globstar nullglob
	remove_compiler_builtins

		# Strictly speaking this doesn't need to be gated (no bundled toolchain for ppc64); it keeps the logic together
	if use ppc64; then
		local patchset_dir="${WORKDIR}/openpower-patches-${PPC64_HASH}/patches"
		# patch causes build errors on 4K page systems (https://bugs.gentoo.org/show_bug.cgi?id=940304)
		local page_size_patch="ppc64le/third_party/use-sysconf-page-size-on-ppc64.patch"
		local isa_3_patch="ppc64le/core/baseline-isa-3-0.patch"
		# Apply the OpenPOWER patches (check for page size and isa 3.0)
		openpower_patches=( $(grep -E "^ppc64le|^upstream" "${patchset_dir}/series" | grep -v "${page_size_patch}" |
			grep -v "${isa_3_patch}" || die) )
		for patch in "${openpower_patches[@]}"; do
			PATCHES+=( "${patchset_dir}/${patch}" )
		done
		if [[ $(getconf PAGESIZE) == 65536 ]]; then
			PATCHES+=( "${patchset_dir}/${page_size_patch}" )
		fi
		# We use vsx3 as a proxy for 'want isa3.0' (POWER9)
		if use cpu_flags_ppc_vsx3 ; then
			PATCHES+=( "${patchset_dir}/${isa_3_patch}" )
		fi
	fi

	cd "${S}/electron" || die
	cat >> "${S}/electron/.yarnrc.yml" << EOF
enableColors: false
enableImmutableCache: true
enableImmutableInstalls: true
enableInlineBuilds: true
enableNetwork: false
enableOfflineMode: true
enableProgressBars: false
enableTelemetry: false
enableScripts: false
enableGlobalCache: false
checksumBehavior: ignore
EOF
	echo "cacheFolder: \"${WORKDIR}/cache\"" >> "${S}/electron/.yarnrc.yml"

	# Apply Gentoo patches for Electron itself.
	eapply "${FILESDIR}/${SLOT}/electron/"
	use elibc_musl && eapply "${FILESDIR}/${SLOT}/electron-musl-stack-size.patch"

	# Apply Chromium patches from Electron.
	local patchespath repopath
	(jq -r '.[] | .patch_dir + " " + .repo' "${S}/electron/patches/config.json" || die) \
	| while read -r patchespath repopath; do
		if [[ -d "${WORKDIR}/${repopath}" ]]; then
			einfo "Apply Electron's patches to ${repopath}"
			cd "${WORKDIR}/${repopath}" || die
			cat "${WORKDIR}/${patchespath}/.patches" | while read -r patchfile; do
				eapply "${WORKDIR}/${patchespath}/${patchfile}"
			done
		else
			einfo "Skip patches for ${repopath}"
		fi
	done

	cd "${S}" || die
	eapply "${FILESDIR}/${SLOT}/fix-system-libs.patch"

	if ver_test ${RUST_SLOT} -lt "1.89.0"; then
			eapply "${FILESDIR}/${SLOT}"/chromium-140-__rust_no_alloc_shim_is_unstable.patch
	fi
	if ver_test ${RUST_SLOT} -lt "1.90.0"; then
			eapply "${WORKDIR}/copium/cr142-rust-pre1.90.patch"
	fi
	if ver_test ${RUST_SLOT} -lt "1.91.0"; then
			eapply "${WORKDIR}/copium/cr142-crabbyavif-gn-rust-pre1.91.patch"
			eapply "${WORKDIR}/copium/cr142-crabbyavif-src-rust-pre1.91.patch"
	fi

	if use loong ; then
		local p
		local other_patches_to_apply=(
			Debian-fixes-blink
			Debian-fixes-blink-frags
			fix-clang-builtins-path
			fix-missing-header
			fix-static-assertion
		)
		for p in "${other_patches_to_apply[@]}"; do
			eapply "${WORKDIR}/chromium-loongarch64-${PATCHSET_LOONG}/chromium/chromium-${PATCHSET_LOONG_PV}".????-"${p}".diff
		done
		if ! tc-is-clang || ver_test "$(clang-major-version)" -gt 17; then
			rm "${WORKDIR}/chromium-loongarch64-${PATCHSET_LOONG}/chromium/chromium-${PATCHSET_LOONG_PV}".4000-loongarch64-clang-no-lsx.diff
		fi
		for p in "${WORKDIR}/chromium-loongarch64-${PATCHSET_LOONG}/chromium/chromium-${PATCHSET_LOONG_PV}".????-loongarch64*; do
			eapply "${p}"
		done
		eapply "${FILESDIR}/${SLOT}/chromium-123-gentoo-loong.patch"
	fi

	cd "${S}/electron" || die
	# ignore dugite, which download a git binary!
	export YARN_ENABLE_OFFLINE_MODE=1
        mkdir "${WORKDIR}/cache" || die
        "${EPYTHON}" "${FILESDIR}/install.py" "${S}/electron/yarn.lock" "${DISTDIR}" "${WORKDIR}/cache" || die
        node ./script/yarn.js install --mode skip-build --immutable --immutable-cache || die

	cd "${S}" || die

	default

	# Not included in -lite tarballs, but we should check for it anyway.
	if [[ -f third_party/node/linux/node-linux-x64/bin/node ]]; then
		rm third_party/node/linux/node-linux-x64/bin/node || die
	else
		mkdir -p third_party/node/linux/node-linux-x64/bin || die
	fi
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die

	# adjust python interpreter version
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die

	# Use the system copy of hwdata's usb.ids; upstream is woefully out of date (2015!)
	sed 's|//third_party/usb_ids/usb.ids|/usr/share/hwdata/usb.ids|g' \
		-i services/device/public/cpp/usb/BUILD.gn || die "Failed to set system usb.ids path"

	# remove_bundled_libraries.py walks the source tree and looks for paths containing the substring 'third_party'
	# whitelist matches use the right-most matching path component, so we need to whitelist from that point down.
	local keeplibs=(
		third_party/electron_node
		base/third_party/cityhash
		base/third_party/double_conversion
		base/third_party/icu
		base/third_party/nspr
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/xdg_user_dirs
		buildtools/third_party/libc++
		buildtools/third_party/libc++abi
		net/third_party/mozilla_security_manager
		net/third_party/quic
		net/third_party/uri_template
		third_party/abseil-cpp
		third_party/angle
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/ceval
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/volk
		third_party/anonymous_tokens
		third_party/apple_apsl
		third_party/axe-core
		third_party/bidimapper
		third_party/blink
		third_party/boringssl
		third_party/boringssl/src/third_party/fiat
		third_party/breakpad
		third_party/breakpad/breakpad/src/third_party/curl
		third_party/brotli
		third_party/catapult
		third_party/catapult/common/py_vulcanize/third_party/rcssmin
		third_party/catapult/common/py_vulcanize/third_party/rjsmin
		third_party/catapult/third_party/beautifulsoup4-4.9.3
		third_party/catapult/third_party/html5lib-1.1
		third_party/catapult/third_party/polymer
		third_party/catapult/third_party/six
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jpeg-js
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/catapult/tracing/third_party/oboe
		third_party/catapult/tracing/third_party/pako
		third_party/ced
		third_party/cld_3
		third_party/closure_compiler
		third_party/compiler-rt # Since M137 atomic is required; we could probably unbundle this as a target of opportunity.
		third_party/content_analysis_sdk
		third_party/cpuinfo
		third_party/crabbyavif
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/d3
		third_party/dav1d
		third_party/dawn
		third_party/dawn/third_party/gn/webgpu-cts
		third_party/dawn/third_party/khronos
		third_party/depot_tools
		third_party/devscripts
		third_party/devtools-frontend
		third_party/devtools-frontend/src/front_end/third_party/acorn
		third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json
		third_party/devtools-frontend/src/front_end/third_party/axe-core
		third_party/devtools-frontend/src/front_end/third_party/chromium
		third_party/devtools-frontend/src/front_end/third_party/codemirror
		third_party/devtools-frontend/src/front_end/third_party/csp_evaluator
		third_party/devtools-frontend/src/front_end/third_party/diff
		third_party/devtools-frontend/src/front_end/third_party/i18n
		third_party/devtools-frontend/src/front_end/third_party/intl-messageformat
		third_party/devtools-frontend/src/front_end/third_party/json5
		third_party/devtools-frontend/src/front_end/third_party/legacy-javascript
		third_party/devtools-frontend/src/front_end/third_party/lighthouse
		third_party/devtools-frontend/src/front_end/third_party/lit
		third_party/devtools-frontend/src/front_end/third_party/marked
		third_party/devtools-frontend/src/front_end/third_party/puppeteer
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/mitt
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/parsel-js
		third_party/devtools-frontend/src/front_end/third_party/puppeteer/package/lib/esm/third_party/rxjs
		third_party/devtools-frontend/src/front_end/third_party/source-map-scopes-codec
		third_party/devtools-frontend/src/front_end/third_party/third-party-web
		third_party/devtools-frontend/src/front_end/third_party/vscode.web-custom-data
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/front_end/third_party/web-vitals
		third_party/devtools-frontend/src/third_party
		third_party/dom_distiller_js
		third_party/dragonbox
		third_party/eigen3
		third_party/emoji-segmenter
		third_party/farmhash
		third_party/fast_float
		third_party/fdlibm
		third_party/federated_compute/chromium/fcp/confidentialcompute
		third_party/federated_compute/src/fcp/base
		third_party/federated_compute/src/fcp/confidentialcompute
		third_party/federated_compute/src/fcp/protos/confidentialcompute
		third_party/federated_compute/src/fcp/protos/federatedcompute
		third_party/ffmpeg
		third_party/fft2d
		third_party/flatbuffers
		third_party/fp16
		third_party/freetype
		third_party/fusejs
		third_party/fxdiv
		third_party/gemmlowp
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/highway
		third_party/hunspell
		third_party/ink_stroke_modeler/src/ink_stroke_modeler
		third_party/ink_stroke_modeler/src/ink_stroke_modeler/internal
		third_party/ink/src/ink/brush
		third_party/ink/src/ink/color
		third_party/ink/src/ink/geometry
		third_party/ink/src/ink/rendering
		third_party/ink/src/ink/rendering/skia/common_internal
		third_party/ink/src/ink/rendering/skia/native
		third_party/ink/src/ink/rendering/skia/native/internal
		third_party/ink/src/ink/strokes
		third_party/ink/src/ink/types
		third_party/inspector_protocol
		third_party/ipcz
		third_party/jinja2
		third_party/jsoncpp
		third_party/khronos
		third_party/lens_server_proto
		third_party/leveldatabase
		third_party/libaddressinput
		third_party/libaom
		third_party/libaom/source/libaom/third_party/fastfeat
		third_party/libaom/source/libaom/third_party/SVT-AV1
		third_party/libaom/source/libaom/third_party/vector
		third_party/libaom/source/libaom/third_party/x86inc
		third_party/libc++
		third_party/libdrm
		third_party/libgav1
		third_party/libjingle
		third_party/libpfm4
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/libtess2/libtess2
		third_party/libtess2/src/Include
		third_party/libtess2/src/Source
		third_party/liburlpattern
		third_party/libva_protected_content
		third_party/libvpx
		third_party/libvpx/source/libvpx/third_party/x86inc
		third_party/libwebm
		third_party/libx11
		third_party/libxcb-keysyms
		third_party/libxml/chromium
		third_party/libyuv
		third_party/libzip
		third_party/lit
		third_party/llvm-libc
		third_party/llvm-libc/src/shared/
		third_party/lottie
		third_party/lss
		third_party/lzma_sdk
		third_party/mako
		third_party/markupsafe
		third_party/material_color_utilities
		third_party/metrics_proto
		third_party/minigbm
		third_party/ml_dtypes
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
		third_party/oak/chromium/proto
		third_party/oak/chromium/proto/attestation
		third_party/omnibox_proto
		third_party/one_euro_filter
		third_party/openscreen
		third_party/openscreen/src/third_party/
		third_party/openscreen/src/third_party/tinycbor/src/src
		third_party/opus
		third_party/ots
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
		third_party/pdfium/third_party/libopenjpeg
		third_party/pdfium/third_party/libtiff
		third_party/perfetto
		third_party/perfetto/protos/third_party/chromium
		third_party/perfetto/protos/third_party/simpleperf
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private_membership
		third_party/private-join-and-compute
		third_party/protobuf
		third_party/protobuf/third_party/utf8_range
		third_party/pthreadpool
		third_party/puffin
		third_party/pyjson5
		third_party/pyyaml
		third_party/rapidhash
		third_party/re2
		third_party/readability
		third_party/rnnoise
		third_party/rust
		third_party/ruy
		third_party/s2cellid
		third_party/search_engines_data
		third_party/securemessage
		third_party/selenium-atoms
		third_party/sentencepiece
		third_party/sentencepiece/src/third_party/darts_clone
		third_party/shell-encryption
		third_party/simdutf
		third_party/simplejson
		third_party/six
		third_party/skia
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/snappy
		third_party/spirv-headers
		third_party/spirv-tools
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/astc-encoder
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/marl
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv
		third_party/swiftshader/third_party/SPIRV-Tools
		third_party/swiftshader/third_party/subzero
		third_party/tensorflow_models
		third_party/tensorflow-text
		third_party/tflite
		third_party/tflite/src/third_party/fft2d
		third_party/tflite/src/third_party/xla/third_party/tsl
		third_party/tflite/src/third_party/xla/xla/tsl/framework
		third_party/tflite/src/third_party/xla/xla/tsl/lib/random
		third_party/tflite/src/third_party/xla/xla/tsl/platform
		third_party/tflite/src/third_party/xla/xla/tsl/protobuf
		third_party/tflite/src/third_party/xla/xla/tsl/util
		third_party/ukey2
		third_party/utf
		third_party/vulkan
		third_party/wayland
		third_party/webdriver
		third_party/webgpu-cts
		third_party/webrtc
		third_party/webrtc/common_audio/third_party/ooura
		third_party/webrtc/common_audio/third_party/spl_sqrt_floor
		third_party/webrtc/modules/third_party/fft
		third_party/webrtc/modules/third_party/g711
		third_party/webrtc/modules/third_party/g722
		third_party/webrtc/rtc_base/third_party/sigslot
		third_party/widevine
		third_party/woff2
		third_party/wuffs
		third_party/x11proto
		third_party/xcbproto
		third_party/xnnpack
		third_party/zlib/google
		third_party/zxcvbn-cpp
		url/third_party/mozilla
		v8/third_party/glibc
		v8/third_party/inspector_protocol
		v8/third_party/rapidhash-v8
		v8/third_party/siphash
		v8/third_party/utf8-decoder
		v8/third_party/v8
		v8/third_party/valgrind

		# gyp -> gn leftovers
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils
	)

	# USE=system-*
	if ! use system-harfbuzz; then
		keeplibs+=( third_party/harfbuzz-ng )
	fi

	if ! use system-icu; then
		keeplibs+=( third_party/icu )
	fi

	if ! use system-png; then
		keeplibs+=( third_party/libpng )
	fi

	#if ! use system-zstd; then
	keeplibs+=( third_party/zstd )
	#fi

	# Arch-specific
	if use arm64 || use ppc64 ; then
		keeplibs+=( third_party/swiftshader/third_party/llvm-10.0 )
	fi
	if use loong ; then
		keeplibs+=( third_party/swiftshader/third_party/llvm-16.0 )
	fi
	# we need to generate ppc64 stuff because upstream does not ship it yet
	# it has to be done before unbundling.
	if use ppc64; then
		pushd third_party/libvpx >/dev/null || die
		mkdir -p source/config/linux/ppc64 || die
		# requires git and clang, bug #832803
		# Revert https://chromium.googlesource.com/chromium/src/+/b463d0f40b08b4e896e7f458d89ae58ce2a27165%5E%21/third_party/libvpx/generate_gni.sh
		# and https://chromium.googlesource.com/chromium/src/+/71ebcbce867dd31da5f8b405a28fcb0de0657d91%5E%21/third_party/libvpx/generate_gni.sh
		# since we're not in a git repo
		sed -i -e "s|^update_readme||g; s|clang-format|${EPREFIX}/bin/true|g; /^git -C/d; /git cl/d; /cd \$BASE_DIR\/\$LIBVPX_SRC_DIR/ign format --in-place \$BASE_DIR\/BUILD.gn\ngn format --in-place \$BASE_DIR\/libvpx_srcs.gni" \
			generate_gni.sh || die
		./generate_gni.sh || die
		popd >/dev/null || die

		pushd third_party/ffmpeg >/dev/null || die
		cp libavcodec/ppc/h264dsp.c libavcodec/ppc/h264dsp_ppc.c || die
		cp libavcodec/ppc/h264qpel.c libavcodec/ppc/h264qpel_ppc.c || die
		popd >/dev/null || die
	fi

	# Sanity check keeplibs, on major version bumps it is often necessary to update this list
	# and this enables us to hit them all at once.
	# There are some entries that need to be whitelisted (TODO: Why? The file is understandable, the rest seem odd)
	whitelist_libs=(
		net/third_party/quic
		third_party/devtools-frontend/src/front_end/third_party/additional_readme_paths.json
		third_party/libjingle
		third_party/mesa
		third_party/skia/third_party/vulkan
		third_party/vulkan
	)
	local not_found_libs=()
	for lib in "${keeplibs[@]}"; do
		if [[ ! -d "${lib}" ]] && ! has "${lib}" "${whitelist_libs[@]}"; then
			not_found_libs+=( "${lib}" )
		fi
	done

	if [[ ${#not_found_libs[@]} -gt 0 ]]; then
		eerror "The following \`keeplibs\` directories were not found in the source tree:"
		for lib in "${not_found_libs[@]}"; do
			eerror "  ${lib}"
		done
		die "Please update the ebuild."
	fi

	# Remove most bundled libraries. Some are still needed.
	ebegin "Unbundling third-party libraries ..."
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove || die
	eend 0

	# Interferes with our bundled clang path; we don't want stripped binaries anyway.
	sed -i -e 's|${clang_base_path}/bin/llvm-strip|/bin/true|g' \
		-e 's|${clang_base_path}/bin/llvm-objcopy|/bin/true|g' \
		build/linux/strip_binary.gni || die

	if use elibc_musl; then
		config1="./third_party/swiftshader/third_party/llvm-subzero/build/Linux/include/llvm/Config/config.h"
		if [[ -f $config1 ]]; then
			sed -i 's/#define HAVE_BACKTRACE 1/\/* #undef HAVE_BACKTRACE *\//' $config1 || die
			sed -i 's/#define HAVE_EXECINFO_H 1/\/* #undef HAVE_EXECINFO_H *\//' $config1 || die
			sed -i 's/#define HAVE_MALLINFO 1/\/* #undef HAVE_MALLINFO *\//' $config1 || die
		fi
		config2="./third_party/swiftshader/third_party/llvm-10.0/configs/linux/include/llvm/Config/config.h"
		if [[ -f $config2 ]]; then
			sed -i 's/#define HAVE_MALLINFO 1/\/* #undef HAVE_MALLINFO *\//' $config2 || die
		fi
	fi

	# bundled eu-strip is for amd64 only and we don't want to pre-stripped binaries
	mkdir -p buildtools/third_party/eu-strip/bin || die
	ln -s "${EPREFIX}"/bin/true buildtools/third_party/eu-strip/bin/eu-strip || die
}

src_configure() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	# Use system-provided libraries.
	# TODO: freetype -- remove sources (https://bugs.chromium.org/p/pdfium/issues/detail?id=733).
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_protobuf (bug #525560).
	# TODO: use_system_sqlite (http://crbug.com/22208).

	# libevent: https://bugs.gentoo.org/593458
	local gn_system_libraries=(
		flac
		fontconfig
		freetype
		# Need harfbuzz_from_pkgconfig target
		#harfbuzz-ng
		libjpeg
		libwebp
		libxml
		libxslt
		openh264
		zlib
	)
	if use system-icu; then
		gn_system_libraries+=( icu )
	fi
	if use system-png; then
		gn_system_libraries+=( libpng )
	fi
	#if use system-zstd; then
	#	gn_system_libraries+=( zstd )
	#fi

	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" ||
		die "Failed to replace GN files for system libraries"

	# TODO 131: The above call clobbers `enable_freetype = true` in the freetype gni file
	# drop the last line, then append the freetype line and a new curly brace to end the block
	local freetype_gni="build/config/freetype/freetype.gni"
	sed -i -e '$d' ${freetype_gni} || die
	echo "  enable_freetype = true" >> ${freetype_gni} || die
	echo "}" >> ${freetype_gni} || die

	if use !custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags
		# Debug info section overflows without component build
		# Prevent linker from running out of address space, bug #471810 .
		filter-flags "-g*"

		# The linked text section of Chromium won't fit within limits of the
		# default normal code model.
		if [[ ${myarch} == loong ]]; then
			append-flags -mcmodel=medium
		fi
	fi

	# We don't use the same clang version as upstream, and with -Werror
	# we need to make sure that we don't get superfluous warnings.
	append-flags -Wno-unknown-warning-option
	if tc-is-cross-compiler; then # can you cross-compile with the bundled toolchain?
			export BUILD_CXXFLAGS+=" -Wno-unknown-warning-option"
			export BUILD_CFLAGS+=" -Wno-unknown-warning-option"
	fi

	# Start building our GN options
	local myconf_gn=() # Tip: strings must be quoted, bools or numbers are fine

	# We already forced the "correct" clang via pkg_setup
	if tc-is-cross-compiler; then
		CC="${CC} -target ${CHOST} --sysroot ${ESYSROOT}"
		CXX="${CXX} -target ${CHOST} --sysroot ${ESYSROOT}"
		BUILD_AR=${AR}
		BUILD_CC=${CC}
		BUILD_CXX=${CXX}
		BUILD_NM=${NM}
	fi

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM

	strip-unsupported-flags
	append-ldflags -Wl,--undefined-version # https://bugs.gentoo.org/918897#c32

	myconf_gn+=(
		"is_clang=true"
		"clang_use_chrome_plugins=false"
		"use_clang_modules=false" # M141 enables this for the linux platform by default.
		"use_lld=true"
		'custom_toolchain="//build/toolchain/linux/unbundle:default"'
		# From M127 we need to provide a location for libclang.
		# We patch this in for gentoo - see chromium-*-bindgen-custom-toolchain.patch
		# rust_bindgen_root = directory with `bin/bindgen` beneath it.
		# We don't need to set 'clang_base_path' for anything in our build
		# and it defaults to the google toolchain location. Instead provide a location
		# to where system clang lives so that bindgen can find system headers (e.g. stddef.h)
		"bindgen_libclang_path=\"$(get_llvm_prefix)/$(get_libdir)\""
		"clang_base_path=\"${EPREFIX}/usr/lib/clang/${LLVM_SLOT}/\""
		"rust_bindgen_root=\"${EPREFIX}/usr/\""
		"rust_sysroot_absolute=\"$(get_rust_prefix)\""
		"rustc_version=\"${RUST_SLOT}\""
	)
	use elibc_musl && myconf_gn+=( "rust_abi_target=\"$(rust_abi)\"" )

	if ! tc-is-cross-compiler; then
			myconf_gn+=( 'host_toolchain="//build/toolchain/linux/unbundle:default"' )
		else
			tc-export BUILD_{AR,CC,CXX,NM}
			myconf_gn+=(
				'host_toolchain="//build/toolchain/linux/unbundle:host"'
				'v8_snapshot_toolchain="//build/toolchain/linux/unbundle:host"'
				"host_pkg_config=\"$(tc-getBUILD_PKG_CONFIG)\""
				"pkg_config=\"$(tc-getPKG_CONFIG)\""
			)

			# setup cups-config, build system only uses --libs option
			if use cups; then
				mkdir "${T}/cups-config" || die
				cp "${ESYSROOT}/usr/bin/${CHOST}-cups-config" "${T}/cups-config/cups-config" || die
				export PATH="${PATH}:${T}/cups-config"
			fi

			# Don't inherit PKG_CONFIG_PATH from environment
			local -x PKG_CONFIG_PATH=
	fi

	local myarch
	myarch="$(tc-arch)"
	case ${myarch} in
		amd64)
			# Bug 530248, 544702, 546984, 853646.
			use !custom-cflags && filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 \
										-mno-avx -mno-avx2 -mno-fma -mno-fma4 -mno-xop -mno-sse4a
			myconf_gn+=( 'target_cpu="x64"' )
			;;
		arm64)
			myconf_gn+=( 'target_cpu="arm64"' )
			;;
		ppc64)
			myconf_gn+=( 'target_cpu="ppc64"' )
			;;
		loong)
			myconf_gn+=( 'target_cpu="loong64"' )
			;;
		*)
			die "Failed to determine target arch, got '${myarch}'."
			;;
	esac

	# Common options

	myconf_gn+=(
		# Disable code formating of generated files
		"blink_enable_generated_code_formatting=false"
		# enable DCHECK with USE=debug only, increases chrome binary size by 30%, bug #811138.
		# DCHECK is fatal by default, make it configurable at runtime, #bug 807881.
		"dcheck_always_on=$(usex debug true false)"
		"dcheck_is_configurable=$(usex debug true false)"
		# Chromium builds provided by Linux distros should disable the testing config
		"disable_fieldtrial_testing_config=true"
		# 131 began laying the groundwork for replacing freetype with
		# "Rust-based Fontations set of libraries plus Skia path rendering"
		# We now need to opt-in
		"enable_freetype=true"
		"enable_hangout_services_extension=false"
		# Don't need nocompile checks and GN crashes with our config (verify with modern GN)
		"enable_nocompile_tests=false"
		# pseudolocales are only used for testing
		"enable_pseudolocales=false"
		"enable_widevine=false"
		# Disable fatal linker warnings, bug 506268.
		"fatal_linker_warnings=false"
		# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys
		# Note: these are for Gentoo use ONLY. For your own distribution,
		# please get your own set of keys. Feel free to contact chromium@gentoo.org for more info.
		# note: OAuth2 is patched in; check patchset for details.
		'google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"'
		# Component build isn't generally intended for use by end users. It's mostly useful
		# for development and debugging.
		"is_component_build=false"
		# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
		"is_debug=false"
		"is_official_build=$(usex official true false)"
		# Enable ozone wayland and/or headless support
		"ozone_auto_platforms=false"
		"ozone_platform_headless=true"
		# Enables building without non-free unRAR licence
		"safe_browsing_use_unrar=false"
		"thin_lto_enable_optimizations=${use_lto}"
		"treat_warnings_as_errors=false"
		# Use in-tree libc++ (buildtools/third_party/libc++ and buildtools/third_party/libc++abi)
		# instead of the system C++ library for C++ standard library support.
		# default: true, but let's be explicit (forced since 120 ; USE removed 127).
		"use_custom_libcxx=true"
		# Enable ozone wayland and/or headless support
		"use_ozone=true"
		# The sysroot is the oldest debian image that chromium supports, we don't need it
		"use_sysroot=false"
		# See dependency logic in third_party/BUILD.gn
		"use_system_harfbuzz=$(usex system-harfbuzz true false)"
		"use_thin_lto=${use_lto}"
		# Only enabled for clang, but gcc has endian macros too
		"v8_use_libm_trig_functions=true"
	)

	if use bindist ; then
		myconf_gn+=(
			# If this is set to false Chromium won't be able to load any proprietary codecs
			# even if provided with an ffmpeg capable of h264/aac decoding
			"proprietary_codecs=true"
			'ffmpeg_branding="Chrome"'
			# build ffmpeg as an external component (libffmpeg.so) that we can remove / substitute
			"is_component_ffmpeg=true"
		)
	else
		myconf_gn+=(
			"proprietary_codecs=$(usex proprietary-codecs true false)"
			"ffmpeg_branding=\"$(usex proprietary-codecs Chrome Chromium)\""
		)
	fi

	if use hevc; then
		myconf_gn+=(
			"media_use_ffmpeg=true"
			"enable_platform_hevc=true"
			"enable_hevc_parser_and_hw_decoder=true"
		)
	fi

	if use headless; then
		myconf_gn+=(
			"enable_print_preview=false"
			"enable_remoting=false"
			'ozone_platform="headless"'
			"rtc_use_pipewire=false"
			"use_alsa=false"
			"use_cups=false"
			"use_gio=false"
			"use_glib=false"
			"use_gtk=false"
			"use_kerberos=false"
			"use_libpci=false"
			"use_pangocairo=false"
			"use_pulseaudio=false"
			"use_qt5=false"
			"use_qt6=false"
			"use_udev=false"
			"use_vaapi=false"
			"use_xkbcommon=false"
		)
	else
		myconf_gn+=(
			"gtk_version=3"
			# link pulseaudio directly (DT_NEEDED) instead of using dlopen.
			# helps with automated detection of ABI mismatches and prevents silent errors.
			"link_pulseaudio=$(usex pulseaudio true false)"
			"ozone_platform_wayland=$(usex wayland true false)"
			"ozone_platform_x11=$(usex X true false)"
			"ozone_platform=\"$(usex wayland wayland x11)\""
			"rtc_use_pipewire=$(usex screencast true false)"
			"use_cups=$(usex cups true false)"
			"use_kerberos=$(usex kerberos true false)"
			"use_pulseaudio=$(usex pulseaudio true false)"
			"use_qt5=false"
			"use_system_libffi=$(usex wayland true false)"
			"use_system_minigbm=true"
			"use_vaapi=$(usex vaapi true false)"
			"use_xkbcommon=true"
			"use_qt6=false"
		)
	fi

	# Explicitly disable ICU data file support for system-icu/headless builds.
	if use system-icu || use headless; then
		myconf_gn+=( "icu_use_data_file=false" )
	fi

	if use official; then
		# Allow building against system libraries in official builds
		sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py || die
		if use elibc_glibc && (use abi_x86_64 || use arm64); then
			myconf_gn+=( "is_cfi=${use_lto}" )
		else
			myconf_gn+=( "is_cfi=false" ) # requires llvm-runtimes/compiler-rt-sanitizers[cfi]
		fi
		# Don't add symbols to build
		myconf_gn+=( "symbol_level=0" )
	fi

	if use pgo; then
		myconf_gn+=( "chrome_pgo_phase=2" )
	else
		myconf_gn+=( "chrome_pgo_phase=0" )
	fi

	# Odds and ends

	# skipping typecheck is only supported on amd64, bug #876157
	if ! (use amd64 && use elibc_glibc); then
		myconf_gn+=( "devtools_skip_typecheck=false" )
	fi

	# Disable external code space for V8 for ppc64. It is disabled for ppc64
	# by default, but cross-compiling on amd64 enables it again.
	if tc-is-cross-compiler && use ppc64; then
		myconf_gn+=( "v8_enable_external_code_space=false" )
	fi

	# This configutation can generate config.gypi
	einfo "Configuring bundled nodejs..."
	pushd "${NODE_S}" > /dev/null || die
	# --shared-libuv cannot be used as electron's node fork
	# patches uv_loop structure.
	local nodeconf=(
		--shared
		--without-bundled-v8
		--shared-openssl
		--shared-http-parser
		--shared-zlib
		--shared-nghttp2
		--shared-cares
		--without-npm
	)

	use system-icu && nodeconf+=( --with-intl=system-icu ) || nodeconf+=( --with-intl=none )

	local nodearch=""
	case "${ARCH}:${ABI}" in
		*:amd64) nodearch="x64";;
		*:arm) nodearch="arm";;
		*:arm64) nodearch="arm64";;
		loong:lp64*) nodearch="loong64";;
		riscv:lp64*) nodearch="riscv64";;
		*:ppc64) nodearch="ppc64";;
		*:x32) nodearch="x32";;
		*:x86) nodearch="ia32";;
		*) nodearch="${ABI}";;
	esac

	"${EPYTHON}" configure.py \
	--prefix="" \
	--dest-cpu=${nodearch} \
	"${nodeconf[@]}" || die

	popd > /dev/null || die

	myconf_gn+=(
		"use_system_cares=true"
		"use_system_nghttp2=true"
		"override_electron_version=\"${PV}\""
		"import(\"//electron/build/args/release.gn\")"
	)

	einfo "Configuring Electron..."
	set -- gn gen --args="${myconf_gn[*]}${EXTRA_GN:+ ${EXTRA_GN}}" out/Release
	echo "$@"
	"$@" || die
}

src_compile() {
	# Final link uses lots of file descriptors.
	ulimit -n 2048

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Don't inherit PYTHONPATH from environment, bug #789021, #812689
	local -x PYTHONPATH=

	export ELECTRON_OUT_DIR=Release
	eninja -C out/Release electron:node_headers

	if use pax-kernel; then
		local x
		for x in mksnapshot v8_context_snapshot_generator code_cache_generator; do
			if tc-is-cross-compiler; then
				eninja -C out/Release "host/${x}"
				pax-mark m "out/Release/host/${x}"
			else
				eninja -C out/Release "${x}"
				pax-mark m "out/Release/${x}"
			fi
		done
	fi

	#Fix node build error: https://github.com/webpack/webpack/issues/14532#issuecomment-947012063
	if has_version ">=dev-libs/openssl-3.0.0"; then
		export NODE_OPTIONS=--openssl-legacy-provider
	fi

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release electron

	eninja -C out/Release chrome_sandbox

	pax-mark m out/Release/electron
}

src_install() {
	local install_dir="$(_get_install_dir)"
	local install_suffix="$(_get_install_suffix)"
	local LIBDIR="${ED}/usr/$(get_libdir)"

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	# Install Electron
	insinto "${install_dir}"
	exeinto "${install_dir}"
	doexe out/Release/electron
	doexe out/Release/mksnapshot
	doexe out/Release/chrome_crashpad_handler
	newexe out/Release/chrome_sandbox chrome-sandbox
	fperms 4755 "${install_dir}"/chrome-sandbox

	insopts -m644
	doins out/Release/*.bin
	doins out/Release/*.pak
	doins out/Release/*.json
	if ! use system-icu; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/resources

	doins -r "${NODE_S}/deps/npm"

	fperms -R 755 "${install_dir}/npm/bin/"

	echo "${PV}" > out/Release/version
	doins out/Release/version

	insinto "${install_dir}"/locales
	doins out/Release/locales/*.pak

	insopts -m755
	if [[ -d out/Release/swiftshader ]]; then
        insinto "${install_dir}"/swiftshader
        doins out/Release/swiftshader/*.so
    fi

	if use bindist; then
		# We built libffmpeg as a component library, but we can't distribute it
		# with proprietary codec support. Remove it and make a symlink to the requested
		# system library.
		rm -f out/Release/libffmpeg.so \
			|| die "Failed to remove bundled libffmpeg.so (with proprietary codecs)"
		# symlink the libffmpeg.so from either ffmpeg-chromium or ffmpeg[chromium].
		einfo "Creating symlink to libffmpeg.so from $(usex ffmpeg-chromium ffmpeg-chromium ffmpeg[chromium])..."
		dosym ../chromium/libffmpeg.so$(usex ffmpeg-chromium .${CHROMIUM_VERSION%%\.*} "") \
			/usr/$(get_libdir)/chromium-browser/libffmpeg.so
	fi

	insinto "${install_dir}"
	(
		shopt -s nullglob
		local files=(out/Release/*.so out/Release/*.so.[0-9])
		[[ ${#files[@]} -gt 0 ]] && doins "${files[@]}"
	)

	rm "${ED}/${install_dir}"/libVkICD_mock_icd.so
	rm "${ED}/${install_dir}"/v8_build_config.json

	insopts -m644

	cat >out/Release/node <<EOF
#!/bin/sh
exec env ELECTRON_RUN_AS_NODE=1 "${install_dir}/electron" "\${@}"
EOF
	doexe out/Release/node

	# Install Node headers
	insopts -m644
	local node_headers="/usr/include/electron${install_suffix}"
	insinto "${node_headers}"
	doins -r out/Release/gen/node_headers/include/node
	# set up a symlink structure that npm expects..
	dodir "${node_headers}"/node/deps/{v8,uv}
	dodir "${node_headers}"/node/include
	dosym . "${node_headers}"/node/src
	dosym .. "${node_headers}"/node/include/node
	for var in deps/{uv,v8}/include; do
		dosym ../.. "${node_headers}"/node/${var}
	done

	dosym "${install_dir}/electron" "/usr/bin/electron${install_suffix}"
}
