# 12101111-overlay

This is my overlay for musl & clang & systemd & arm64.

The patches and changes in it may only apply to me, so it is not recommended to use it directly.
Please follow the [official instruction](https://wiki.gentoo.org/wiki/Ebuild_repository#Masking_installed_but_unsafe_ebuild_repositories) to add this overlay,
 and mask/unmask ebuild you don't want/want, otherwise your system may break after installing some ebuild only for musl.

## Packages

- [app-doc/zeal](https://github.com/zealdocs/zeal): Live ebuild, use qtwebengine as backend.
- [app-editors/vnote](https://github.com/tamlok/vnote): Vnote 2 and vnotex 3.
- [app-editors/vscode](https://github.com/microsoft/vscode/): Build vscode from source code.
- app-emulation/wine-staging: Add patch for wayland support from [collabora](https://gitlab.collabora.com/alf/wine/-/tree/wayland).
- app-office/libreoffice: Fix for musl.
- [app-text/goldendict](https://github.com/xiaoyifang/goldendict/): Live ebuild of xiaoyifang's fork, use qtwebengine as backend.
- dev-java/openjdk: Fix for clang and musl.
- [dev-java/openjdk-bin](https://www.azul.com/downloads/zulu-community/): Prebuilt OpenJDK for musl system by Zulu Community.
- [dev-lang/deno](https://github.com/denoland/deno): A modern runtime for JavaScript and TypeScript.
- [dev-lang/luajit](https://github.com/openresty/luajit2): OpenResty's fork of LuaJIT.
- [dev-lang/rust](https://github.com/rust-lang/rust/): Add libcxx, profiler, sanitizers support. fix for musl system. add wasm32-wasi support.
- [dev-libs/mimalloc](https://github.com/microsoft/mimalloc): Build static and object files.
- [dev-libs/wasi-libc](https://github.com/WebAssembly/wasi-libc): Live ebuild for wasi-libc, used in rust support for wasm32-wasi.
- [dev-qt/qt-creator](https://github.com/qt-creator/qt-creator/): Fix [dev-qt/qt-creator-6.0.0 - highlighter.h: fatal error: AbstractHighlighter: No such file or directory](https://bugs.gentoo.org/846947).
- [dev-qt/qtwebengine](https://github.com/qt/qtwebengine): Allow build GN with CXXFLAGS and chromium patches for musl.
- dev-qt/qtwebkit: Fix for musl. Keep for history reason.
- [dev-util/electron](https://github.com/electron/electron/): Build Electron from source code. Fix for musl.
- [dev-util/electron-bin](https://github.com/electron/electron/): Electron built by upstream for **glibc**.
- [dev-util/ghidra](https://ghidra-sre.org/): Build native dependences from source code.
- dev-util/mingw64-toolchain: ignore USE=-abi_x86_32 and build as multilib toolchain on musl.
- [games-emulation/dosbox-x](https://github.com/joncampbell123/dosbox-x): Fix for musl.
- [games-util/mangohud](https://github.com/flightlessmango/MangoHud): Build mangoapp.
- gui-apps/swaylock-effects: Remove gcc version check.
- [gui-apps/waybar](https://github.com/Alexays/Waybar): Libcxx support.
- [gui-apps/wob](https://github.com/francma/wob): Live ebuild.
- kde-plasma/breeze: Breeze for non kwin wm.
- media-video/ffmpeg: Fix for Apple Silicon.
- net-fs/samba: Fix for musl.
- [media-im/tencent-qq](https://im.qq.com/linuxqq/download.html): 腾讯QQ Linux官方客户端. Keep for history reason.
- net-libs/webkit-gtk: Fix for musl.
- [net-p2p/qbittorrent-enhanced](https://github.com/c0re100/qBittorrent-Enhanced-Edition): Fix for musl.  Keep for history reason.
- sys-apps/busybox: Fix for clang.
- sys-apps/kmscon: Keep for history reason.
- [sys-apps/musl-locales](https://gitlab.com/rilian-la-te/musl-locales): `locale` for musl
- sys-apps/systemd: systemd with musl patches from openembedded. Use with `12101111-overlay:clang/musl/<arch>/systemd` profile.
- sys-boot/m1n1: First stage bootloader for Apple Silicon computer. Update the binary using sys-boot/m1n1/files/update-m1n1.
- sys-boot/uboot-asahi: Second stage bootloader for Apple Silicon computer.
- sys-cluster/k3s: Fix for arm.
- [sys-devel/binutils](https://sourceware.org/binutils/): GNU binutils ebuild that can disable most component. Useful for llvm binutils users
- sys-devel/elftoolchain: Keep for history reason because old version of elfutils can't compile using clang.
- sys-devel/llvm: Build mlir and polly.
- sys-fs/lvm2: Fix for clang.
- sys-fs/xfsprogs: Fix for musl.
- sys-fs/zfs: Fix systemd support for musl.
- sys-libs/gcompat: gcompat with more symbol. Keep for history reason.
- sys-libs/libexecinfo: `backtrace` from NetBSD.
- sys-libs/musl: Fix for chromium's partation allocator. Change the default allocator to rpmalloc. Update some assembly code.
- sys-libs/musl-legacy-compat. Some header files from voidlinux.
- virtual/libelf: use with elftoolchain
- virtual/man: use busybox man instead of man-db
- [www-client/chromium](https://github.com/chromium/chromium/): Fix for musl.
- www-client/firefox: Enable C++/Rust cross language LTO & PGO.
- x11-apps/igt-gpu-tools: remove sys-libs/libunwind dependence because it conflict with llvm-libunwind.
- x11-misc/rofi: ebuild of wayland fork

## License

All ebuild files are distributed under the terms of the GNU General Public License v2.

The following ebuild are not a fork from Gentoo main tree or GURU Project:

- `app-editors/vnote:2`: [jorgicio overlay](https://github.com/jorgicio/jorgicio-gentoo-overlay)
- `app-editors/vscode`: this overlay
- `dev-util/electron`: [electron overlay](https://github.com/elprans/electron-overlay)
- `dev-util/ghidra`: [pentoo overlay](https://github.com/pentoo/pentoo-overlay)
- `media-im/tencent-qq`: [gentoo-zh overlay](https://github.com/microcai/gentoo-zh/)
- `net-p2p/qbittorrent-enhanced`: [gentoo-zh overlay](https://github.com/microcai/gentoo-zh/)
- `sys-boot/m1n1`: this overlay
- `sys-boot/uboot-asahi`: this overlay
- `sys-libs/gcompat`: [lanodan overlay](https://hacktivis.me/git/overlay/)
- `sys-libs/libexecinfo`: original from Voidlinux and FreeBSD, port to NetBSD source by myself.
- `sys-libs/musl-legacy-compat`: Voidlinux

All patch files are distributed under the same license of the corresponding package.

The following patches are not a fork from Gentoo main tree, musl overlay or GURU Project

- `app-emulation/wine-staging`: [collabora](https://gitlab.collabora.com/alf/wine/-/tree/wayland)'s WIP winewayland.drv
- `sys-apps/systemd`: [openembedded](https://github.com/openembedded/openembedded-core)
- `www-client/chromium`, `dev-util/electron` and `dev-qt/qtwebengine`: Alpine Linux and Voidlinux
