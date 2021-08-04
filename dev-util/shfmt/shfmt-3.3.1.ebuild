# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="shell formatter"
HOMEPAGE="https://github.com/mvdan/sh"

# sed -re 's/^(\S*) (\S*) (\S*)/"\1 \2"/g' go.sum  | wl-copy
EGO_SUM=(
"github.com/creack/pty v1.1.9/go.mod"
"github.com/creack/pty v1.1.13"
"github.com/creack/pty v1.1.13/go.mod"
"github.com/google/renameio v1.0.1"
"github.com/google/renameio v1.0.1/go.mod"
"github.com/kr/pretty v0.1.0/go.mod"
"github.com/kr/pretty v0.2.1"
"github.com/kr/pretty v0.2.1/go.mod"
"github.com/kr/pty v1.1.1/go.mod"
"github.com/kr/text v0.1.0/go.mod"
"github.com/kr/text v0.2.0"
"github.com/kr/text v0.2.0/go.mod"
"github.com/pkg/diff v0.0.0-20210226163009-20ebb0f2a09e"
"github.com/pkg/diff v0.0.0-20210226163009-20ebb0f2a09e/go.mod"
"github.com/rogpeppe/go-internal v1.8.0"
"github.com/rogpeppe/go-internal v1.8.0/go.mod"
"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c"
"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c"
"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
"golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b"
"golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b/go.mod"
"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
"gopkg.in/errgo.v2 v2.1.0"
"gopkg.in/errgo.v2 v2.1.0/go.mod"
"mvdan.cc/editorconfig v0.2.0"
"mvdan.cc/editorconfig v0.2.0/go.mod"
)

go-module_set_globals

RESTRICT="mirror"

SRC_URI="https://github.com/mvdan/sh/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
    ${EGO_SUM_SRC_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

S="${WORKDIR}/sh-${PV}"

src_compile() {
	export CGO_ENABLED=0
	go build -o ${PN} ./cmd/shfmt || die
}

src_install() {
	dobin ${PN}
}
