# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Locale program for musl libc"
HOMEPAGE="https://gitlab.com/rilian-la-te/musl-locales"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.com/rilian-la-te/musl-locales.git"

LICENSE="LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"
