# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )


inherit meson python-any-r1

DESCRIPTION="ISO language, territory, currency, script codes and their translations"
HOMEPAGE="https://salsa.debian.org/iso-codes-team/iso-codes"
SRC_URI="https://salsa.debian.org/${PN}-team/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE=""

BDEPEND="${PYTHON_DEPS}
	sys-devel/gettext
"

# This ebuild does not install any binaries.
RESTRICT="binchecks strip"

DOCS=( CHANGELOG.md README.md TODO.md )
