# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="Lightweight tool for recording,replaying and debugging execution of applications"
HOMEPAGE="http://rr-project.org/"
EGIT_REPO_URI="https://github.com/mozilla/rr.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-util/ccache
	dev-python/pexpect
	dev-libs/capnproto
	sys-devel/gdb
"
RDEPEND="${DEPEND}"
BDEPEND=""
