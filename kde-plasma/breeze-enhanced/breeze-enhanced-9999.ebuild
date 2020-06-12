# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="A fork of KDE Breeze decoration with additional options"
HOMEPAGE="https://github.com/tsujan/BreezeEnhanced"
EGIT_REPO_URI="https://github.com/tsujan/BreezeEnhanced.git"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="kde-plasma/kwin"
RDEPEND="${DEPEND}"
BDEPEND=""
