# Copyright 2009-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GN_MIN_VER=0.2217

VIRTUALX_REQUIRED="pgo"

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

LLVM_COMPAT=( 19 20 )
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="xml(+)"
RUST_MIN_VER=1.78.0
# RUST_MAX_VER=1.89.0 # allocator shim change in 1.89
RUST_NEEDS_LLVM="yes please"

inherit check-reqs chromium-2 desktop flag-o-matic llvm-r1 multiprocessing ninja-utils pax-utils
inherit python-any-r1 readme.gentoo-r1 rust toolchain-funcs virtualx xdg-utils
inherit rust-toolchain

# Keep this in sync with DEPS:chromium_version
# find least version of available snapshot in
# https://gsdview.appspot.com/chromium-browser-official/?marker=chromium-134.0.6998.167.tar.xz.hashe%40
CHROMIUM_VERSION="136.0.7103.168"
# Keep this in sync with DEPS:node_version
NODE_VERSION="22.17.1"

DESCRIPTION="Cross platform application development framework based on web technologies"
HOMEPAGE="https://electronjs.org/"

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

# grep resolved yarn.lock | sed 's/^[ ]*resolved \"\(.*\)\#.*\"$/\1/g' | sort | uniq | wl-copy
YARNPKGS="
https://registry.yarnpkg.com/@azure/abort-controller/-/abort-controller-1.0.4.tgz
https://registry.yarnpkg.com/@azure/abort-controller/-/abort-controller-2.1.2.tgz
https://registry.yarnpkg.com/@azure/core-asynciterator-polyfill/-/core-asynciterator-polyfill-1.0.2.tgz
https://registry.yarnpkg.com/@azure/core-auth/-/core-auth-1.8.0.tgz
https://registry.yarnpkg.com/@azure/core-client/-/core-client-1.9.2.tgz
https://registry.yarnpkg.com/@azure/core-http-compat/-/core-http-compat-2.1.2.tgz
https://registry.yarnpkg.com/@azure/core-lro/-/core-lro-2.2.4.tgz
https://registry.yarnpkg.com/@azure/core-paging/-/core-paging-1.2.1.tgz
https://registry.yarnpkg.com/@azure/core-rest-pipeline/-/core-rest-pipeline-1.17.0.tgz
https://registry.yarnpkg.com/@azure/core-tracing/-/core-tracing-1.0.0-preview.13.tgz
https://registry.yarnpkg.com/@azure/core-tracing/-/core-tracing-1.1.2.tgz
https://registry.yarnpkg.com/@azure/core-util/-/core-util-1.10.0.tgz
https://registry.yarnpkg.com/@azure/core-xml/-/core-xml-1.4.3.tgz
https://registry.yarnpkg.com/@azure/logger/-/logger-1.0.3.tgz
https://registry.yarnpkg.com/@azure/storage-blob/-/storage-blob-12.25.0.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.25.7.tgz
https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.5.5.tgz
https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.7.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.25.7.tgz
https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.5.0.tgz
https://registry.yarnpkg.com/@discoveryjs/json-ext/-/json-ext-0.5.7.tgz
https://registry.yarnpkg.com/@dsanders11/vscode-markdown-languageservice/-/vscode-markdown-languageservice-0.3.0.tgz
https://registry.yarnpkg.com/@electron/asar/-/asar-3.2.13.tgz
https://registry.yarnpkg.com/@electron/docs-parser/-/docs-parser-2.0.0.tgz
https://registry.yarnpkg.com/@electron/fiddle-core/-/fiddle-core-1.3.4.tgz
https://registry.yarnpkg.com/@electron/get/-/get-2.0.2.tgz
https://registry.yarnpkg.com/@electron/github-app-auth/-/github-app-auth-2.2.1.tgz
https://registry.yarnpkg.com/@electron/lint-roller/-/lint-roller-3.1.1.tgz
https://registry.yarnpkg.com/@electron/typescript-definitions/-/typescript-definitions-9.1.2.tgz
https://registry.yarnpkg.com/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz
https://registry.yarnpkg.com/@eslint-community/regexpp/-/regexpp-4.11.1.tgz
https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-2.1.4.tgz
https://registry.yarnpkg.com/@eslint/js/-/js-8.57.1.tgz
https://registry.yarnpkg.com/@humanwhocodes/config-array/-/config-array-0.13.0.tgz
https://registry.yarnpkg.com/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz
https://registry.yarnpkg.com/@humanwhocodes/object-schema/-/object-schema-2.0.3.tgz
https://registry.yarnpkg.com/@isaacs/cliui/-/cliui-8.0.2.tgz
https://registry.yarnpkg.com/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz
https://registry.yarnpkg.com/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz
https://registry.yarnpkg.com/@jridgewell/set-array/-/set-array-1.2.1.tgz
https://registry.yarnpkg.com/@jridgewell/source-map/-/source-map-0.3.6.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.14.tgz
https://registry.yarnpkg.com/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz
https://registry.yarnpkg.com/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz
https://registry.yarnpkg.com/@kwsites/file-exists/-/file-exists-1.1.1.tgz
https://registry.yarnpkg.com/@kwsites/promise-deferred/-/promise-deferred-1.1.1.tgz
https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.3.tgz
https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz
https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz
https://registry.yarnpkg.com/@npmcli/config/-/config-8.3.4.tgz
https://registry.yarnpkg.com/@npmcli/git/-/git-5.0.8.tgz
https://registry.yarnpkg.com/@npmcli/map-workspaces/-/map-workspaces-3.0.6.tgz
https://registry.yarnpkg.com/@npmcli/name-from-folder/-/name-from-folder-2.0.0.tgz
https://registry.yarnpkg.com/@npmcli/package-json/-/package-json-5.2.1.tgz
https://registry.yarnpkg.com/@npmcli/promise-spawn/-/promise-spawn-7.0.2.tgz
https://registry.yarnpkg.com/@octokit/auth-app/-/auth-app-4.0.13.tgz
https://registry.yarnpkg.com/@octokit/auth-oauth-app/-/auth-oauth-app-5.0.5.tgz
https://registry.yarnpkg.com/@octokit/auth-oauth-device/-/auth-oauth-device-4.0.3.tgz
https://registry.yarnpkg.com/@octokit/auth-oauth-user/-/auth-oauth-user-2.0.4.tgz
https://registry.yarnpkg.com/@octokit/auth-token/-/auth-token-3.0.3.tgz
https://registry.yarnpkg.com/@octokit/auth-token/-/auth-token-4.0.0.tgz
https://registry.yarnpkg.com/@octokit/core/-/core-4.2.1.tgz
https://registry.yarnpkg.com/@octokit/core/-/core-5.2.0.tgz
https://registry.yarnpkg.com/@octokit/endpoint/-/endpoint-7.0.3.tgz
https://registry.yarnpkg.com/@octokit/endpoint/-/endpoint-9.0.5.tgz
https://registry.yarnpkg.com/@octokit/graphql/-/graphql-5.0.5.tgz
https://registry.yarnpkg.com/@octokit/graphql/-/graphql-7.1.0.tgz
https://registry.yarnpkg.com/@octokit/oauth-authorization-url/-/oauth-authorization-url-5.0.0.tgz
https://registry.yarnpkg.com/@octokit/oauth-methods/-/oauth-methods-2.0.4.tgz
https://registry.yarnpkg.com/@octokit/openapi-types/-/openapi-types-14.0.0.tgz
https://registry.yarnpkg.com/@octokit/openapi-types/-/openapi-types-16.0.0.tgz
https://registry.yarnpkg.com/@octokit/openapi-types/-/openapi-types-17.2.0.tgz
https://registry.yarnpkg.com/@octokit/openapi-types/-/openapi-types-22.2.0.tgz
https://registry.yarnpkg.com/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-11.3.1.tgz
https://registry.yarnpkg.com/@octokit/plugin-paginate-rest/-/plugin-paginate-rest-6.1.2.tgz
https://registry.yarnpkg.com/@octokit/plugin-request-log/-/plugin-request-log-1.0.4.tgz
https://registry.yarnpkg.com/@octokit/plugin-request-log/-/plugin-request-log-4.0.1.tgz
https://registry.yarnpkg.com/@octokit/plugin-rest-endpoint-methods/-/plugin-rest-endpoint-methods-13.2.2.tgz
https://registry.yarnpkg.com/@octokit/plugin-rest-endpoint-methods/-/plugin-rest-endpoint-methods-7.1.2.tgz
https://registry.yarnpkg.com/@octokit/request-error/-/request-error-3.0.2.tgz
https://registry.yarnpkg.com/@octokit/request-error/-/request-error-5.1.0.tgz
https://registry.yarnpkg.com/@octokit/request/-/request-6.2.4.tgz
https://registry.yarnpkg.com/@octokit/request/-/request-8.4.0.tgz
https://registry.yarnpkg.com/@octokit/rest/-/rest-19.0.11.tgz
https://registry.yarnpkg.com/@octokit/rest/-/rest-20.1.1.tgz
https://registry.yarnpkg.com/@octokit/tsconfig/-/tsconfig-1.0.2.tgz
https://registry.yarnpkg.com/@octokit/types/-/types-13.5.0.tgz
https://registry.yarnpkg.com/@octokit/types/-/types-8.0.0.tgz
https://registry.yarnpkg.com/@octokit/types/-/types-9.0.0.tgz
https://registry.yarnpkg.com/@octokit/types/-/types-9.2.3.tgz
https://registry.yarnpkg.com/@opentelemetry/api/-/api-1.0.4.tgz
https://registry.yarnpkg.com/@pkgjs/parseargs/-/parseargs-0.11.0.tgz
https://registry.yarnpkg.com/@primer/octicons/-/octicons-10.0.0.tgz
https://registry.yarnpkg.com/@rtsao/scc/-/scc-1.1.0.tgz
https://registry.yarnpkg.com/@sindresorhus/is/-/is-4.6.0.tgz
https://registry.yarnpkg.com/@sindresorhus/merge-streams/-/merge-streams-2.3.0.tgz
https://registry.yarnpkg.com/@szmarczak/http-timer/-/http-timer-4.0.6.tgz
https://registry.yarnpkg.com/@types/btoa-lite/-/btoa-lite-1.0.0.tgz
https://registry.yarnpkg.com/@types/cacheable-request/-/cacheable-request-6.0.2.tgz
https://registry.yarnpkg.com/@types/color-name/-/color-name-1.1.1.tgz
https://registry.yarnpkg.com/@types/concat-stream/-/concat-stream-2.0.3.tgz
https://registry.yarnpkg.com/@types/debug/-/debug-4.1.7.tgz
https://registry.yarnpkg.com/@types/estree/-/estree-1.0.5.tgz
https://registry.yarnpkg.com/@types/glob/-/glob-7.2.0.tgz
https://registry.yarnpkg.com/@types/hast/-/hast-3.0.4.tgz
https://registry.yarnpkg.com/@types/http-cache-semantics/-/http-cache-semantics-4.0.1.tgz
https://registry.yarnpkg.com/@types/is-empty/-/is-empty-1.2.0.tgz
https://registry.yarnpkg.com/@types/json-buffer/-/json-buffer-3.0.0.tgz
https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.11.tgz
https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz
https://registry.yarnpkg.com/@types/jsonwebtoken/-/jsonwebtoken-9.0.1.tgz
https://registry.yarnpkg.com/@types/katex/-/katex-0.16.7.tgz
https://registry.yarnpkg.com/@types/keyv/-/keyv-3.1.4.tgz
https://registry.yarnpkg.com/@types/linkify-it/-/linkify-it-5.0.0.tgz
https://registry.yarnpkg.com/@types/markdown-it/-/markdown-it-14.1.2.tgz
https://registry.yarnpkg.com/@types/mdast/-/mdast-4.0.4.tgz
https://registry.yarnpkg.com/@types/mdurl/-/mdurl-2.0.0.tgz
https://registry.yarnpkg.com/@types/minimatch/-/minimatch-3.0.3.tgz
https://registry.yarnpkg.com/@types/minimist/-/minimist-1.2.5.tgz
https://registry.yarnpkg.com/@types/ms/-/ms-0.7.31.tgz
https://registry.yarnpkg.com/@types/node/-/node-12.6.1.tgz
https://registry.yarnpkg.com/@types/node/-/node-20.16.12.tgz
https://registry.yarnpkg.com/@types/node/-/node-20.16.9.tgz
https://registry.yarnpkg.com/@types/node/-/node-22.7.7.tgz
https://registry.yarnpkg.com/@types/parse-json/-/parse-json-4.0.0.tgz
https://registry.yarnpkg.com/@types/responselike/-/responselike-1.0.0.tgz
https://registry.yarnpkg.com/@types/semver/-/semver-7.5.8.tgz
https://registry.yarnpkg.com/@types/stream-chain/-/stream-chain-2.0.0.tgz
https://registry.yarnpkg.com/@types/stream-json/-/stream-json-1.7.7.tgz
https://registry.yarnpkg.com/@types/supports-color/-/supports-color-8.1.1.tgz
https://registry.yarnpkg.com/@types/temp/-/temp-0.9.4.tgz
https://registry.yarnpkg.com/@types/text-table/-/text-table-0.2.2.tgz
https://registry.yarnpkg.com/@types/unist/-/unist-2.0.3.tgz
https://registry.yarnpkg.com/@types/unist/-/unist-2.0.6.tgz
https://registry.yarnpkg.com/@types/unist/-/unist-3.0.2.tgz
https://registry.yarnpkg.com/@types/webpack-env/-/webpack-env-1.18.5.tgz
https://registry.yarnpkg.com/@types/yauzl/-/yauzl-2.10.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-8.7.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-8.7.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/scope-manager/-/scope-manager-8.7.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/type-utils/-/type-utils-8.7.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/types/-/types-8.7.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-8.7.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/utils/-/utils-8.7.0.tgz
https://registry.yarnpkg.com/@typescript-eslint/visitor-keys/-/visitor-keys-8.7.0.tgz
https://registry.yarnpkg.com/@ungap/structured-clone/-/structured-clone-1.2.0.tgz
https://registry.yarnpkg.com/@vscode/l10n/-/l10n-0.0.10.tgz
https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.12.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.12.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-numbers/-/helper-numbers-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.12.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.11.6.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.12.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.12.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.12.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.12.1.tgz
https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.12.1.tgz
https://registry.yarnpkg.com/@webpack-cli/configtest/-/configtest-2.1.1.tgz
https://registry.yarnpkg.com/@webpack-cli/info/-/info-2.0.2.tgz
https://registry.yarnpkg.com/@webpack-cli/serve/-/serve-2.0.5.tgz
https://registry.yarnpkg.com/@xtuc/ieee754/-/ieee754-1.2.0.tgz
https://registry.yarnpkg.com/@xtuc/long/-/long-4.2.2.tgz
https://registry.yarnpkg.com/abbrev/-/abbrev-2.0.0.tgz
https://registry.yarnpkg.com/acorn-import-attributes/-/acorn-import-attributes-1.9.5.tgz
https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.2.tgz
https://registry.yarnpkg.com/acorn/-/acorn-8.12.1.tgz
https://registry.yarnpkg.com/agent-base/-/agent-base-7.1.1.tgz
https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.0.1.tgz
https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.5.2.tgz
https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz
https://registry.yarnpkg.com/ajv/-/ajv-8.17.1.tgz
https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz
https://registry.yarnpkg.com/ansi-escapes/-/ansi-escapes-4.3.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.1.tgz
https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-6.0.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.2.1.tgz
https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-6.2.1.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.0.3.tgz
https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.2.tgz
https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz
https://registry.yarnpkg.com/argparse/-/argparse-2.0.1.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.0.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.1.tgz
https://registry.yarnpkg.com/array-buffer-byte-length/-/array-buffer-byte-length-1.0.2.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.6.tgz
https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.9.tgz
https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz
https://registry.yarnpkg.com/array.prototype.findlastindex/-/array.prototype.findlastindex-1.2.6.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.3.1.tgz
https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.3.3.tgz
https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.3.1.tgz
https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.3.3.tgz
https://registry.yarnpkg.com/array.prototype.tosorted/-/array.prototype.tosorted-1.1.1.tgz
https://registry.yarnpkg.com/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.3.tgz
https://registry.yarnpkg.com/arraybuffer.prototype.slice/-/arraybuffer.prototype.slice-1.0.4.tgz
https://registry.yarnpkg.com/arrify/-/arrify-1.0.1.tgz
https://registry.yarnpkg.com/assertion-error/-/assertion-error-2.0.1.tgz
https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz
https://registry.yarnpkg.com/async-function/-/async-function-1.0.0.tgz
https://registry.yarnpkg.com/async/-/async-3.2.4.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.5.tgz
https://registry.yarnpkg.com/available-typed-arrays/-/available-typed-arrays-1.0.7.tgz
https://registry.yarnpkg.com/bail/-/bail-2.0.1.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz
https://registry.yarnpkg.com/balanced-match/-/balanced-match-3.0.1.tgz
https://registry.yarnpkg.com/base64-js/-/base64-js-1.5.1.tgz
https://registry.yarnpkg.com/before-after-hook/-/before-after-hook-2.2.3.tgz
https://registry.yarnpkg.com/big.js/-/big.js-5.2.2.tgz
https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.1.0.tgz
https://registry.yarnpkg.com/boolean/-/boolean-3.2.0.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.12.tgz
https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-2.0.2.tgz
https://registry.yarnpkg.com/braces/-/braces-3.0.3.tgz
https://registry.yarnpkg.com/browserslist/-/browserslist-4.23.3.tgz
https://registry.yarnpkg.com/btoa-lite/-/btoa-lite-1.0.0.tgz
https://registry.yarnpkg.com/buffer-crc32/-/buffer-crc32-0.2.13.tgz
https://registry.yarnpkg.com/buffer-equal-constant-time/-/buffer-equal-constant-time-1.0.1.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.1.tgz
https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.2.tgz
https://registry.yarnpkg.com/buffer/-/buffer-6.0.3.tgz
https://registry.yarnpkg.com/builtin-modules/-/builtin-modules-3.3.0.tgz
https://registry.yarnpkg.com/builtins/-/builtins-5.0.1.tgz
https://registry.yarnpkg.com/cacheable-lookup/-/cacheable-lookup-5.0.4.tgz
https://registry.yarnpkg.com/cacheable-request/-/cacheable-request-7.0.2.tgz
https://registry.yarnpkg.com/call-bind-apply-helpers/-/call-bind-apply-helpers-1.0.2.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.7.tgz
https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.8.tgz
https://registry.yarnpkg.com/call-bound/-/call-bound-1.0.4.tgz
https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz
https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001659.tgz
https://registry.yarnpkg.com/chai/-/chai-5.1.1.tgz
https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.0.tgz
https://registry.yarnpkg.com/chalk/-/chalk-4.1.2.tgz
https://registry.yarnpkg.com/chalk/-/chalk-5.3.0.tgz
https://registry.yarnpkg.com/character-entities-legacy/-/character-entities-legacy-3.0.0.tgz
https://registry.yarnpkg.com/character-entities/-/character-entities-2.0.0.tgz
https://registry.yarnpkg.com/character-reference-invalid/-/character-reference-invalid-2.0.0.tgz
https://registry.yarnpkg.com/check-error/-/check-error-2.1.1.tgz
https://registry.yarnpkg.com/check-for-leaks/-/check-for-leaks-1.2.1.tgz
https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.2.tgz
https://registry.yarnpkg.com/chownr/-/chownr-2.0.0.tgz
https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.2.tgz
https://registry.yarnpkg.com/ci-info/-/ci-info-4.0.0.tgz
https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-3.1.0.tgz
https://registry.yarnpkg.com/cli-cursor/-/cli-cursor-5.0.0.tgz
https://registry.yarnpkg.com/cli-spinners/-/cli-spinners-2.9.2.tgz
https://registry.yarnpkg.com/cli-truncate/-/cli-truncate-2.1.0.tgz
https://registry.yarnpkg.com/clone-deep/-/clone-deep-4.0.1.tgz
https://registry.yarnpkg.com/clone-response/-/clone-response-1.0.2.tgz
https://registry.yarnpkg.com/co/-/co-3.1.0.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.3.tgz
https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz
https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz
https://registry.yarnpkg.com/colorette/-/colorette-2.0.19.tgz
https://registry.yarnpkg.com/comma-separated-tokens/-/comma-separated-tokens-2.0.3.tgz
https://registry.yarnpkg.com/commander/-/commander-10.0.1.tgz
https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz
https://registry.yarnpkg.com/commander/-/commander-5.1.0.tgz
https://registry.yarnpkg.com/commander/-/commander-8.3.0.tgz
https://registry.yarnpkg.com/compress-brotli/-/compress-brotli-1.3.8.tgz
https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz
https://registry.yarnpkg.com/concat-stream/-/concat-stream-2.0.0.tgz
https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz
https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-6.0.0.tgz
https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.6.tgz
https://registry.yarnpkg.com/data-view-buffer/-/data-view-buffer-1.0.1.tgz
https://registry.yarnpkg.com/data-view-buffer/-/data-view-buffer-1.0.2.tgz
https://registry.yarnpkg.com/data-view-byte-length/-/data-view-byte-length-1.0.1.tgz
https://registry.yarnpkg.com/data-view-byte-length/-/data-view-byte-length-1.0.2.tgz
https://registry.yarnpkg.com/data-view-byte-offset/-/data-view-byte-offset-1.0.0.tgz
https://registry.yarnpkg.com/data-view-byte-offset/-/data-view-byte-offset-1.0.1.tgz
https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz
https://registry.yarnpkg.com/debug/-/debug-4.3.7.tgz
https://registry.yarnpkg.com/decode-named-character-reference/-/decode-named-character-reference-1.0.2.tgz
https://registry.yarnpkg.com/decompress-response/-/decompress-response-6.0.0.tgz
https://registry.yarnpkg.com/dedent/-/dedent-0.7.0.tgz
https://registry.yarnpkg.com/deep-eql/-/deep-eql-5.0.2.tgz
https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.3.tgz
https://registry.yarnpkg.com/defer-to-connect/-/defer-to-connect-2.0.1.tgz
https://registry.yarnpkg.com/define-data-property/-/define-data-property-1.1.4.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.0.tgz
https://registry.yarnpkg.com/define-properties/-/define-properties-1.2.1.tgz
https://registry.yarnpkg.com/deprecation/-/deprecation-2.3.1.tgz
https://registry.yarnpkg.com/dequal/-/dequal-2.0.3.tgz
https://registry.yarnpkg.com/detect-node/-/detect-node-2.1.0.tgz
https://registry.yarnpkg.com/devlop/-/devlop-1.1.0.tgz
https://registry.yarnpkg.com/diff/-/diff-3.5.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz
https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz
https://registry.yarnpkg.com/dugite/-/dugite-2.7.1.tgz
https://registry.yarnpkg.com/dunder-proto/-/dunder-proto-1.0.1.tgz
https://registry.yarnpkg.com/duplexer/-/duplexer-0.1.1.tgz
https://registry.yarnpkg.com/eastasianwidth/-/eastasianwidth-0.2.0.tgz
https://registry.yarnpkg.com/ecdsa-sig-formatter/-/ecdsa-sig-formatter-1.0.11.tgz
https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.5.18.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-10.4.0.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz
https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-9.2.2.tgz
https://registry.yarnpkg.com/emojis-list/-/emojis-list-3.0.0.tgz
https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.4.tgz
https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-4.1.0.tgz
https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-5.17.1.tgz
https://registry.yarnpkg.com/enquirer/-/enquirer-2.3.6.tgz
https://registry.yarnpkg.com/ensure-posix-path/-/ensure-posix-path-1.1.1.tgz
https://registry.yarnpkg.com/entities/-/entities-4.5.0.tgz
https://registry.yarnpkg.com/env-paths/-/env-paths-2.2.1.tgz
https://registry.yarnpkg.com/envinfo/-/envinfo-7.8.1.tgz
https://registry.yarnpkg.com/err-code/-/err-code-2.0.3.tgz
https://registry.yarnpkg.com/errno/-/errno-0.1.7.tgz
https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.21.2.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.23.3.tgz
https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.24.0.tgz
https://registry.yarnpkg.com/es-define-property/-/es-define-property-1.0.0.tgz
https://registry.yarnpkg.com/es-define-property/-/es-define-property-1.0.1.tgz
https://registry.yarnpkg.com/es-errors/-/es-errors-1.3.0.tgz
https://registry.yarnpkg.com/es-module-lexer/-/es-module-lexer-1.5.4.tgz
https://registry.yarnpkg.com/es-object-atoms/-/es-object-atoms-1.0.0.tgz
https://registry.yarnpkg.com/es-object-atoms/-/es-object-atoms-1.1.1.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.1.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.0.3.tgz
https://registry.yarnpkg.com/es-set-tostringtag/-/es-set-tostringtag-2.1.0.tgz
https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.0.0.tgz
https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.0.2.tgz
https://registry.yarnpkg.com/es-shim-unscopables/-/es-shim-unscopables-1.1.0.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz
https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.3.0.tgz
https://registry.yarnpkg.com/es6-error/-/es6-error-4.1.1.tgz
https://registry.yarnpkg.com/escalade/-/escalade-3.2.0.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz
https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz
https://registry.yarnpkg.com/eslint-compat-utils/-/eslint-compat-utils-0.5.1.tgz
https://registry.yarnpkg.com/eslint-config-standard-jsx/-/eslint-config-standard-jsx-11.0.0.tgz
https://registry.yarnpkg.com/eslint-config-standard/-/eslint-config-standard-17.0.0.tgz
https://registry.yarnpkg.com/eslint-config-standard/-/eslint-config-standard-17.1.0.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.7.tgz
https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.9.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.12.1.tgz
https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.8.0.tgz
https://registry.yarnpkg.com/eslint-plugin-es-x/-/eslint-plugin-es-x-7.8.0.tgz
https://registry.yarnpkg.com/eslint-plugin-es/-/eslint-plugin-es-3.0.1.tgz
https://registry.yarnpkg.com/eslint-plugin-es/-/eslint-plugin-es-4.1.0.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.27.5.tgz
https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.32.0.tgz
https://registry.yarnpkg.com/eslint-plugin-mocha/-/eslint-plugin-mocha-10.5.0.tgz
https://registry.yarnpkg.com/eslint-plugin-n/-/eslint-plugin-n-15.7.0.tgz
https://registry.yarnpkg.com/eslint-plugin-n/-/eslint-plugin-n-16.6.2.tgz
https://registry.yarnpkg.com/eslint-plugin-node/-/eslint-plugin-node-11.1.0.tgz
https://registry.yarnpkg.com/eslint-plugin-promise/-/eslint-plugin-promise-6.1.1.tgz
https://registry.yarnpkg.com/eslint-plugin-promise/-/eslint-plugin-promise-6.6.0.tgz
https://registry.yarnpkg.com/eslint-plugin-react/-/eslint-plugin-react-7.32.2.tgz
https://registry.yarnpkg.com/eslint-plugin-standard/-/eslint-plugin-standard-5.0.0.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz
https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-7.2.2.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz
https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-3.0.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.1.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.0.0.tgz
https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz
https://registry.yarnpkg.com/eslint/-/eslint-8.57.1.tgz
https://registry.yarnpkg.com/espree/-/espree-9.6.1.tgz
https://registry.yarnpkg.com/esprima/-/esprima-4.0.1.tgz
https://registry.yarnpkg.com/esquery/-/esquery-1.5.0.tgz
https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-4.3.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.1.0.tgz
https://registry.yarnpkg.com/estraverse/-/estraverse-5.3.0.tgz
https://registry.yarnpkg.com/esutils/-/esutils-2.0.3.tgz
https://registry.yarnpkg.com/events-to-array/-/events-to-array-1.1.2.tgz
https://registry.yarnpkg.com/events/-/events-3.3.0.tgz
https://registry.yarnpkg.com/execa/-/execa-4.0.3.tgz
https://registry.yarnpkg.com/extend/-/extend-3.0.2.tgz
https://registry.yarnpkg.com/extract-zip/-/extract-zip-2.0.1.tgz
https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.3.2.tgz
https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.3.3.tgz
https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz
https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz
https://registry.yarnpkg.com/fast-uri/-/fast-uri-3.0.1.tgz
https://registry.yarnpkg.com/fast-xml-parser/-/fast-xml-parser-4.5.0.tgz
https://registry.yarnpkg.com/fastest-levenshtein/-/fastest-levenshtein-1.0.14.tgz
https://registry.yarnpkg.com/fastq/-/fastq-1.8.0.tgz
https://registry.yarnpkg.com/fd-slicer/-/fd-slicer-1.1.0.tgz
https://registry.yarnpkg.com/figures/-/figures-3.2.0.tgz
https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz
https://registry.yarnpkg.com/fill-range/-/fill-range-7.1.1.tgz
https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz
https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz
https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz
https://registry.yarnpkg.com/flatted/-/flatted-3.2.7.tgz
https://registry.yarnpkg.com/folder-hash/-/folder-hash-2.1.2.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.3.tgz
https://registry.yarnpkg.com/for-each/-/for-each-0.3.5.tgz
https://registry.yarnpkg.com/foreground-child/-/foreground-child-3.1.1.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-10.1.0.tgz
https://registry.yarnpkg.com/fs-extra/-/fs-extra-8.1.0.tgz
https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.1.0.tgz
https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz
https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz
https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.2.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.5.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.6.tgz
https://registry.yarnpkg.com/function.prototype.name/-/function.prototype.name-1.1.8.tgz
https://registry.yarnpkg.com/functions-have-names/-/functions-have-names-1.2.3.tgz
https://registry.yarnpkg.com/get-east-asian-width/-/get-east-asian-width-1.2.0.tgz
https://registry.yarnpkg.com/get-func-name/-/get-func-name-2.0.2.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.1.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.2.4.tgz
https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.3.0.tgz
https://registry.yarnpkg.com/get-own-enumerable-property-symbols/-/get-own-enumerable-property-symbols-3.0.0.tgz
https://registry.yarnpkg.com/get-proto/-/get-proto-1.0.1.tgz
https://registry.yarnpkg.com/get-stdin/-/get-stdin-8.0.0.tgz
https://registry.yarnpkg.com/get-stream/-/get-stream-5.2.0.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.0.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.0.2.tgz
https://registry.yarnpkg.com/get-symbol-description/-/get-symbol-description-1.1.0.tgz
https://registry.yarnpkg.com/get-tsconfig/-/get-tsconfig-4.8.1.tgz
https://registry.yarnpkg.com/getos/-/getos-3.2.1.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz
https://registry.yarnpkg.com/glob-parent/-/glob-parent-6.0.2.tgz
https://registry.yarnpkg.com/glob-to-regexp/-/glob-to-regexp-0.4.1.tgz
https://registry.yarnpkg.com/glob/-/glob-10.4.5.tgz
https://registry.yarnpkg.com/glob/-/glob-7.2.0.tgz
https://registry.yarnpkg.com/glob/-/glob-9.3.5.tgz
https://registry.yarnpkg.com/global-agent/-/global-agent-3.0.0.tgz
https://registry.yarnpkg.com/globals/-/globals-13.20.0.tgz
https://registry.yarnpkg.com/globals/-/globals-13.24.0.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.3.tgz
https://registry.yarnpkg.com/globalthis/-/globalthis-1.0.4.tgz
https://registry.yarnpkg.com/globby/-/globby-14.1.0.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.0.1.tgz
https://registry.yarnpkg.com/gopd/-/gopd-1.2.0.tgz
https://registry.yarnpkg.com/got/-/got-11.8.5.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.1.15.tgz
https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.11.tgz
https://registry.yarnpkg.com/graphemer/-/graphemer-1.4.0.tgz
https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.2.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz
https://registry.yarnpkg.com/has-flag/-/has-flag-5.0.1.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.0.tgz
https://registry.yarnpkg.com/has-property-descriptors/-/has-property-descriptors-1.0.2.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.1.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.0.3.tgz
https://registry.yarnpkg.com/has-proto/-/has-proto-1.2.0.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.3.tgz
https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.1.0.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.0.tgz
https://registry.yarnpkg.com/has-tostringtag/-/has-tostringtag-1.0.2.tgz
https://registry.yarnpkg.com/has/-/has-1.0.3.tgz
https://registry.yarnpkg.com/hasown/-/hasown-2.0.2.tgz
https://registry.yarnpkg.com/hast-util-from-html/-/hast-util-from-html-2.0.1.tgz
https://registry.yarnpkg.com/hast-util-from-parse5/-/hast-util-from-parse5-8.0.1.tgz
https://registry.yarnpkg.com/hast-util-parse-selector/-/hast-util-parse-selector-4.0.0.tgz
https://registry.yarnpkg.com/hastscript/-/hastscript-8.0.0.tgz
https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-7.0.2.tgz
https://registry.yarnpkg.com/http-cache-semantics/-/http-cache-semantics-4.1.1.tgz
https://registry.yarnpkg.com/http-proxy-agent/-/http-proxy-agent-7.0.2.tgz
https://registry.yarnpkg.com/http2-wrapper/-/http2-wrapper-1.0.3.tgz
https://registry.yarnpkg.com/https-proxy-agent/-/https-proxy-agent-7.0.5.tgz
https://registry.yarnpkg.com/human-signals/-/human-signals-1.1.1.tgz
https://registry.yarnpkg.com/husky/-/husky-8.0.1.tgz
https://registry.yarnpkg.com/ieee754/-/ieee754-1.2.1.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.3.1.tgz
https://registry.yarnpkg.com/ignore/-/ignore-5.3.2.tgz
https://registry.yarnpkg.com/ignore/-/ignore-7.0.4.tgz
https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz
https://registry.yarnpkg.com/import-local/-/import-local-3.1.0.tgz
https://registry.yarnpkg.com/import-meta-resolve/-/import-meta-resolve-4.1.0.tgz
https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz
https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz
https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz
https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz
https://registry.yarnpkg.com/ini/-/ini-4.1.3.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.5.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.7.tgz
https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.1.0.tgz
https://registry.yarnpkg.com/interpret/-/interpret-1.4.0.tgz
https://registry.yarnpkg.com/interpret/-/interpret-3.1.1.tgz
https://registry.yarnpkg.com/is-alphabetical/-/is-alphabetical-2.0.0.tgz
https://registry.yarnpkg.com/is-alphanumerical/-/is-alphanumerical-2.0.0.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.2.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.4.tgz
https://registry.yarnpkg.com/is-array-buffer/-/is-array-buffer-3.0.5.tgz
https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz
https://registry.yarnpkg.com/is-async-function/-/is-async-function-2.1.1.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.4.tgz
https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.1.0.tgz
https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.2.tgz
https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.2.2.tgz
https://registry.yarnpkg.com/is-builtin-module/-/is-builtin-module-3.2.1.tgz
https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.7.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.12.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.15.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.16.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.8.1.tgz
https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.9.0.tgz
https://registry.yarnpkg.com/is-data-view/-/is-data-view-1.0.1.tgz
https://registry.yarnpkg.com/is-data-view/-/is-data-view-1.0.2.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.5.tgz
https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.1.0.tgz
https://registry.yarnpkg.com/is-decimal/-/is-decimal-2.0.0.tgz
https://registry.yarnpkg.com/is-empty/-/is-empty-1.2.0.tgz
https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz
https://registry.yarnpkg.com/is-finalizationregistry/-/is-finalizationregistry-1.1.1.tgz
https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz
https://registry.yarnpkg.com/is-generator-function/-/is-generator-function-1.1.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz
https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.3.tgz
https://registry.yarnpkg.com/is-hexadecimal/-/is-hexadecimal-2.0.0.tgz
https://registry.yarnpkg.com/is-interactive/-/is-interactive-2.0.0.tgz
https://registry.yarnpkg.com/is-map/-/is-map-2.0.3.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.2.tgz
https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.3.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.7.tgz
https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.1.1.tgz
https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz
https://registry.yarnpkg.com/is-obj/-/is-obj-1.0.1.tgz
https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-3.0.3.tgz
https://registry.yarnpkg.com/is-plain-obj/-/is-plain-obj-4.0.0.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz
https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-5.0.0.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.4.tgz
https://registry.yarnpkg.com/is-regex/-/is-regex-1.2.1.tgz
https://registry.yarnpkg.com/is-regexp/-/is-regexp-1.0.0.tgz
https://registry.yarnpkg.com/is-set/-/is-set-2.0.3.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.3.tgz
https://registry.yarnpkg.com/is-shared-array-buffer/-/is-shared-array-buffer-1.0.4.tgz
https://registry.yarnpkg.com/is-stream/-/is-stream-2.0.0.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.0.7.tgz
https://registry.yarnpkg.com/is-string/-/is-string-1.1.1.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz
https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.1.1.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.10.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.13.tgz
https://registry.yarnpkg.com/is-typed-array/-/is-typed-array-1.1.15.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-1.3.0.tgz
https://registry.yarnpkg.com/is-unicode-supported/-/is-unicode-supported-2.1.0.tgz
https://registry.yarnpkg.com/is-weakmap/-/is-weakmap-2.0.2.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.0.2.tgz
https://registry.yarnpkg.com/is-weakref/-/is-weakref-1.1.1.tgz
https://registry.yarnpkg.com/is-weakset/-/is-weakset-2.0.4.tgz
https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz
https://registry.yarnpkg.com/isarray/-/isarray-2.0.5.tgz
https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz
https://registry.yarnpkg.com/isexe/-/isexe-3.1.1.tgz
https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz
https://registry.yarnpkg.com/jackspeak/-/jackspeak-3.4.3.tgz
https://registry.yarnpkg.com/jest-worker/-/jest-worker-27.5.1.tgz
https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.13.1.tgz
https://registry.yarnpkg.com/js-yaml/-/js-yaml-4.1.0.tgz
https://registry.yarnpkg.com/json-buffer/-/json-buffer-3.0.1.tgz
https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-2.3.1.tgz
https://registry.yarnpkg.com/json-parse-even-better-errors/-/json-parse-even-better-errors-3.0.2.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz
https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz
https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz
https://registry.yarnpkg.com/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz
https://registry.yarnpkg.com/json5/-/json5-1.0.2.tgz
https://registry.yarnpkg.com/json5/-/json5-2.2.3.tgz
https://registry.yarnpkg.com/jsonc-parser/-/jsonc-parser-3.3.1.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-4.0.0.tgz
https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.0.1.tgz
https://registry.yarnpkg.com/jsonwebtoken/-/jsonwebtoken-9.0.0.tgz
https://registry.yarnpkg.com/jsx-ast-utils/-/jsx-ast-utils-3.3.3.tgz
https://registry.yarnpkg.com/jwa/-/jwa-1.4.1.tgz
https://registry.yarnpkg.com/jws/-/jws-3.2.2.tgz
https://registry.yarnpkg.com/katex/-/katex-0.16.22.tgz
https://registry.yarnpkg.com/keyv/-/keyv-4.3.1.tgz
https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.3.tgz
https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz
https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.1.6.tgz
https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-2.0.4.tgz
https://registry.yarnpkg.com/linkify-it/-/linkify-it-5.0.0.tgz
https://registry.yarnpkg.com/lint-staged/-/lint-staged-10.2.11.tgz
https://registry.yarnpkg.com/listr2/-/listr2-2.2.0.tgz
https://registry.yarnpkg.com/load-json-file/-/load-json-file-5.3.0.tgz
https://registry.yarnpkg.com/load-plugin/-/load-plugin-6.0.3.tgz
https://registry.yarnpkg.com/loader-runner/-/loader-runner-4.3.0.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.4.2.tgz
https://registry.yarnpkg.com/loader-utils/-/loader-utils-2.0.4.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz
https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz
https://registry.yarnpkg.com/lodash.camelcase/-/lodash.camelcase-4.3.0.tgz
https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz
https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-4.0.0.tgz
https://registry.yarnpkg.com/log-symbols/-/log-symbols-6.0.0.tgz
https://registry.yarnpkg.com/log-update/-/log-update-4.0.0.tgz
https://registry.yarnpkg.com/longest-streak/-/longest-streak-3.0.0.tgz
https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz
https://registry.yarnpkg.com/loupe/-/loupe-3.1.1.tgz
https://registry.yarnpkg.com/lowercase-keys/-/lowercase-keys-2.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-10.2.2.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-10.4.3.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-6.0.0.tgz
https://registry.yarnpkg.com/lru-cache/-/lru-cache-9.1.1.tgz
https://registry.yarnpkg.com/make-error/-/make-error-1.3.5.tgz
https://registry.yarnpkg.com/markdown-extensions/-/markdown-extensions-2.0.0.tgz
https://registry.yarnpkg.com/markdown-it/-/markdown-it-14.1.0.tgz
https://registry.yarnpkg.com/markdownlint-cli2-formatter-default/-/markdownlint-cli2-formatter-default-0.0.5.tgz
https://registry.yarnpkg.com/markdownlint-cli2/-/markdownlint-cli2-0.18.0.tgz
https://registry.yarnpkg.com/markdownlint/-/markdownlint-0.38.0.tgz
https://registry.yarnpkg.com/matcher-collection/-/matcher-collection-1.1.2.tgz
https://registry.yarnpkg.com/matcher/-/matcher-3.0.0.tgz
https://registry.yarnpkg.com/math-intrinsics/-/math-intrinsics-1.1.0.tgz
https://registry.yarnpkg.com/mdast-comment-marker/-/mdast-comment-marker-1.1.1.tgz
https://registry.yarnpkg.com/mdast-util-from-markdown/-/mdast-util-from-markdown-2.0.1.tgz
https://registry.yarnpkg.com/mdast-util-from-markdown/-/mdast-util-from-markdown-2.0.2.tgz
https://registry.yarnpkg.com/mdast-util-heading-style/-/mdast-util-heading-style-1.0.5.tgz
https://registry.yarnpkg.com/mdast-util-phrasing/-/mdast-util-phrasing-4.1.0.tgz
https://registry.yarnpkg.com/mdast-util-to-markdown/-/mdast-util-to-markdown-2.1.0.tgz
https://registry.yarnpkg.com/mdast-util-to-string/-/mdast-util-to-string-1.0.6.tgz
https://registry.yarnpkg.com/mdast-util-to-string/-/mdast-util-to-string-4.0.0.tgz
https://registry.yarnpkg.com/mdurl/-/mdurl-2.0.0.tgz
https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.4.1.tgz
https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz
https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz
https://registry.yarnpkg.com/micromark-core-commonmark/-/micromark-core-commonmark-2.0.1.tgz
https://registry.yarnpkg.com/micromark-core-commonmark/-/micromark-core-commonmark-2.0.3.tgz
https://registry.yarnpkg.com/micromark-extension-directive/-/micromark-extension-directive-4.0.0.tgz
https://registry.yarnpkg.com/micromark-extension-gfm-autolink-literal/-/micromark-extension-gfm-autolink-literal-2.1.0.tgz
https://registry.yarnpkg.com/micromark-extension-gfm-footnote/-/micromark-extension-gfm-footnote-2.1.0.tgz
https://registry.yarnpkg.com/micromark-extension-gfm-table/-/micromark-extension-gfm-table-2.1.1.tgz
https://registry.yarnpkg.com/micromark-extension-math/-/micromark-extension-math-3.1.0.tgz
https://registry.yarnpkg.com/micromark-factory-destination/-/micromark-factory-destination-2.0.0.tgz
https://registry.yarnpkg.com/micromark-factory-label/-/micromark-factory-label-2.0.0.tgz
https://registry.yarnpkg.com/micromark-factory-space/-/micromark-factory-space-2.0.0.tgz
https://registry.yarnpkg.com/micromark-factory-title/-/micromark-factory-title-2.0.0.tgz
https://registry.yarnpkg.com/micromark-factory-whitespace/-/micromark-factory-whitespace-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-character/-/micromark-util-character-2.1.0.tgz
https://registry.yarnpkg.com/micromark-util-chunked/-/micromark-util-chunked-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-classify-character/-/micromark-util-classify-character-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-combine-extensions/-/micromark-util-combine-extensions-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-decode-numeric-character-reference/-/micromark-util-decode-numeric-character-reference-2.0.1.tgz
https://registry.yarnpkg.com/micromark-util-decode-string/-/micromark-util-decode-string-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-encode/-/micromark-util-encode-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-html-tag-name/-/micromark-util-html-tag-name-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-normalize-identifier/-/micromark-util-normalize-identifier-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-resolve-all/-/micromark-util-resolve-all-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-sanitize-uri/-/micromark-util-sanitize-uri-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-subtokenize/-/micromark-util-subtokenize-2.0.1.tgz
https://registry.yarnpkg.com/micromark-util-symbol/-/micromark-util-symbol-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-types/-/micromark-util-types-2.0.0.tgz
https://registry.yarnpkg.com/micromark-util-types/-/micromark-util-types-2.0.2.tgz
https://registry.yarnpkg.com/micromark/-/micromark-4.0.0.tgz
https://registry.yarnpkg.com/micromark/-/micromark-4.0.2.tgz
https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.8.tgz
https://registry.yarnpkg.com/mime-db/-/mime-db-1.52.0.tgz
https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.35.tgz
https://registry.yarnpkg.com/mimic-fn/-/mimic-fn-2.1.0.tgz
https://registry.yarnpkg.com/mimic-function/-/mimic-function-5.0.1.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-1.0.1.tgz
https://registry.yarnpkg.com/mimic-response/-/mimic-response-3.1.0.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.8.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-8.0.4.tgz
https://registry.yarnpkg.com/minimatch/-/minimatch-9.0.5.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.6.tgz
https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz
https://registry.yarnpkg.com/minipass/-/minipass-3.3.6.tgz
https://registry.yarnpkg.com/minipass/-/minipass-4.2.8.tgz
https://registry.yarnpkg.com/minipass/-/minipass-5.0.0.tgz
https://registry.yarnpkg.com/minipass/-/minipass-6.0.2.tgz
https://registry.yarnpkg.com/minipass/-/minipass-7.1.0.tgz
https://registry.yarnpkg.com/minipass/-/minipass-7.1.2.tgz
https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.2.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.5.tgz
https://registry.yarnpkg.com/mkdirp/-/mkdirp-1.0.4.tgz
https://registry.yarnpkg.com/ms/-/ms-2.1.3.tgz
https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz
https://registry.yarnpkg.com/neo-async/-/neo-async-2.6.2.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.6.7.tgz
https://registry.yarnpkg.com/node-fetch/-/node-fetch-2.6.8.tgz
https://registry.yarnpkg.com/node-releases/-/node-releases-2.0.18.tgz
https://registry.yarnpkg.com/nopt/-/nopt-7.2.1.tgz
https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-6.0.2.tgz
https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz
https://registry.yarnpkg.com/normalize-url/-/normalize-url-6.1.0.tgz
https://registry.yarnpkg.com/npm-install-checks/-/npm-install-checks-6.3.0.tgz
https://registry.yarnpkg.com/npm-normalize-package-bin/-/npm-normalize-package-bin-3.0.1.tgz
https://registry.yarnpkg.com/npm-package-arg/-/npm-package-arg-11.0.3.tgz
https://registry.yarnpkg.com/npm-pick-manifest/-/npm-pick-manifest-9.1.0.tgz
https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-4.0.1.tgz
https://registry.yarnpkg.com/null-loader/-/null-loader-4.0.1.tgz
https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.12.3.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.13.2.tgz
https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.13.4.tgz
https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.4.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.5.tgz
https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.7.tgz
https://registry.yarnpkg.com/object.entries/-/object.entries-1.1.6.tgz
https://registry.yarnpkg.com/object.fromentries/-/object.fromentries-2.0.6.tgz
https://registry.yarnpkg.com/object.fromentries/-/object.fromentries-2.0.8.tgz
https://registry.yarnpkg.com/object.groupby/-/object.groupby-1.0.3.tgz
https://registry.yarnpkg.com/object.hasown/-/object.hasown-1.1.2.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.1.6.tgz
https://registry.yarnpkg.com/object.values/-/object.values-1.2.1.tgz
https://registry.yarnpkg.com/once/-/once-1.4.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-5.1.0.tgz
https://registry.yarnpkg.com/onetime/-/onetime-7.0.0.tgz
https://registry.yarnpkg.com/optionator/-/optionator-0.9.4.tgz
https://registry.yarnpkg.com/ora/-/ora-8.1.0.tgz
https://registry.yarnpkg.com/own-keys/-/own-keys-1.0.1.tgz
https://registry.yarnpkg.com/p-cancelable/-/p-cancelable-2.1.1.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.2.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz
https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz
https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz
https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz
https://registry.yarnpkg.com/p-try/-/p-try-2.2.0.tgz
https://registry.yarnpkg.com/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz
https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz
https://registry.yarnpkg.com/parse-entities/-/parse-entities-4.0.2.tgz
https://registry.yarnpkg.com/parse-gitignore/-/parse-gitignore-0.4.0.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-4.0.0.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-5.0.0.tgz
https://registry.yarnpkg.com/parse-json/-/parse-json-7.1.1.tgz
https://registry.yarnpkg.com/parse-ms/-/parse-ms-4.0.0.tgz
https://registry.yarnpkg.com/parse5/-/parse5-7.1.2.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz
https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz
https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz
https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz
https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.7.tgz
https://registry.yarnpkg.com/path-scurry/-/path-scurry-1.11.1.tgz
https://registry.yarnpkg.com/path-scurry/-/path-scurry-1.9.2.tgz
https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz
https://registry.yarnpkg.com/path-type/-/path-type-6.0.0.tgz
https://registry.yarnpkg.com/pathval/-/pathval-2.0.0.tgz
https://registry.yarnpkg.com/pend/-/pend-1.2.0.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.1.0.tgz
https://registry.yarnpkg.com/picocolors/-/picocolors-1.1.1.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.0.7.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.2.2.tgz
https://registry.yarnpkg.com/picomatch/-/picomatch-2.3.1.tgz
https://registry.yarnpkg.com/pify/-/pify-4.0.1.tgz
https://registry.yarnpkg.com/pkg-conf/-/pkg-conf-3.1.0.tgz
https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz
https://registry.yarnpkg.com/please-upgrade-node/-/please-upgrade-node-3.2.0.tgz
https://registry.yarnpkg.com/pluralize/-/pluralize-8.0.0.tgz
https://registry.yarnpkg.com/possible-typed-array-names/-/possible-typed-array-names-1.0.0.tgz
https://registry.yarnpkg.com/pre-flight/-/pre-flight-2.0.0.tgz
https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz
https://registry.yarnpkg.com/pretty-ms/-/pretty-ms-9.1.0.tgz
https://registry.yarnpkg.com/proc-log/-/proc-log-4.2.0.tgz
https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.1.tgz
https://registry.yarnpkg.com/process/-/process-0.11.10.tgz
https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz
https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz
https://registry.yarnpkg.com/promise-retry/-/promise-retry-2.0.1.tgz
https://registry.yarnpkg.com/prop-types/-/prop-types-15.8.1.tgz
https://registry.yarnpkg.com/property-information/-/property-information-6.5.0.tgz
https://registry.yarnpkg.com/prr/-/prr-1.0.1.tgz
https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz
https://registry.yarnpkg.com/punycode.js/-/punycode.js-2.3.1.tgz
https://registry.yarnpkg.com/punycode/-/punycode-1.4.1.tgz
https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz
https://registry.yarnpkg.com/qs/-/qs-6.13.0.tgz
https://registry.yarnpkg.com/quick-lru/-/quick-lru-5.1.1.tgz
https://registry.yarnpkg.com/rambda/-/rambda-7.5.0.tgz
https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz
https://registry.yarnpkg.com/react-is/-/react-is-16.13.1.tgz
https://registry.yarnpkg.com/read-package-json-fast/-/read-package-json-fast-3.0.2.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.6.tgz
https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.6.0.tgz
https://registry.yarnpkg.com/readdirp/-/readdirp-3.6.0.tgz
https://registry.yarnpkg.com/rechoir/-/rechoir-0.6.2.tgz
https://registry.yarnpkg.com/rechoir/-/rechoir-0.8.0.tgz
https://registry.yarnpkg.com/reflect.getprototypeof/-/reflect.getprototypeof-1.0.10.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.5.0.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.5.2.tgz
https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.5.4.tgz
https://registry.yarnpkg.com/regexpp/-/regexpp-3.0.0.tgz
https://registry.yarnpkg.com/remark-cli/-/remark-cli-12.0.1.tgz
https://registry.yarnpkg.com/remark-lint-blockquote-indentation/-/remark-lint-blockquote-indentation-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-code-block-style/-/remark-lint-code-block-style-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-definition-case/-/remark-lint-definition-case-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-definition-spacing/-/remark-lint-definition-spacing-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-emphasis-marker/-/remark-lint-emphasis-marker-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-fenced-code-flag/-/remark-lint-fenced-code-flag-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-fenced-code-marker/-/remark-lint-fenced-code-marker-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-file-extension/-/remark-lint-file-extension-1.0.3.tgz
https://registry.yarnpkg.com/remark-lint-final-definition/-/remark-lint-final-definition-2.1.0.tgz
https://registry.yarnpkg.com/remark-lint-hard-break-spaces/-/remark-lint-hard-break-spaces-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-heading-increment/-/remark-lint-heading-increment-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-heading-style/-/remark-lint-heading-style-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-link-title-style/-/remark-lint-link-title-style-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-list-item-content-indent/-/remark-lint-list-item-content-indent-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-list-item-indent/-/remark-lint-list-item-indent-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-list-item-spacing/-/remark-lint-list-item-spacing-3.0.0.tgz
https://registry.yarnpkg.com/remark-lint-maximum-heading-length/-/remark-lint-maximum-heading-length-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-maximum-line-length/-/remark-lint-maximum-line-length-2.0.3.tgz
https://registry.yarnpkg.com/remark-lint-no-auto-link-without-protocol/-/remark-lint-no-auto-link-without-protocol-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-no-blockquote-without-marker/-/remark-lint-no-blockquote-without-marker-4.0.0.tgz
https://registry.yarnpkg.com/remark-lint-no-consecutive-blank-lines/-/remark-lint-no-consecutive-blank-lines-3.0.0.tgz
https://registry.yarnpkg.com/remark-lint-no-duplicate-headings/-/remark-lint-no-duplicate-headings-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-no-emphasis-as-heading/-/remark-lint-no-emphasis-as-heading-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-no-file-name-articles/-/remark-lint-no-file-name-articles-1.0.3.tgz
https://registry.yarnpkg.com/remark-lint-no-file-name-consecutive-dashes/-/remark-lint-no-file-name-consecutive-dashes-1.0.3.tgz
https://registry.yarnpkg.com/remark-lint-no-file-name-irregular-characters/-/remark-lint-no-file-name-irregular-characters-1.0.3.tgz
https://registry.yarnpkg.com/remark-lint-no-file-name-mixed-case/-/remark-lint-no-file-name-mixed-case-1.0.3.tgz
https://registry.yarnpkg.com/remark-lint-no-file-name-outer-dashes/-/remark-lint-no-file-name-outer-dashes-1.0.4.tgz
https://registry.yarnpkg.com/remark-lint-no-heading-punctuation/-/remark-lint-no-heading-punctuation-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-no-inline-padding/-/remark-lint-no-inline-padding-3.0.0.tgz
https://registry.yarnpkg.com/remark-lint-no-literal-urls/-/remark-lint-no-literal-urls-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-no-multiple-toplevel-headings/-/remark-lint-no-multiple-toplevel-headings-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-no-shell-dollars/-/remark-lint-no-shell-dollars-2.0.2.tgz
https://registry.yarnpkg.com/remark-lint-no-shortcut-reference-image/-/remark-lint-no-shortcut-reference-image-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-no-shortcut-reference-link/-/remark-lint-no-shortcut-reference-link-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-no-table-indentation/-/remark-lint-no-table-indentation-3.0.0.tgz
https://registry.yarnpkg.com/remark-lint-ordered-list-marker-style/-/remark-lint-ordered-list-marker-style-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-ordered-list-marker-value/-/remark-lint-ordered-list-marker-value-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-rule-style/-/remark-lint-rule-style-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-strong-marker/-/remark-lint-strong-marker-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-table-cell-padding/-/remark-lint-table-cell-padding-3.0.0.tgz
https://registry.yarnpkg.com/remark-lint-table-pipe-alignment/-/remark-lint-table-pipe-alignment-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint-table-pipes/-/remark-lint-table-pipes-3.0.0.tgz
https://registry.yarnpkg.com/remark-lint-unordered-list-marker-style/-/remark-lint-unordered-list-marker-style-2.0.1.tgz
https://registry.yarnpkg.com/remark-lint/-/remark-lint-8.0.0.tgz
https://registry.yarnpkg.com/remark-message-control/-/remark-message-control-6.0.0.tgz
https://registry.yarnpkg.com/remark-parse/-/remark-parse-11.0.0.tgz
https://registry.yarnpkg.com/remark-preset-lint-markdown-style-guide/-/remark-preset-lint-markdown-style-guide-4.0.0.tgz
https://registry.yarnpkg.com/remark-stringify/-/remark-stringify-11.0.0.tgz
https://registry.yarnpkg.com/remark/-/remark-15.0.1.tgz
https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz
https://registry.yarnpkg.com/resolve-alpn/-/resolve-alpn-1.2.1.tgz
https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-3.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz
https://registry.yarnpkg.com/resolve-from/-/resolve-from-5.0.0.tgz
https://registry.yarnpkg.com/resolve-pkg-maps/-/resolve-pkg-maps-1.0.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.17.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.21.0.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.2.tgz
https://registry.yarnpkg.com/resolve/-/resolve-1.22.8.tgz
https://registry.yarnpkg.com/resolve/-/resolve-2.0.0-next.4.tgz
https://registry.yarnpkg.com/responselike/-/responselike-2.0.0.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-3.1.0.tgz
https://registry.yarnpkg.com/restore-cursor/-/restore-cursor-5.1.0.tgz
https://registry.yarnpkg.com/retry/-/retry-0.12.0.tgz
https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-2.6.3.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz
https://registry.yarnpkg.com/rimraf/-/rimraf-4.4.1.tgz
https://registry.yarnpkg.com/roarr/-/roarr-2.15.4.tgz
https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.1.9.tgz
https://registry.yarnpkg.com/rxjs/-/rxjs-6.6.0.tgz
https://registry.yarnpkg.com/safe-array-concat/-/safe-array-concat-1.1.2.tgz
https://registry.yarnpkg.com/safe-array-concat/-/safe-array-concat-1.1.3.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz
https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.2.1.tgz
https://registry.yarnpkg.com/safe-push-apply/-/safe-push-apply-1.0.0.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.0.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.0.3.tgz
https://registry.yarnpkg.com/safe-regex-test/-/safe-regex-test-1.1.0.tgz
https://registry.yarnpkg.com/schema-utils/-/schema-utils-3.3.0.tgz
https://registry.yarnpkg.com/semver-compare/-/semver-compare-1.0.0.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.1.tgz
https://registry.yarnpkg.com/semver/-/semver-7.5.2.tgz
https://registry.yarnpkg.com/semver/-/semver-7.6.3.tgz
https://registry.yarnpkg.com/serialize-error/-/serialize-error-7.0.1.tgz
https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-6.0.2.tgz
https://registry.yarnpkg.com/set-function-length/-/set-function-length-1.2.2.tgz
https://registry.yarnpkg.com/set-function-name/-/set-function-name-2.0.2.tgz
https://registry.yarnpkg.com/set-proto/-/set-proto-1.0.0.tgz
https://registry.yarnpkg.com/shallow-clone/-/shallow-clone-3.0.1.tgz
https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz
https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz
https://registry.yarnpkg.com/shelljs/-/shelljs-0.8.5.tgz
https://registry.yarnpkg.com/shx/-/shx-0.3.4.tgz
https://registry.yarnpkg.com/side-channel-list/-/side-channel-list-1.0.0.tgz
https://registry.yarnpkg.com/side-channel-map/-/side-channel-map-1.0.1.tgz
https://registry.yarnpkg.com/side-channel-weakmap/-/side-channel-weakmap-1.0.2.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.6.tgz
https://registry.yarnpkg.com/side-channel/-/side-channel-1.1.0.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.3.tgz
https://registry.yarnpkg.com/signal-exit/-/signal-exit-4.1.0.tgz
https://registry.yarnpkg.com/simple-git/-/simple-git-3.16.0.tgz
https://registry.yarnpkg.com/slash/-/slash-5.1.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-3.0.0.tgz
https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-4.0.0.tgz
https://registry.yarnpkg.com/sliced/-/sliced-1.0.1.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.19.tgz
https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.21.tgz
https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz
https://registry.yarnpkg.com/space-separated-tokens/-/space-separated-tokens-2.0.2.tgz
https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.2.0.tgz
https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz
https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz
https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.13.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz
https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.1.2.tgz
https://registry.yarnpkg.com/standard-engine/-/standard-engine-15.0.0.tgz
https://registry.yarnpkg.com/standard/-/standard-17.0.0.tgz
https://registry.yarnpkg.com/stdin-discarder/-/stdin-discarder-0.2.2.tgz
https://registry.yarnpkg.com/stop-iteration-iterator/-/stop-iteration-iterator-1.1.0.tgz
https://registry.yarnpkg.com/stream-chain/-/stream-chain-2.2.5.tgz
https://registry.yarnpkg.com/stream-json/-/stream-json-1.8.0.tgz
https://registry.yarnpkg.com/string-argv/-/string-argv-0.3.1.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-4.2.3.tgz
https://registry.yarnpkg.com/string-width/-/string-width-5.1.2.tgz
https://registry.yarnpkg.com/string-width/-/string-width-6.1.0.tgz
https://registry.yarnpkg.com/string-width/-/string-width-7.2.0.tgz
https://registry.yarnpkg.com/string.prototype.matchall/-/string.prototype.matchall-4.0.8.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.10.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.7.tgz
https://registry.yarnpkg.com/string.prototype.trim/-/string.prototype.trim-1.2.9.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.8.tgz
https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.9.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.6.tgz
https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.8.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz
https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.3.0.tgz
https://registry.yarnpkg.com/stringify-object/-/stringify-object-3.3.0.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.1.tgz
https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-7.1.0.tgz
https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz
https://registry.yarnpkg.com/strip-final-newline/-/strip-final-newline-2.0.0.tgz
https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz
https://registry.yarnpkg.com/strnum/-/strnum-1.0.5.tgz
https://registry.yarnpkg.com/sumchecker/-/sumchecker-3.0.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-7.1.0.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-8.1.1.tgz
https://registry.yarnpkg.com/supports-color/-/supports-color-9.0.2.tgz
https://registry.yarnpkg.com/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz
https://registry.yarnpkg.com/tap-parser/-/tap-parser-1.2.2.tgz
https://registry.yarnpkg.com/tap-xunit/-/tap-xunit-2.4.1.tgz
https://registry.yarnpkg.com/tapable/-/tapable-1.1.3.tgz
https://registry.yarnpkg.com/tapable/-/tapable-2.2.1.tgz
https://registry.yarnpkg.com/tar/-/tar-6.2.1.tgz
https://registry.yarnpkg.com/temp/-/temp-0.9.4.tgz
https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-5.3.10.tgz
https://registry.yarnpkg.com/terser/-/terser-5.32.0.tgz
https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz
https://registry.yarnpkg.com/through/-/through-2.3.8.tgz
https://registry.yarnpkg.com/through2/-/through2-2.0.5.tgz
https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-1.4.2.tgz
https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz
https://registry.yarnpkg.com/tr46/-/tr46-0.0.3.tgz
https://registry.yarnpkg.com/trough/-/trough-2.0.2.tgz
https://registry.yarnpkg.com/ts-api-utils/-/ts-api-utils-1.3.0.tgz
https://registry.yarnpkg.com/ts-loader/-/ts-loader-8.0.2.tgz
https://registry.yarnpkg.com/ts-node/-/ts-node-6.2.0.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.14.2.tgz
https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.15.0.tgz
https://registry.yarnpkg.com/tslib/-/tslib-1.10.0.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.3.1.tgz
https://registry.yarnpkg.com/tslib/-/tslib-2.7.0.tgz
https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.11.0.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.13.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-0.3.1.tgz
https://registry.yarnpkg.com/type-fest/-/type-fest-3.13.1.tgz
https://registry.yarnpkg.com/typed-array-buffer/-/typed-array-buffer-1.0.2.tgz
https://registry.yarnpkg.com/typed-array-buffer/-/typed-array-buffer-1.0.3.tgz
https://registry.yarnpkg.com/typed-array-byte-length/-/typed-array-byte-length-1.0.1.tgz
https://registry.yarnpkg.com/typed-array-byte-length/-/typed-array-byte-length-1.0.3.tgz
https://registry.yarnpkg.com/typed-array-byte-offset/-/typed-array-byte-offset-1.0.2.tgz
https://registry.yarnpkg.com/typed-array-byte-offset/-/typed-array-byte-offset-1.0.4.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.4.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.6.tgz
https://registry.yarnpkg.com/typed-array-length/-/typed-array-length-1.0.7.tgz
https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz
https://registry.yarnpkg.com/typescript/-/typescript-5.6.2.tgz
https://registry.yarnpkg.com/uc.micro/-/uc.micro-2.1.0.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.2.tgz
https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.1.0.tgz
https://registry.yarnpkg.com/undici-types/-/undici-types-6.19.8.tgz
https://registry.yarnpkg.com/unicorn-magic/-/unicorn-magic-0.3.0.tgz
https://registry.yarnpkg.com/unified-args/-/unified-args-11.0.1.tgz
https://registry.yarnpkg.com/unified-engine/-/unified-engine-11.2.1.tgz
https://registry.yarnpkg.com/unified-lint-rule/-/unified-lint-rule-1.0.4.tgz
https://registry.yarnpkg.com/unified-message-control/-/unified-message-control-3.0.3.tgz
https://registry.yarnpkg.com/unified/-/unified-11.0.5.tgz
https://registry.yarnpkg.com/unist-util-generated/-/unist-util-generated-1.1.4.tgz
https://registry.yarnpkg.com/unist-util-generated/-/unist-util-generated-1.1.6.tgz
https://registry.yarnpkg.com/unist-util-inspect/-/unist-util-inspect-8.1.0.tgz
https://registry.yarnpkg.com/unist-util-is/-/unist-util-is-4.1.0.tgz
https://registry.yarnpkg.com/unist-util-is/-/unist-util-is-6.0.0.tgz
https://registry.yarnpkg.com/unist-util-position/-/unist-util-position-3.0.3.tgz
https://registry.yarnpkg.com/unist-util-stringify-position/-/unist-util-stringify-position-2.0.1.tgz
https://registry.yarnpkg.com/unist-util-stringify-position/-/unist-util-stringify-position-4.0.0.tgz
https://registry.yarnpkg.com/unist-util-visit-parents/-/unist-util-visit-parents-3.1.1.tgz
https://registry.yarnpkg.com/unist-util-visit-parents/-/unist-util-visit-parents-6.0.1.tgz
https://registry.yarnpkg.com/unist-util-visit/-/unist-util-visit-2.0.3.tgz
https://registry.yarnpkg.com/unist-util-visit/-/unist-util-visit-5.0.0.tgz
https://registry.yarnpkg.com/universal-github-app-jwt/-/universal-github-app-jwt-1.1.1.tgz
https://registry.yarnpkg.com/universal-user-agent/-/universal-user-agent-6.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-0.1.2.tgz
https://registry.yarnpkg.com/universalify/-/universalify-1.0.0.tgz
https://registry.yarnpkg.com/universalify/-/universalify-2.0.0.tgz
https://registry.yarnpkg.com/update-browserslist-db/-/update-browserslist-db-1.1.0.tgz
https://registry.yarnpkg.com/uri-js/-/uri-js-4.4.1.tgz
https://registry.yarnpkg.com/url/-/url-0.11.4.tgz
https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz
https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz
https://registry.yarnpkg.com/validate-npm-package-name/-/validate-npm-package-name-5.0.1.tgz
https://registry.yarnpkg.com/vfile-location/-/vfile-location-3.2.0.tgz
https://registry.yarnpkg.com/vfile-location/-/vfile-location-5.0.3.tgz
https://registry.yarnpkg.com/vfile-message/-/vfile-message-4.0.2.tgz
https://registry.yarnpkg.com/vfile-reporter/-/vfile-reporter-8.1.1.tgz
https://registry.yarnpkg.com/vfile-sort/-/vfile-sort-4.0.0.tgz
https://registry.yarnpkg.com/vfile-statistics/-/vfile-statistics-3.0.0.tgz
https://registry.yarnpkg.com/vfile/-/vfile-6.0.2.tgz
https://registry.yarnpkg.com/vscode-jsonrpc/-/vscode-jsonrpc-8.1.0.tgz
https://registry.yarnpkg.com/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.3.tgz
https://registry.yarnpkg.com/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.7.tgz
https://registry.yarnpkg.com/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.8.tgz
https://registry.yarnpkg.com/vscode-languageserver-types/-/vscode-languageserver-types-3.17.2.tgz
https://registry.yarnpkg.com/vscode-languageserver-types/-/vscode-languageserver-types-3.17.3.tgz
https://registry.yarnpkg.com/vscode-languageserver/-/vscode-languageserver-8.1.0.tgz
https://registry.yarnpkg.com/vscode-uri/-/vscode-uri-3.0.6.tgz
https://registry.yarnpkg.com/vscode-uri/-/vscode-uri-3.1.0.tgz
https://registry.yarnpkg.com/walk-sync/-/walk-sync-0.3.4.tgz
https://registry.yarnpkg.com/walk-up-path/-/walk-up-path-3.0.1.tgz
https://registry.yarnpkg.com/watchpack/-/watchpack-2.4.2.tgz
https://registry.yarnpkg.com/web-namespaces/-/web-namespaces-2.0.1.tgz
https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-3.0.1.tgz
https://registry.yarnpkg.com/webpack-cli/-/webpack-cli-5.1.4.tgz
https://registry.yarnpkg.com/webpack-merge/-/webpack-merge-5.8.0.tgz
https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-3.2.3.tgz
https://registry.yarnpkg.com/webpack/-/webpack-5.95.0.tgz
https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-5.0.0.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz
https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.1.1.tgz
https://registry.yarnpkg.com/which-builtin-type/-/which-builtin-type-1.2.1.tgz
https://registry.yarnpkg.com/which-collection/-/which-collection-1.0.2.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.15.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.19.tgz
https://registry.yarnpkg.com/which-typed-array/-/which-typed-array-1.1.9.tgz
https://registry.yarnpkg.com/which/-/which-2.0.2.tgz
https://registry.yarnpkg.com/which/-/which-4.0.0.tgz
https://registry.yarnpkg.com/wildcard/-/wildcard-2.0.0.tgz
https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.5.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-6.2.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-7.0.0.tgz
https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-8.1.0.tgz
https://registry.yarnpkg.com/wrapped/-/wrapped-1.0.1.tgz
https://registry.yarnpkg.com/wrapper-webpack-plugin/-/wrapper-webpack-plugin-2.2.2.tgz
https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz
https://registry.yarnpkg.com/xdg-basedir/-/xdg-basedir-4.0.0.tgz
https://registry.yarnpkg.com/xmlbuilder/-/xmlbuilder-4.2.1.tgz
https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz
https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz
https://registry.yarnpkg.com/yaml/-/yaml-1.10.0.tgz
https://registry.yarnpkg.com/yaml/-/yaml-2.4.5.tgz
https://registry.yarnpkg.com/yaml/-/yaml-2.6.0.tgz
https://registry.yarnpkg.com/yauzl/-/yauzl-2.10.0.tgz
https://registry.yarnpkg.com/yn/-/yn-2.0.0.tgz
https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz
https://registry.yarnpkg.com/zwitch/-/zwitch-2.0.2.tgz
"

CHROMIUM_P="chromium-${CHROMIUM_VERSION}"
NODE_P="node-${NODE_VERSION}"
PATCH_V="${CHROMIUM_VERSION%%\.*}-2"
PATCHSET_NAME="chromium-patches-${PATCH_V}"
PPC64_HASH="01dda910156deccddab855e2b6adaea2c751ae45"
PATCHSET_LOONG_PV="134.0.6998.39"
PATCHSET_LOONG="chromium-${PATCHSET_LOONG_PV}-1"

#Official tarball: https://commondatastorage.googleapis.com/chromium-browser-official/${CHROMIUM_P}.tar.xz
SRC_URI="
	https://github.com/chromium-linux-tarballs/chromium-tarballs/releases/download/${CHROMIUM_VERSION}/chromium-${CHROMIUM_VERSION}-linux.tar.xz
	https://gitlab.com/Matt.Jolly/chromium-patches/-/archive/${PATCH_V}/${PATCHSET_NAME}.tar.bz2
	https://github.com/electron/electron/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/nodejs/node/archive/v${NODE_VERSION}.tar.gz -> electron-${NODE_P}.tar.gz
	loong? (
		https://github.com/AOSC-Dev/chromium-loongarch64/archive/refs/tags/${PATCHSET_LOONG}.tar.gz -> chromium-loongarch64-aosc-patches-${PATCHSET_LOONG}.tar.gz
	)
	ppc64? (
		https://gitlab.raptorengineering.com/raptor-engineering-public/chromium/openpower-patches/-/archive/${PPC64_HASH}/openpower-patches-${PPC64_HASH}.tar.bz2 -> chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	)
	https://codeload.github.com/nodejs/nan/tar.gz/e14bdcd1f72d62bca1d541b66da43130384ec213
	$(yarn_uris ${YARNPKGS})
"

S="${WORKDIR}/${CHROMIUM_P}"
NODE_S="${S}/third_party/electron_node"

LICENSE="BSD"
SLOT="${PV%%[.+]*}"
KEYWORDS="~amd64 ~arm64 ~loong"
IUSE_SYSTEM_LIBS="+system-harfbuzz +system-icu +system-png"
IUSE="hevc +X custom-cflags ${IUSE_SYSTEM_LIBS} bindist cups debug ffmpeg-chromium headless kerberos +official pax-kernel pgo +proprietary-codecs pulseaudio"
IUSE+=" +screencast selinux +vaapi +wayland cpu_flags_ppc_vsx3"
RESTRICT="
	!bindist? ( bindist )
"

REQUIRED_USE="
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
	>=net-libs/nodejs-22.11.0[inspector]
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
	sys-apps/yarn
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
	unpack "${CHROMIUM_P}-linux.tar.xz"
	unpack ${P}.tar.gz
	unpack "electron-${NODE_P}.tar.gz"
	unpack "${PATCHSET_NAME}.tar.bz2"
	if use ppc64; then
		unpack chromium-openpower-${PPC64_HASH:0:10}.tar.bz2
	fi
	use loong && unpack "chromium-loongarch64-aosc-patches-${PATCHSET_LOONG}.tar.gz"
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup

	# Electron's scripts expect the top dir to be called src/"
	ln -s "${S}" "${WORKDIR}/src" || die
	mv "${WORKDIR}/${NODE_P}/" "${NODE_S}/" || die
	mv "${WORKDIR}/${P}" "${S}/electron" || die

	eapply "${FILESDIR}/${SLOT}/chromium/"
	use elibc_musl && eapply "${FILESDIR}/${SLOT}/musl/"
	if tc-is-clang && ( has_version "llvm-core/clang-common[default-compiler-rt]" || is-flagq -rtlib=compiler-rt ); then
		eapply "${FILESDIR}/${SLOT}/remove-libatomic.patch"
	fi

	shopt -s globstar nullglob
	# 130: moved the PPC64 patches into the chromium-patches repo
	local patch
	for patch in "${WORKDIR}/chromium-patches-${PATCH_V}"/**/*.patch; do
			if [[ ${patch} == *"ppc64le"* ]]; then
					use ppc64 && PATCHES+=( "${patch}" )
			#   else
					#PATCHES+=( "${patch}" )
			fi
	done
	shopt -u globstar nullglob

	# We can't use the bundled compiler builtins with the system toolchain
	# `grep` is a development convenience to ensure we fail early when google changes something.
	local builtins_match="if (is_clang && !is_nacl && !is_cronet_build) {"
	grep -q "${builtins_match}" build/config/compiler/BUILD.gn || die "Failed to disable bundled compiler builtins"
	sed -i -e "/${builtins_match}/,+2d" build/config/compiler/BUILD.gn

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

	# Oxidised hacks, let's keep 'em all in one place
	# This is a nightly option that does not exist in older releases
	# https://github.com/rust-lang/rust/commit/389a399a501a626ebf891ae0bb076c25e325ae64
	if ver_test ${RUST_SLOT} -lt "1.83.0"; then
		sed '/rustflags = \[ "-Zdefault-visibility=hidden" \]/d' -i build/config/gcc/BUILD.gn ||
			die "Failed to remove default visibility nightly option"
	fi

	cd "${S}/electron" || die
	echo "yarn-offline-mirror \"${DISTDIR}\"" >> "${S}/electron/.yarnrc"

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

	# Upstream Rust replaced adler with adler2, for older versions of Rust we still need
	# to tell GN that we have the older lib when it tries to copy the Rust sysroot
	# into the bulid directory.
	if ver_test ${RUST_SLOT} -lt "1.86.0"; then
		sed -i 's/adler2/adler/' build/rust/std/BUILD.gn ||
			die "Failed to tell GN that we have adler and not adler2"
	fi

	if ver_test ${RUST_SLOT} -gt "1.86.0"; then
			eapply "${FILESDIR}/${SLOT}"/fix-rust-allocator-shim.patch
			eapply "${FILESDIR}/${SLOT}"/fix-rust-allocator-shim2.patch
			eapply "${FILESDIR}/${SLOT}"/fix-rust-allocator-shim3.patch
			eapply "${FILESDIR}/${SLOT}"/fix-rust-allocator-shim4.patch
	fi
	if ver_test ${RUST_SLOT} -ge "1.89.0"; then
			eapply "${FILESDIR}/${SLOT}"/fix-rust-allocator-shim5.patch
			eapply "${FILESDIR}/${SLOT}"/fix-rust-warning.patch
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
	yarn install --ignore-optional --frozen-lockfile --offline \
		--ignore-scripts --no-progress --verbose || die

	cd "${S}" || die

	default

	if [[ ${LLVM_SLOT} == "19" ]]; then
		# Upstream now hard depend on a feature that was added in LLVM 20.1, but we don't want to stabilise that yet.
		# Do the temp file shuffle in case someone is using something other than `gawk`
		{
			awk '/config\("clang_warning_suppression"\) \{/	{ print $0 " }"; sub(/clang/, "xclang"); print; next }
				{ print }' build/config/compiler/BUILD.gn > "${T}/build.gn" && \
				mv "${T}/build.gn" build/config/compiler/BUILD.gn
		} || die "Unable to disable warning suppression"
	fi

	# Not included in -lite tarballs, but we should check for it anyway.
	if [[ -f third_party/node/linux/node-linux-x64/bin/node ]]; then
		rm third_party/node/linux/node-linux-x64/bin/node || die
	else
		mkdir -p third_party/node/linux/node-linux-x64/bin || die
	fi
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die

	# adjust python interpreter version
	sed -i -e "s|\(^script_executable = \).*|\1\"${EPYTHON}\"|g" .gn || die

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
		chrome/third_party/mozilla_security_manager
		net/third_party/mozilla_security_manager
		net/third_party/nss
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
		third_party/devtools-frontend/src/front_end/third_party/third-party-web
		third_party/devtools-frontend/src/front_end/third_party/vscode.web-custom-data
		third_party/devtools-frontend/src/front_end/third_party/wasmparser
		third_party/devtools-frontend/src/front_end/third_party/web-vitals
		third_party/devtools-frontend/src/third_party
		third_party/distributed_point_functions
		third_party/dom_distiller_js
		third_party/eigen3
		third_party/emoji-segmenter
		third_party/farmhash
		third_party/fast_float
		third_party/fdlibm
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
		third_party/mesa
		third_party/metrics_proto
		third_party/minigbm
		third_party/modp_b64
		third_party/nasm
		third_party/nearby
		third_party/neon_2_sse
		third_party/node
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
		third_party/tflite/src/third_party/eigen3
		third_party/tflite/src/third_party/fft2d
		third_party/tflite/src/third_party/xla/third_party/tsl
		third_party/tflite/src/third_party/xla/xla/tsl/framework
		third_party/tflite/src/third_party/xla/xla/tsl/lib/random
		third_party/tflite/src/third_party/xla/xla/tsl/protobuf
		third_party/tflite/src/third_party/xla/xla/tsl/util
		third_party/ukey2
		third_party/unrar
		third_party/utf
		third_party/vulkan
		third_party/wasm_tts_engine
		third_party/wayland
		third_party/webdriver
		third_party/webgpu-cts
		third_party/webrtc
		third_party/webrtc/common_audio/third_party/ooura
		third_party/webrtc/common_audio/third_party/spl_sqrt_floor
		third_party/webrtc/modules/third_party/fft
		third_party/webrtc/modules/third_party/g711
		third_party/webrtc/modules/third_party/g722
		third_party/webrtc/rtc_base/third_party/base64
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
		v8/third_party/siphash
		v8/third_party/utf8-decoder
		v8/third_party/glibc
		v8/third_party/inspector_protocol
		v8/third_party/rapidhash-v8
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

	local myconf_gn=""

	# We already forced the "correct" clang via pkg_setup

	if tc-is-cross-compiler; then
		CC="${CC} -target ${CHOST} --sysroot ${ESYSROOT}"
		CXX="${CXX} -target ${CHOST} --sysroot ${ESYSROOT}"
		BUILD_AR=${AR}
		BUILD_CC=${CC}
		BUILD_CXX=${CXX}
		BUILD_NM=${NM}
	fi

	strip-unsupported-flags

	myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	# https://bugs.gentoo.org/918897#c32
	append-ldflags -Wl,--undefined-version
	myconf_gn+=" use_lld=true"

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM

	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-cross-compiler; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" pkg_config=\"$(tc-getPKG_CONFIG)\""
		myconf_gn+=" host_pkg_config=\"$(tc-getBUILD_PKG_CONFIG)\""

		# setup cups-config, build system only uses --libs option
		if use cups; then
			mkdir "${T}/cups-config" || die
			cp "${ESYSROOT}/usr/bin/${CHOST}-cups-config" "${T}/cups-config/cups-config" || die
			export PATH="${PATH}:${T}/cups-config"
		fi

		# Don't inherit PKG_CONFIG_PATH from environment
		local -x PKG_CONFIG_PATH=
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

	# bindgen settings
	# From 127, to make bindgen work, we need to provide a location for libclang.
	# We patch this in for gentoo - see chromium-*-bindgen-custom-toolchain.patch
	# rust_bindgen_root = directory with `bin/bindgen` beneath it.
	myconf_gn+=" rust_bindgen_root=\"${EPREFIX}/usr/\""

	myconf_gn+=" bindgen_libclang_path=\"$(get_llvm_prefix)/$(get_libdir)\""
	# We don't need to set 'clang_base_bath' for anything in our build
	# and it defaults to the google toolchain location. Instead provide a location
	# to where system clang lives sot that bindgen can find system headers (e.g. stddef.h)
	myconf_gn+=" clang_base_path=\"${EPREFIX}/usr/lib/clang/${LLVM_SLOT}/\""

	myconf_gn+=" rust_sysroot_absolute=\"$(get_rust_prefix)\""
	myconf_gn+=" rustc_version=\"${RUST_SLOT}\""
	use elibc_musl && myconf_gn+=" rust_abi_target=\"$(rust_abi)\""

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	# enable DCHECK with USE=debug only, increases chrome binary size by 30%, bug #811138.
	# DCHECK is fatal by default, make it configurable at runtime, #bug 807881.
	myconf_gn+=" dcheck_always_on=$(usex debug true false)"
	myconf_gn+=" dcheck_is_configurable=$(usex debug true false)"

	# Component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
	myconf_gn+=" is_component_build=false"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

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

	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" || die

	# TODO 131: The above call clobbers `enable_freetype = true` in the freetype gni file
	# drop the last line, then append the freetype line and a new curly brace to end the block
	local freetype_gni="build/config/freetype/freetype.gni"
	sed -i -e '$d' ${freetype_gni} || die
	echo "  enable_freetype = true" >> ${freetype_gni} || die
	echo "}" >> ${freetype_gni} || die

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=$(usex system-harfbuzz true false)"

	if use headless; then
		myconf_gn+=" use_cups=false"
		myconf_gn+=" use_kerberos=false"
		myconf_gn+=" use_pulseaudio=false"
		myconf_gn+=" use_vaapi=false"
		myconf_gn+=" rtc_use_pipewire=false"
	else
		myconf_gn+=" use_cups=$(usex cups true false)"
		myconf_gn+=" use_kerberos=$(usex kerberos true false)"
		myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"
		myconf_gn+=" use_vaapi=$(usex vaapi true false)"
		myconf_gn+=" rtc_use_pipewire=$(usex screencast true false)"
		myconf_gn+=" gtk_version=3"
	fi

	# Allows distributions to link pulseaudio directly (DT_NEEDED) instead of
	# using dlopen. This helps with automated detection of ABI mismatches and
	# prevents silent errors.
	if use pulseaudio; then
		myconf_gn+=" link_pulseaudio=true"
	fi

	if use hevc; then
		myconf_gn+=" media_use_ffmpeg=true enable_platform_hevc=true enable_hevc_parser_and_hw_decoder=true"
	fi

	# Non-developer builds of Chromium (for example, non-Chrome browsers, or
	# Chromium builds provided by Linux distros) should disable the testing config
	myconf_gn+=" disable_fieldtrial_testing_config=true"

	# The sysroot is the oldest debian image that chromium supports, we don't need it
	myconf_gn+=" use_sysroot=false"

	# Use in-tree libc++ (buildtools/third_party/libc++ and buildtools/third_party/libc++abi)
	# instead of the system C++ library for C++ standard library support.
	# default: true, but let's be explicit (forced since 120 ; USE removed 127).
	myconf_gn+=" use_custom_libcxx=true"

	if use pgo; then
		myconf_gn+=" chrome_pgo_phase=2"
	else
		myconf_gn+=" chrome_pgo_phase=0"
	fi

	# Disable pseudolocales, only used for testing
	myconf_gn+=" enable_pseudolocales=false"

	# Disable code formating of generated files
	myconf_gn+=" blink_enable_generated_code_formatting=false"

	if use bindist ; then
		# proprietary_codecs just forces Chromium to say that it can use h264/aac,
		# the work is still done by ffmpeg. If this is set to no Chromium
		# won't be able to load the codec even if the library can handle it
		myconf_gn+=" proprietary_codecs=true"
		myconf_gn+=" ffmpeg_branding=\"Chrome\""
		# build ffmpeg as an external component (libffmpeg.so) that we can remove / substitute
		myconf_gn+=" is_component_ffmpeg=true"
	else
		ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
		myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
		myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""
	fi

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
	# Note: these are for Gentoo use ONLY. For your own distribution,
	# please get your own set of keys. Feel free to contact chromium@gentoo.org
	# for more info. The OAuth2 credentials, however, have been left out.
	# Those OAuth2 credentials have been broken for quite some time anyway.
	# Instead we apply a patch to use the --oauth2-client-id= and
	# --oauth2-client-secret= switches for setting GOOGLE_DEFAULT_CLIENT_ID and
	# GOOGLE_DEFAULT_CLIENT_SECRET at runtime. This allows signing into
	# Chromium without baked-in values.
	local google_api_key="AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc"
	myconf_gn+=" google_api_key=\"${google_api_key}\""
	local myarch="$(tc-arch)"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags

		# Debug info section overflows without component build
		# Prevent linker from running out of address space, bug #471810 .
		filter-flags "-g*"

		# Prevent libvpx/xnnpack build failures. Bug 530248, 544702, 546984, 853646.
		if [[ ${myarch} == amd64 ]]; then
			filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 -mno-avx -mno-avx2 -mno-fma -mno-fma4 -mno-xop -mno-sse4a
		fi

		# The linked text section of Chromium won't fit within limits of the
		# default normal code model.
		if [[ ${myarch} == loong ]]; then
			append-flags -mcmodel=medium
		fi
	fi

	if [[ $myarch = amd64 ]] ; then
		myconf_gn+=" target_cpu=\"x64\""
		ffmpeg_target_arch=x64
	elif [[ $myarch = arm64 ]] ; then
		myconf_gn+=" target_cpu=\"arm64\""
		ffmpeg_target_arch=arm64
	elif [[ $myarch = loong ]] ; then
		myconf_gn+=" target_cpu=\"loong64\""
		ffmpeg_target_arch=loong64
	elif [[ $myarch = ppc64 ]] ; then
		myconf_gn+=" target_cpu=\"ppc64\""
		ffmpeg_target_arch=ppc64
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	myconf_gn+=" treat_warnings_as_errors=false"
	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Disable external code space for V8 for ppc64. It is disabled for ppc64
	# by default, but cross-compiling on amd64 enables it again.
	if tc-is-cross-compiler; then
		if ! use amd64 && ! use arm64; then
			myconf_gn+=" v8_enable_external_code_space=false"
		fi
	fi

	# Only enabled for clang, but gcc has endian macros too
	myconf_gn+=" v8_use_libm_trig_functions=true"

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	# We don't use the same clang version as upstream, and with -Werror
	# we need to make sure that we don't get superfluous warnings.
	append-flags -Wno-unknown-warning-option
	if tc-is-cross-compiler; then
			export BUILD_CXXFLAGS+=" -Wno-unknown-warning-option"
			export BUILD_CFLAGS+=" -Wno-unknown-warning-option"
	fi

	# Explicitly disable ICU data file support for system-icu/headless builds.
	if use system-icu || use headless; then
		myconf_gn+=" icu_use_data_file=false"
	fi

	# Don't need nocompile checks and GN crashes with our config
	myconf_gn+=" enable_nocompile_tests=false"

	# 131 began laying the groundwork for replacing freetype with
	# "Rust-based Fontations set of libraries plus Skia path rendering"
	# We now need to opt-in
	myconf_gn+=" enable_freetype=true"

	# Enable ozone wayland and/or headless support
	myconf_gn+=" use_ozone=true ozone_auto_platforms=false"
	myconf_gn+=" ozone_platform_headless=true"
	if use headless; then
		myconf_gn+=" ozone_platform=\"headless\""
		myconf_gn+=" use_xkbcommon=false use_gtk=false use_qt=false"
		myconf_gn+=" use_glib=false use_gio=false"
		myconf_gn+=" use_pangocairo=false use_alsa=false"
		myconf_gn+=" use_libpci=false use_udev=false"
		myconf_gn+=" enable_print_preview=false"
		myconf_gn+=" enable_remoting=false"
	else
		myconf_gn+=" use_system_minigbm=true"
		myconf_gn+=" use_xkbcommon=true"
		myconf_gn+=" use_qt5=false"
		myconf_gn+=" use_qt6=false"
		myconf_gn+=" ozone_platform_x11=$(usex X true false)"
		myconf_gn+=" ozone_platform_wayland=$(usex wayland true false)"
		myconf_gn+=" ozone_platform=$(usex wayland \"wayland\" \"x11\")"
		use wayland && myconf_gn+=" use_system_libffi=true"
	fi

	myconf_gn+=" use_thin_lto=${use_lto}"
	myconf_gn+=" thin_lto_enable_optimizations=${use_lto}"

	# Enable official builds
	myconf_gn+=" is_official_build=$(usex official true false)"
	if use official; then
		# Allow building against system libraries in official builds
		sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py || die
		# Req's LTO; TODO: not compatible with -fno-split-lto-unit
		myconf_gn+=" is_cfi=false"
		# Don't add symbols to build
		myconf_gn+=" symbol_level=0"
	else
		# Need esbuild
		myconf_gn+=" devtools_skip_typecheck=false"
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

	myconf_gn+=" use_system_cares=true use_system_nghttp2=true"

	myconf_gn+=" override_electron_version=\"${PV}\""

	myconf_gn+=" import(\"//electron/build/args/release.gn\")"

	einfo "Configuring Electron..."
	set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
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
		for x in mksnapshot v8_context_snapshot_generator; do
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
