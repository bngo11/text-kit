# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Unicode data from unicode.org"
HOMEPAGE="https://unicode.org/ucd/"
SRC_URI="https://unicode.org/Public/zipped/16.0.0/UCD.zip -> unicode-data-16.0.0-UCD.zip
https://unicode.org/Public/zipped/16.0.0/Unihan.zip -> unicode-data-16.0.0-Unihan.zip"

LICENSE="unicode"
SLOT="0"
KEYWORDS="*"

DEPEND="app-arch/unzip"
S="${WORKDIR}"

src_unpack() {
	# Unihan.zip needs to be installed as a zip for reverse deps
	# https://bugzilla.gnome.org/show_bug.cgi?id=768210
	unpack ${P}-UCD.zip
}

src_install() {
	insinto /usr/share/${PN}
	doins -r "${S}"/*
	newins "${DISTDIR}"/${P}-Unihan.zip Unihan.zip
}