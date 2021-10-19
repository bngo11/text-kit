# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="libe-book-${PV}"
inherit autotools flag-o-matic

DESCRIPTION="Library parsing various ebook formats"
HOMEPAGE="https://sourceforge.net/projects/libebook/"
SRC_URI="https://sourceforge.net/projects/libebook/files/libe-book-0.1.3/libe-book-0.1.3.tar.xz -> libebook-0.1.3.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc test tools"

RESTRICT="!test? ( test )"

RDEPEND="
	app-text/liblangtag
	dev-libs/icu:=
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-util/gperf
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/libebook-0.1.3-icu-68.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--disable-werror
		$(use_with doc docs)
		$(use_enable test tests)
		$(use_with tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}