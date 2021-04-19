# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-single-r1

DESCRIPTION="Build EAR generates a compilation database for clang tooling"
HOMEPAGE="https://github.com/rizsotto/Bear"
SRC_URI="https://github.com/rizsotto/Bear/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BEPEND="test? (
		app-shells/bash
		>=dev-cpp/gtest-1.10.0
		$(python_gen_cond_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
	)"

RDEPEND="
	>=net-libs/grpc-1.26:=
	>=dev-libs/libfmt-6.2:=
	>=dev-libs/spdlog-1.5.0:=
	>=dev-cpp/nlohmann_json-3.7.0:=
	dev-db/sqlite
${PYTHON_DEPS}
"

RESTRICT="!test? ( test )"

S="${WORKDIR}/${P^}"


src_configure() {
	local mycmakeargs=(
		-DENABLE_UNIT_TESTS=$(usex test)
		-DENABLE_FUNC_TESTS=$(usex test)
		-DCMAKE_INSTALL_LIBEXECDIR="libexec/bear"
	)
	cmake_src_configure
}

src_test() {
	if has sandbox ${FEATURES}; then
		ewarn "\'FEATURES=sandbox\' detected"
		ewarn "Bear overrides LD_PRELOAD and conflicts with gentoo sandbox"
		ewarn "Skipping tests"
	elif
		has usersandbox ${FEATURES}; then
		ewarn "\'FEATURES=usersandbox\' detected"
		ewarn "Skipping tests"
	elif
		has_version -b 'sys-devel/gcc-config[-native-symlinks]'; then
		ewarn "\'sys-devel/gcc-config[-native-symlinks]\' detected, tests call /usr/bin/cc directly (hardcoded)"
		ewarn "and will fail without generic cc symlink"
		ewarn "Skipping tests"
	fi
}
