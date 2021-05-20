# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/OtterBrowser/${PN}-browser"
	inherit git-r3
else
	SRC_URI="https://github.com/OtterBrowser/${PN}-browser/archive/v${PV/_p/-dev}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
	S=${WORKDIR}/${PN}-browser-${PV/_p/-dev}
fi

DESCRIPTION="Project aiming to recreate classic Opera (12.x) UI using Qt5"
HOMEPAGE="https://otter-browser.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+webengine webkit +dbus +spell"
REQUIRED_USE="
	|| ( webengine webkit )
"

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxmlpatterns:5
	dbus? ( dev-qt/qtdbus:5 )
	spell? ( app-text/hunspell:= )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
	webkit? ( dev-qt/qtwebkit:5 )
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG CONTRIBUTING.md TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.01-webengine.patch
)

src_prepare() {
	cmake_src_prepare

	if [[ -n ${LINGUAS} ]]; then
		local lingua
		for lingua in resources/translations/*.qm; do
			lingua=$(basename ${lingua})
			lingua=${lingua/otter-browser_/}
			lingua=${lingua/.qm/}
			if ! has ${lingua} ${LINGUAS}; then
				rm resources/translations/otter-browser_${lingua}.qm || die
			fi
		done
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_QTWEBENGINE="$(usex webengine)"
		-DENABLE_QTWEBKIT="$(usex webkit)"
		-DENABLE_SPELLCHECK=$(usex spell)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	domenu ${PN}-browser.desktop
}
