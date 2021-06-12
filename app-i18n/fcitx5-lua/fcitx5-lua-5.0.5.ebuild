# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-3 lua5-4 )

inherit cmake lua-single

DESCRIPTION="Lua support for fcitx"
HOMEPAGE="https://github.com/fcitx/fcitx5-lua"
SRC_URI="https://github.com/fcitx/fcitx5-lua/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-i18n/fcitx5
	kde-frameworks/extra-cmake-modules
"
RDEPEND="${DEPEND}"
BDEPEND=""
