# deepseek-harness: pnpm offline build notes

This ebuild installs the published `@deepseek-ai/dsh` CLI and assembles its
runtime `node_modules` from the npm tarballs listed in `NPMPKGS`.  No network
access is needed after `emerge --fetch`:

1. `src_unpack` extracts only the `@deepseek-ai/dsh` tarball (`S=package/`).
2. `src_compile` creates `WORKDIR/npm-registry` by symlinking every dependency
   tarball into the layout a registry would serve
   (`<name>/-/<basename>-<version>.tgz`).
3. `pnpm install --frozen-lockfile --prod` runs with
   `--config.registry=file://${WORKDIR}/npm-registry`.

## Why not pnpm's native offline mode?

pnpm's `--offline` only reads its content-addressable store; it does not read
loose `.tgz` files.  Two shortcuts that look plausible do not work:

* `pnpm store add foo.tgz` stores the tarball under a `file:` package id, so a
  later `pnpm install --offline --frozen-lockfile` still reports
  `ERR_PNPM_NO_OFFLINE_TARBALL` for the registry package.
* Rewriting every `resolution` entry in `pnpm-lock.yaml` to
  `{integrity: ..., tarball: file:...}` is rejected with
  `ERR_PNPM_RESOLUTION_SHAPE_MISMATCH` ("a registry-style dependency path is
  backed by a non-registry resolution").

A `file://` registry is the supported way to feed downloaded tarballs to
`pnpm install` without a store.  The lockfile must stay registry-shaped, and
`--frozen-lockfile` makes pnpm skip metadata resolution entirely.

pnpm 12 also verifies `minimumReleaseAge` against registry metadata before it
installs.  A file registry cannot answer those metadata requests, so the
ebuild passes `--config.minimumReleaseAge=0`.  The exact versions are already
pinned by the ebuild version, the lockfile, and the distfile hashes; release
age is a publication-time policy and has no meaning for an offline rebuild.
Likewise `--ignore-scripts` keeps package install scripts away from the
network.  Every native object dsh needs is compiled explicitly instead — see
"Native objects are compiled from source" below.

## Native objects are compiled from source

The npm release ships prebuilt ELF binaries for a few platforms only, so the
ebuild compiles each of them from source and then deletes the corresponding
prebuilt npm platform packages.

* `node-pty/build/Release/pty.node`: sources in the npm tarball's own `src/unix/pty.cc`. Build using `node-gyp rebuild`.
* `sharp/src/build/Release/sharp-<plat>-<ver>.node`: sources in the npm tarball's own `src/*.cc`. Build using `node-gyp rebuild --directory=src` with `SHARP_FORCE_GLOBAL_LIBVIPS=1`, linked against `media-libs/vips`.
* `@deepseek-ai/node-addon-system-linux-<arch>/bin/{landlock-run,glibc\|musl/system.node}`: sources from the upstream archive (`native/system/packages/entry/src/*.c`), build static launcher and Node-API `flock` addon with system `cc`.
* `node-addon-require-builtin/build/napi/napi-v9-linux-<arch>-<libc>/require_builtin.node`: sources from `packages/native` of `dsh-node-addon-require-builtin`, build using `node-gyp rebuild` and needs `node-addon-api` 8.x.
* `@vscode/ripgrep-linux-<arch>/bin/rg`: symlink to `sys-apps/ripgrep`'s `/usr/bin/rg`

Dropped rather than built, because no Linux code path loads them or their sources do not exist:

* `koffi` / `@koromix/*` — imported only inside Win32 helpers
  (`GetFileSecurityW`, `MoveFileExW`, `user32` enumeration).
* `sherpa-onnx-*` — the sensevoice speech provider imports it in a worker; the
  optional feature reports itself unavailable instead.

`node-addon-require-builtin` only has `linux-x64`, `linux-arm64`, `darwin-*`
and `win32` runtime sources upstream; on loong/riscv the addon is skipped and
the loader's fallback applies.

Two consequences for maintenance: the node-pty patch from the upstream archive
(`patches/node-pty@1.2.0-beta.15.patch`) is applied before the build, and the
`sharp` USE flag (default on) pulls in `media-libs/vips`; without a libvips
new enough for sharp (>= 8.18.7) or on an arch where it is not keyworded,
build with `USE=-sharp` and image attachments report the feature as
unavailable.

## Regenerating for a new release

The generated inputs are `pnpm-lock.yaml` and the `NPMPKGS` list.  For a new
`@deepseek-ai/dsh` version:

```sh
mkdir -p /tmp/dsh-lock && cd /tmp/dsh-lock
curl -LO https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-<version>.tgz
tar xzf dsh-<version>.tgz
cd package
pnpm install --lockfile-only --prod --config.minimumReleaseAge=0
cp pnpm-lock.yaml ${OVERLAY}/dev-util/deepseek-harness/files/
```

Then regenerate `NPMPKGS` from the lockfile, keeping only entries whose
`os`/`cpu`/`libc` allow the target (`linux`, the Node name of the
architecture — `x64`, `arm64`, `riscv64`, `loong64` — and `glibc`/`musl`;
packages with no such field are universal):


```python
import yaml
ARCH = "x64"            # Node's name for the target: x64, arm64, riscv64, loong64
LIBCS = ("glibc", "musl")  # both, so one distfile set serves either libc
d = yaml.safe_load(open("pnpm-lock.yaml"))
def ok(v, wanted, field):
    f = v.get(field)
    if not f:
        return True
    f = [str(x) for x in f]
    if any(x.startswith("!") for x in f):
        return all("!" + w not in f for w in wanted)
    return any(w in f for w in wanted)
urls = []
for key, meta in d["packages"].items():
    if not ok(meta, ("linux",), "os") or not ok(meta, (ARCH,), "cpu"):
        continue
    if not ok(meta, LIBCS, "libc"):
        continue
    name, _, ver = key.rpartition("@")
    base = name.split("/")[-1]
    urls.append(f"https://registry.npmjs.org/{name}/-/{base}-{ver}.tgz")
print("\n".join(sorted(urls)))
```

The tarballs for per-platform npm packages (`@img/sharp-*`, `@koromix/*`,
`@vscode/ripgrep-*`, `node-addon-* -linux-*`, `sherpa-onnx-*`) still have to be
in the list even though the ebuild deletes them after the install: `pnpm
install --frozen-lockfile` fetches every optional dependency that matches the
build host, and the local registry has to answer.  `--config.optional=false`
would skip them, but it also skips `@deepseek-ai/libreoffice-kit-wasm`, which
the Office skill needs.

For `ARCH = "x64"` the list has 588 tarballs (139 MiB) plus the CLI tarball.
The source archive, the require-builtin archive and the `node-addon-api`
headers needed by the local builds are three additional distfiles.

pnpm is a runtime dependency as well, because `dsh plugin` forwards its
arguments to pnpm.  A test install of this closure made no `AF_INET` socket
connections (verified with strace) and `dsh --profile web|headless
--dump-config` composed both profiles successfully.

The JavaScript stays the published artifact.  Rebuilding the whole monorepo
from source would additionally need its ~1,700 dev dependencies plus the
TypeScript, Web and Desktop toolchains, which is not what the npm release
ships; only the native objects are compiled here.
