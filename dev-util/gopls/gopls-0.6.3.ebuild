# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="The official language server for the Go language"
HOMEPAGE="https://github.com/golang/tools/tree/master/gopls"

# sed -re 's/^(\S*) (\S*) (\S*)/"\1 \2"/g' go.sum  | xclip -selection clipboard
EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/davecgh/go-spew v0.0.0-20161028175848-04cdfd42973b/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/google/go-cmp v0.5.4"
	"github.com/google/go-cmp v0.5.4/go.mod"
	"github.com/google/renameio v0.1.0/go.mod"
	"github.com/google/safehtml v0.0.2"
	"github.com/google/safehtml v0.0.2/go.mod"
	"github.com/jba/templatecheck v0.5.0"
	"github.com/jba/templatecheck v0.5.0/go.mod"
	"github.com/kisielk/gotool v1.0.0/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/pmezard/go-difflib v0.0.0-20151028094244-d8ed2627bdf0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rogpeppe/go-internal v1.3.0/go.mod"
	"github.com/rogpeppe/go-internal v1.5.2/go.mod"
	"github.com/rogpeppe/go-internal v1.6.2/go.mod"
	"github.com/sanity-io/litter v1.3.0"
	"github.com/sanity-io/litter v1.3.0/go.mod"
	"github.com/sergi/go-diff v1.1.0"
	"github.com/sergi/go-diff v1.1.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v0.0.0-20161117074351-18a02ba4a312/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/yuin/goldmark v1.1.27/go.mod"
	"github.com/yuin/goldmark v1.2.1/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/mod v0.2.0/go.mod"
	"golang.org/x/mod v0.3.0/go.mod"
	"golang.org/x/mod v0.4.0"
	"golang.org/x/mod v0.4.0/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b/go.mod"
	"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
	"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9"
	"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.0.0-20200410194907-79a7a3126eef/go.mod"
	"golang.org/x/tools v0.0.0-20210101214203-2dba1e4ea05c/go.mod"
	"golang.org/x/tools v0.0.0-20210112235408-75fd75db8797"
	"golang.org/x/tools v0.0.0-20210112235408-75fd75db8797/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
	"gopkg.in/errgo.v2 v2.1.0/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.4"
	"gopkg.in/yaml.v2 v2.2.4/go.mod"
	"honnef.co/go/tools v0.0.1-2020.1.6"
	"honnef.co/go/tools v0.0.1-2020.1.6/go.mod"
	"mvdan.cc/gofumpt v0.1.0"
	"mvdan.cc/gofumpt v0.1.0/go.mod"
	"mvdan.cc/xurls/v2 v2.2.0"
	"mvdan.cc/xurls/v2 v2.2.0/go.mod"
)

go-module_set_globals

RESTRICT="mirror"

SRC_URI="https://github.com/golang/tools/archive/${PN}/v${PV}.tar.gz -> ${P}.tar.gz
    ${EGO_SUM_SRC_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

S="${WORKDIR}/tools-${PN}-v${PV}/${PN}"

src_compile() {
	export CGO_ENABLED=0
	go build -o ${PN} || die
}

src_install() {
	dobin ${PN}
}
