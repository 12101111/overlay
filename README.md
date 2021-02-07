# 12101111-overlay

This is my overlay. The patches and changes in it only apply to me, so it is not recommended to use it directly.

Please follow the [official instruction](https://wiki.gentoo.org/wiki/Ebuild_repository#Masking_installed_but_unsafe_ebuild_repositories) to add this overlay,
 and mask/unmask ebuild you don't want/want, otherwise your system may break after installing some ebuild only for musl.

## Packages

- [app-arch/rpm]: musl fix, use sqlite instead of sys-libs/db
- [app-doc/zeal](https://github.com/zealdocs/zeal): live ebuild, use qtwebengine as backend
- [app-editors/vnote](https://github.com/tamlok/vnote): copy from Jorgicio overlay but fix build issue (add marked to SRC_URI)
- [app-editors/vscode](https://github.com/microsoft/vscode/): build vscode from source code
- app-i18n/{fcitx5-chinese-addons, kcm-fcitx5, libime}, x11-libs/xcb-imdkit: keep update with [fcitx5](https://github.com/fcitx) upstream
- app-misc/neofetch: fix install out of prefix. [bug 693526](https://bugs.gentoo.org/693526)
- [app-text/goldendict](https://github.com/goldendict/goldendict): live ebuild.
- [dev-java/openjdk-bin](https://www.azul.com/downloads/zulu-community/): prebuilt OpenJDK for musl system by Zulu Community.
- [dev-lang/luajit](https://github.com/moonjit/moonjit): Moonjit is a fork of LuaJIT
- [dev-lang/rust](https://github.com/rust-lang/rust/): libcxx, profiler, sanitizers support. fix for musl system.
- [dev-libs/elftoolchain](https://sourceforge.net/projects/elftoolchain/files/): replacement of elfutils, useful for systems with clang/llvm and musl
- [dev-qt/qt-creator](https://github.com/qt-creator/qt-creator/): update to newest and fix build with clang 10.
- [dev-qt/qtwebengine](https://github.com/qt/qtwebengine): allow build GN with CXXFLAGS and patches for musl.
- [dev-util/electron](https://github.com/electron/electron/): The Electron 9 and 11 for **Gentoo** and **musl**! (You can find electron 6/7/8 in commit history).Patches set: [Gentoo Chromium](https://github.com/gentoo/gentoo/tree/master/www-client/chromium), [Alpine Linux Chromium](https://github.com/alpinelinux/aports/tree/master/community/chromium), [Void Linux Chromium](https://github.com/void-linux/void-packages/tree/master/srcpkgs/chromium), [Electrom Ozone](https://aur.archlinux.org/packages/electron-ozone), [Chromium Ozone](https://aur.archlinux.org/packages/chromium-beta-ozone/)
- [games-emulation/dosbox-x](https://github.com/joncampbell123/dosbox-x): update to newest and fix for musl
- [gui-apps/waybar](https://github.com/Alexays/Waybar): libcxx support
- kde-plasma/breeze: breeze for non kwin wm
- [breeze-enhanced](https://github.com/tsujan/BreezeEnhanced): live ebuild
- [gnome-base/dconf](https://gitlab.gnome.org/GNOME/dconf/): new release: dconf 0.35.1
- [media-libs/libglvnd](https://gitlab.freedesktop.org/glvnd/libglvnd): musl tls fix
- [media-libs/libtgvoip](https://github.com/telegramdesktop/libtgvoip): clang and musl fix
- [media-im/tencent-qq](https://im.qq.com/linuxqq/download.html): 腾讯QQ Linux官方客户端
- [net-proxy/qv2ray](https://github.com/Qv2ray/Qv2ray): GUI fontend for v2ray
- [net-proxy/qvplugin-ssr](https://github.com/Qv2ray/QvPlugin-SSR/): SSR plugin for Qv2ray
- [sys-apps/attr](https://savannah.nongnu.org/projects/attr): fix issue with ld.gold and ld.lld. [Gentoo bugs](https://bugs.gentoo.org/644048)
- [sys-apps/musl-locales](https://gitlab.com/rilian-la-te/musl-locales): `locale` for musl
- [sys-devel/binutils](https://sourceware.org/binutils/): GNU binutils ebuild that can disable most component. Useful for llvm binutils users
- virtual/libelf: use with elftoolchain
- virtual/man: use busybox man instead of man-db
- [www-client/chromium](https://github.com/chromium/chromium/): Chromium 83 beta with optional ozone (Wayland and X11) support
- www-client/firefox: Firefox with patches for musl system. Most changes is upstreamed to musl overlay.
- [www-client/otter](https://github.com/OtterBrowser/otter-browser): A dual backend(qtwebkit and qtwebengine) web browser with classic Opera (12.x) UI
- x11-apps/igt-gpu-tools: remove sys-libs/libunwind dependence because it conflict with llvm-libunwind
