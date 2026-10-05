# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg git-r3

DESCRIPTION="Qt-based, free and open source note-taking application, focusing on Markdown"
HOMEPAGE="https://vnotex.github.io/vnote"
EGIT_REPO_URI="https://github.com/vnotex/vnote.git"
EGIT_COMMIT="v${PV}"

# Commits pinned by libs/vxcore/third_party/CMakeLists.txt (FetchContent vxcore_sodium).
SODIUM_CMAKE_COMMIT="9b2848dfc1b917a9410f0de9d81059b26cbfaa8d"
SODIUM_COMMIT="93a7d0d41fe2e32409b5d00386946f491750b7de" # libsodium submodule of libsodium-cmake
SRC_URI="
	https://github.com/robinlinden/libsodium-cmake/archive/${SODIUM_CMAKE_COMMIT}.tar.gz
		-> libsodium-cmake-${SODIUM_CMAKE_COMMIT}.tar.gz
	https://github.com/jedisct1/libsodium/archive/${SODIUM_COMMIT}.tar.gz
		-> libsodium-${SODIUM_COMMIT}.tar.gz
"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="4"

DEPEND="
	dev-qt/qtbase:6[X,cups,gui,network,sql,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6
	dev-qt/qtsvg:6
	dev-libs/qtkeychain:=
	>=dev-libs/libgit2-1.9.2
"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	unpack ${A}
	mv "libsodium-cmake-${SODIUM_CMAKE_COMMIT}" libsodium-cmake || die
	# The archive contains an empty libsodium/ placeholder for the git submodule.
	rmdir libsodium-cmake/libsodium || die
	mv "libsodium-${SODIUM_COMMIT}" libsodium-cmake/libsodium || die
}

src_prepare() {
	sed -i -e "s|VNote|vnote|g" CMakeLists.txt || die
	sed -i -e "s|add_library(VSyntaxHighlighting|add_library(VSyntaxHighlighting STATIC|g" \
		 libs/vtextedit/libs/syntax-highlighting/CMakeLists.txt || die
	sed -i -e "s|add_library(qhotkey|add_library(qhotkey STATIC|g" \
		libs/QHotkey/CMakeLists.txt || die
	sed -i -e "s|keychain.h|qt6keychain/keychain.h|g" src/core/services/synccredentialsstore.cpp || die
	sed -i -e "s|add_subdirectory(cmark)|add_subdirectory(cmark EXCLUDE_FROM_ALL)|g" libs/vtextedit/libs/CMakeLists.txt || die
	# don't clone it from GitHub during the build.
	sed -i -e '/GIT_REPOSITORY https:\/\/github.com\/robinlinden\/libsodium-cmake.git/d' \
		-e "s|GIT_TAG ${SODIUM_CMAKE_COMMIT}|SOURCE_DIR \"${WORKDIR}/libsodium-cmake\"|" \
		-e '/# This adapter pins official libsodium at /d' \
		-e '/GIT_SUBMODULES_RECURSE TRUE/d' \
		libs/vxcore/third_party/CMakeLists.txt || die
	pushd "${S}/libs/vxcore" > /dev/null || die
	eapply "${FILESDIR}/unbundle-libgit2.patch"
	popd > /dev/null || die
	cmake_src_prepare
}

