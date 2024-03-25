# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev

DESCRIPTION="Symlinks to a Clang crosscompiler"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:LLVM"
SRC_URI=""
S=${WORKDIR}

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
PROPERTIES="live"

RDEPEND="
	sys-devel/clang:${SLOT}
"

src_install() {
	local llvm_path="${EPREFIX}/usr/lib/llvm/${SLOT}"
	into "${llvm_path}"

	for exe in "clang" "clang++" "clang-cpp"; do
		newbin - "${CTARGET}-${exe}" <<-EOF
		#!/bin/sh
		exec ${exe}-${SLOT} --no-default-config --config="/etc/clang/cross/${CTARGET}.cfg" \${@}
		EOF
	done

	newbin - "${CTARGET}-as" <<-EOF
	#!/bin/sh
	exec ${exe}-${SLOT} --no-default-config --config="/etc/clang/cross/${CTARGET}.cfg" -c \${@}
	EOF

	local tools=(
		${CTARGET}-clang-${SLOT}:${CTARGET}-clang
		${CTARGET}-clang-cpp-${SLOT}:${CTARGET}-clang-cpp
		${CTARGET}-clang++-${SLOT}:${CTARGET}-clang++
		${CTARGET}-cc:${CTARGET}-clang
		${CTARGET}-c++:${CTARGET}-clang++
		${CTARGET}-gcc:${CTARGET}-clang
		${CTARGET}-g++:${CTARGET}-clang++
		${CTARGET}-cpp:${CTARGET}-clang-cpp
	)

	local t
	for t in "${tools[@]}"; do
		dosym "${t#*:}" "${llvm_path}/bin/${t%:*}"
	done

	local llvm_tools=(
		addr2line ar dlltool nm objcopy objdump ranlib readelf size
		strings strip windres
	)

	for t in "${llvm_tools[@]}"; do
		dosym "llvm-${t}" "${llvm_path}/bin/${CTARGET}-${t}"
	done
}
