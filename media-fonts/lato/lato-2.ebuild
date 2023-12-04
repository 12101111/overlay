# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Lato font"
HOMEPAGE="https://www.latofonts.com/"

URL="https://raw.githubusercontent.com/google/fonts/main/ofl/lato"
SRC_URI="
	${URL}/OFL.txt
	${URL}/FONTLOG.txt
"

VARIANT="Black BlackItalic Bold BoldItalic ExtraBold ExtraBoldItalic ExtraLight ExtraLightItalic \
	Italic Light LightItalic Medium MediumItalic Regular SemiBold SemiBoldItalic Thin ThinItalic"

for v in $VARIANT; do
	SRC_URI+=" ${URL}/Lato-${v}.ttf"
done

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DOCS="OFL.txt FONTLOG.txt"
S="${WORKDIR}"
FONT_SUFFIX="ttf"

src_unpack() {
	for v in $VARIANT; do
		cp "${DISTDIR}/Lato-${v}.ttf" ${WORKDIR}
	done
	cp "${DISTDIR}/OFL.txt" ${WORKDIR}
	cp "${DISTDIR}/FONTLOG.txt" ${WORKDIR}
}
