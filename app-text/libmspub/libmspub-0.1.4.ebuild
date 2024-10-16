# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Library parsing Microsoft Publisher documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
SRC_URI="https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz -> libmspub-0.1.4.tar.xz"
KEYWORDS="*"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc static-libs"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	sys-devel/libtool
"

PATCHES=( "${FILESDIR}/${P}-gcc10.patch" )

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	# bug 619044
	append-cxxflags -std=c++14

	local myeconfargs=(
		--disable-werror
		$(use_with doc docs)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}