# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# from https://aur.archlinux.org/packages/cemu

EAPI=8

inherit cmake desktop git-r3 toolchain-funcs xdg

DESCRIPTION="A Wii U emulator"
HOMEPAGE="https://cemu.info/"

EGIT_REPO_URI="https://github.com/cemu-project/Cemu.git"
EGIT_SUBMODULES=( '-*' 'dependencies/imgui' )
EGIT_COMMIT="v$(ver_cut 1-2)-$(ver_cut 3)"

DOCS=( "README.md" "LICENSE.txt" )

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
    >=dev-libs/boost-1.81.0:=
    >=dev-libs/libfmt-9.1.0:=
    >=dev-libs/libzip-1.9.2:=
    >=media-libs/libpng-1.6.39:=
    >=dev-libs/pugixml-1.13
    media-libs/libsdl2
    x11-libs/wxGTK:3.2-gtk3
    >=media-libs/vulkan-loader-1.3.243
    >=media-libs/glm-0.9.9.8
    >=dev-libs/rapidjson-1.1.0
    net-misc/curl
    media-libs/glu
    media-libs/libpulse
    media-libs/cubeb
    >=app-arch/zarchive-0.1.2
    elibc_musl? (
        sys-libs/libexecinfo
        sys-libs/libucontext
    )
"
RDEPEND="${DEPEND}"
BDEPEND="
    >=dev-util/vulkan-headers-1.3.243
    >=dev-util/glslang-1.3.243
    dev-lang/nasm
"

src_prepare() {
    use elibc_musl && eapply "${FILESDIR}/musl.patch"

	# unbundled fmt
	sed -i '/FMT_HEADER_ONLY/d' src/Common/precompiled.h || die

	# Dir names will be changed to "Cemu" in this package with 2.1
	# Needs notice in post_install() then
	sed -i 's/GetAppName()/"cemu"/' src/gui/CemuApp.cpp || die

	# gamelist column width improvement
	sed -i '/InsertColumn/s/kListIconWidth/&+8/;/SetColumnWidth/s/last_col_width/&-1/' src/gui/components/wxGameList.cpp || die

    # fix name of binary
    sed -i 's/Cemu_$<LOWER_CASE:$<CONFIG>>/cemu/' src/CMakeLists.txt || die

	# disable lto
	sed -i '/INTERPROCEDURAL_OPTIMIZATION/d' CMakeLists.txt || die

    cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
        -DENABLE_VCPKG=OFF
        -DPORTABLE=OFF
        -DBUILD_SHARED_LIBS=OFF
    )
    cmake_src_configure
}

src_install() {
    dobin "${S}"/bin/cemu
    einstalldocs
    insinto /usr/share/cemu
    doins -r "${S}"/bin/gameProfiles
    doins -r "${S}"/bin/resources
    sed -i -e '/^Icon=/cIcon=cemu' -e '/^Exec=Cemu/cExec=cemu' "${S}"/dist/linux/info.cemu.Cemu.desktop || die
    domenu "${S}"/dist/linux/info.cemu.Cemu.desktop
    insinto /usr/share/icons/hicolor/128x128/apps
    newins "${S}"/src/resource/logo_icon.png cemu.png
}

pkg_postinst() {
    xdg_icon_cache_update
    xdg_desktop_database_update
}

pkg_postrm() {
    xdg_icon_cache_update
    xdg_desktop_database_update
}
