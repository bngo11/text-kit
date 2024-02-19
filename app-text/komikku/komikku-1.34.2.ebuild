# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE="sqlite(+),ssl(+)"
DISTUTILS_USE_PEP517=no
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 meson gnome3 virtualx

MY_PN="${PN^}"
MY_P="${MY_PN}-v${PV}"
DESCRIPTION="An online/offline manga reader for GNOME"
HOMEPAGE="https://gitlab.com/valos/Komikku"
SRC_URI="https://gitlab.com/valos/${MY_PN}/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

KEYWORDS="*"
LICENSE="GPL-3+"
SLOT="0"
IUSE="test"

RESTRICT="test"
PROPERTIES="test_network"

DEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection[${PYTHON_SINGLE_USEDEP}]
	>=x11-libs/gtk-4.8.2:4
	>=gui-libs/libadwaita-1.2.0[introspection]
	net-libs/webkit-gtk:6[introspection]
	dev-util/blueprint-compiler
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		app-arch/brotli[python]
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/beautifulsoup[${PYTHON_USEDEP}]
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/cloudscraper[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/dateparser[${PYTHON_USEDEP}]
		dev-python/emoji[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/natsort[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pure_protobuf[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/python-magic[${PYTHON_USEDEP}]
		dev-python/rarfile[compressed,${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/unidecode[${PYTHON_USEDEP}]
		dev-python/pytz_deprecation_shim[${PYTHON_USEDEP}]
		dev-python/colorthief[${PYTHON_USEDEP}]
		dev-python/piexif[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest-steps[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

src_prepare() {
	default

	# fix broken shebang
	sed "s|py_installation.full_path()|'${PYTHON}'|" -i bin/meson.build || die
}

src_test() {
	virtx epytest
}

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
}

pkg_postinst() {
	gnome3_pkg_postinst
}

pkg_postrm() {
	gnome3_pkg_postrm
}
