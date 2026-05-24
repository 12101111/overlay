# 12101111-overlay

This is my overlay for musl & clang & systemd & arm64.

The patches and changes in it may only apply to me, so it is not recommended to use it directly.
Please follow the [official instruction](https://wiki.gentoo.org/wiki/Ebuild_repository#Masking_installed_but_unsafe_ebuild_repositories) to add this overlay,
 and mask/unmask ebuild you don't want/want, otherwise your system may break after installing some ebuild only for musl.

## How to compile WASI Sdk using crossdev

(Note that some text here shows LLVM version 22, if you are building for 21 substitute that value where appropriate)

1. Create `crossdev` overlay

(Easiest with `eselect repository create crossdev`)

Symlink cmake.eclass in this overlay to `crossdev`

```shell
ln -s 12101111-overlay/eclass crossdev/eclass
```

2. Create crossdev wrapper

```shell
crossdev -L -t wasm32-wasip1
```

This will fail with the message: `error: Target architecture not supported by installed LLVM toolchain.` This is expected as Gentoo doesn't have official wasm32-wasi support.

Symlink llvm-runtimes in this overlay to `crossdev` (possible that `crossdev` will do some of this for you, likely first five lines)

```shell
ln -s ../../12101111-overlay/sys-devel/clang-crossdev-wrappers crossdev/cross_llvm-wasm32-wasip1
ln -s ../../12101111-overlay/llvm-runtimes/compiler-rt crossdev/cross_llvm-wasm32-wasip1
ln -s ../../12101111-overlay/llvm-runtimes/libcxx crossdev/cross_llvm-wasm32-wasip1
ln -s ../../12101111-overlay/llvm-runtimes/libcxxabi crossdev/cross_llvm-wasm32-wasip1
ln -s ../../12101111-overlay/llvm-runtimes/libunwind crossdev/cross_llvm-wasm32-wasip1
ln -s ../../12101111-overlay/sys-devel/rust-std crossdev/cross_llvm-wasm32-wasip1
ln -s ../../12101111-overlay/dev-libs/wasi-libc crossdev/cross_llvm-wasm32-wasip1
```

3. Edit configs

Append these flags to `/etc/portage/env/cross_llvm-wasm32-wasip1/llvm.conf`:

```shell
AS="wasm32-wasip1-as"
CPP="wasm32-wasip1-cpp"

CFLAGS="-Os -pipe -mcpu=lime1"
CXXFLAGS="-Os -pipe -mcpu=lime1"
LDFLAGS=""
RUSTFLAGS="-Ctarget-cpu=lime1 -Copt-level=s -Ccodegen-units=1"
```

Append these flags to `/etc/portage/package.env/cross_llvm-wasm32-wasip1`:

```shell
cross_llvm-wasm32-wasip1/wasi-libc cross_llvm-wasm32-wasip1/wasi-libc.conf
cross_llvm-wasm32-wasip1/wasi-libc cross_llvm-wasm32-wasip1/llvm.conf
cross_llvm-wasm32-wasip1/libcxxabi cross_llvm-wasm32-wasip1/libcxx.conf
cross_llvm-wasm32-wasip1/libcxxabi cross_llvm-wasm32-wasip1/llvm.conf
```
Then, to create `wasi-libc.conf`:
```shell
cp /etc/portage/env/cross_llvm-wasm32-wasip1/{linux-headers.conf,wasi-libc.conf}
```

Remove `@../gentoo-runtimes.cfg` in `/etc/clang/cross/wasm32-wasip1.cfg` and append these flags:

```shell
--sysroot=/usr/wasm32-wasip1
--target=wasm32-wasip1
--rtlib=compiler-rt
--stdlib=libc++
--unwindlib=none
```

4. Install packages:

```shell
emerge cross_llvm-wasm32-wasip1/clang-crossdev-wrappers
emerge cross_llvm-wasm32-wasip1/compiler-rt
```

Check compiler-rt is compiled correctly:

```
llvm-readelf -h /usr/lib/clang/22/lib/wasm32-unknown-wasip1/libclang_rt.builtins.a | grep WASM | wc -l
# should output number like 150
llvm-readelf -h /usr/lib/clang/22/lib/wasm32-unknown-wasip1/libclang_rt.builtins.a | grep ELF
# should output nothing
```


(this will need to be unmasked)
```shell
emerge cross_llvm-wasm32-wasip1/wasi-libc
```

Check wasi-libc is compiled correctly (wasmtime can be installed with `cargo` or in dev-util/wasm-tools):

```shell
cat << EOF > /tmp/hello.c
#include <stdio.h>
int main() {
    printf("Hello world!\n");
    return 0;
}
EOF
wasm32-wasip1-cc /tmp/hello.c -Os -o /tmp/hello.wasm
wasmtime /tmp/hello.wasm
```

Install C++ std (unmask for 21 or 22):

```shell
emerge cross_llvm-wasm32-wasip1/libcxxabi
emerge cross_llvm-wasm32-wasip1/libcxx
```

Check libc++ is compiled correctly:

```shell
cat << EOF > /tmp/hello.cpp
#include <iostream>
int main() {
  std::cout << "Gentoo Linux Clang/LLVM/LLD toolchain for WASI!" << std::endl;
  return 0;
}
EOF
wasm32-wasip1-c++ /tmp/hello.cpp -fno-exceptions -Os -o /tmp/hello.wasm
wasmtime /tmp/hello.wasm
```

Install Rust std (need at least Rust 1.94.1 for this):

/etc/portage/package.accept_keywords/cross_llvm-wasm32-wasip1

```
cross_llvm-wasm32-wasip1/rust-std **
```

```shell
emerge cross_llvm-wasm32-wasip1/rust-std
```

Check Rust-std is compiled correctly:

```shell
/usr/bin/cargo new hello
cd hello
/usr/bin/cargo build -r --target wasm32-wasip1
wasmtime target/wasm32-wasip1/release/hello.wasm
```

5. Setup portage

Most packages don't work under wasm32-wasi. But if you want try it, set those flags.

/usr/wasm32-wasip1/etc/portage/profile/make.defaults

```shell
ARCH="wasm32"
KERNEL="wasi"
ELIBC="wasip1"
AS=wasm32-wasip1-as
CPP=wasm32-wasip1-cpp
CC="wasm32-wasip1-clang"
CXX="wasm32-wasip1-clang++"
LD=wasm-ld
```

/usr/wasm32-wasip1/etc/portage/repos.conf

```toml
[DEFAULT]
main-repo = gentoo

[gentoo]
location = <fill this>

[12101111-overlay]
location = <fill this>
priority = 1000
```

## Packages

- [app-doc/zeal](https://github.com/zealdocs/zeal): Live ebuild, use qtwebengine as backend.
- [app-editors/vnote](https://github.com/tamlok/vnote): Vnote 2 and vnotex 3.
- [app-editors/vscode](https://github.com/microsoft/vscode/): Build vscode from source code.
- [app-text/goldendict](https://github.com/xiaoyifang/goldendict/): Live ebuild of xiaoyifang's fork, use qtwebengine as backend.
- dev-java/openjdk: Fix for clang and musl.
- [dev-lang/deno](https://github.com/denoland/deno): A modern runtime for JavaScript and TypeScript.
- [dev-lang/luajit](https://github.com/openresty/luajit2): OpenResty's fork of LuaJIT.
- [dev-lang/rust](https://github.com/rust-lang/rust/): Add libcxx, profiler, sanitizers support. fix for musl system. add wasm32-wasi support.
- [dev-libs/mimalloc](https://github.com/microsoft/mimalloc): Build static and object files.
- [dev-libs/wasi-libc](https://github.com/WebAssembly/wasi-libc): Live ebuild for wasi-libc, used in rust support for wasm32-wasi.
- [dev-util/electron](https://github.com/electron/electron/): Build Electron from source code. Fix for musl.
- [dev-util/electron-bin](https://github.com/electron/electron/): Electron built by upstream for **glibc**.
- dev-util/mingw64-toolchain: ignore USE=-abi_x86_32 and build as multilib toolchain on musl.
- [dev-util/cemu](https://cemu.info): Fix for musl, currently one minor version behind.
- [gui-apps/waybar](https://github.com/Alexays/Waybar): Libcxx support.
- [gui-apps/wob](https://github.com/francma/wob): Live ebuild.
- sys-apps/busybox: Fix for clang.
- sys-apps/systemd: systemd with musl patches from openembedded. Use with `12101111-overlay:clang/musl/<arch>/systemd` profile.
- sys-boot/m1n1: First stage bootloader for Apple Silicon computer. Update the binary using sys-boot/m1n1/files/update-m1n1.
- sys-boot/uboot-asahi: Second stage bootloader for Apple Silicon computer.
- [sys-devel/binutils](https://sourceware.org/binutils/): GNU binutils ebuild that can disable most component. Useful for llvm binutils users
- sys-fs/zfs: Fix systemd support for musl.
- sys-libs/gcompat: gcompat with more symbol. Keep for history reason.
- sys-libs/libexecinfo: `backtrace` from NetBSD.
- sys-libs/musl: Fix for chromium's partation allocator. Change the default allocator to rpmalloc. Update some assembly code.
- sys-libs/musl-legacy-compat. Some header files from voidlinux.
- virtual/fortran: `add llvm-core/flang`
- [www-client/chromium](https://github.com/chromium/chromium/): Fix for musl.
- www-client/firefox: Enable C++/Rust cross language LTO & PGO.
- x11-misc/rofi: ebuild of wayland fork

## License

All ebuild files are distributed under the terms of the GNU General Public License v2.

The following ebuild are not a fork from Gentoo main tree or GURU Project:

- `app-editors/vnote:2`: [jorgicio overlay](https://github.com/jorgicio/jorgicio-gentoo-overlay)
- `app-editors/vscode`: this overlay
- `dev-util/electron`: [electron overlay](https://github.com/elprans/electron-overlay)
- `sys-boot/m1n1`: this overlay
- `sys-boot/uboot-asahi`: this overlay
- `sys-libs/gcompat`: [lanodan overlay](https://hacktivis.me/git/overlay/)
- `sys-libs/libexecinfo`: original from Voidlinux and FreeBSD, port to NetBSD source by myself.
- `sys-libs/musl-legacy-compat`: Voidlinux

All patch files are distributed under the same license of the corresponding package.

The following patches are not a fork from Gentoo main tree, musl overlay or GURU Project

- `www-client/chromium` and `dev-util/electron`: Alpine Linux and Voidlinux
