# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="shell formatter"
HOMEPAGE="https://github.com/mvdan/sh"

# sed -re 's/^(\S*) (\S*) (\S*)/"\1 \2"/g' go.sum  | xclip -selection clipboard
EGO_SUM=(
"github.com/creack/pty v1.1.11"
"github.com/creack/pty v1.1.11/go.mod"
"github.com/davecgh/go-spew v1.1.0"
"github.com/davecgh/go-spew v1.1.0/go.mod"
"github.com/google/renameio v0.1.0"
"github.com/google/renameio v0.1.0/go.mod"
"github.com/kr/pretty v0.1.0/go.mod"
"github.com/kr/pretty v0.2.1"
"github.com/kr/pretty v0.2.1/go.mod"
"github.com/kr/pty v1.1.1/go.mod"
"github.com/kr/text v0.1.0"
"github.com/kr/text v0.1.0/go.mod"
"github.com/pkg/diff v0.0.0-20200914180035-5b29258ca4f7"
"github.com/pkg/diff v0.0.0-20200914180035-5b29258ca4f7/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/rogpeppe/go-internal v1.6.2"
"github.com/rogpeppe/go-internal v1.6.2/go.mod"
"github.com/sergi/go-diff v1.0.0"
"github.com/sergi/go-diff v1.0.0/go.mod"
"github.com/stretchr/objx v0.1.0/go.mod"
"github.com/stretchr/testify v1.4.0"
"github.com/stretchr/testify v1.4.0/go.mod"
"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9"
"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
"golang.org/x/sys v0.0.0-20201029080932-201ba4db2418"
"golang.org/x/sys v0.0.0-20201029080932-201ba4db2418/go.mod"
"golang.org/x/term v0.0.0-20191110171634-ad39bd3f0407"
"golang.org/x/term v0.0.0-20191110171634-ad39bd3f0407/go.mod"
"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
"gopkg.in/errgo.v2 v2.1.0"
"gopkg.in/errgo.v2 v2.1.0/go.mod"
"gopkg.in/yaml.v2 v2.2.2"
"gopkg.in/yaml.v2 v2.2.2/go.mod"
"mvdan.cc/editorconfig v0.1.1-0.20200121172147-e40951bde157"
"mvdan.cc/editorconfig v0.1.1-0.20200121172147-e40951bde157/go.mod"
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
