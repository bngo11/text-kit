# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="rga is a line-oriented search tool that allows you to look for a regex in a multitude of file types"
HOMEPAGE="https://github.com/phiresky/ripgrep-all"
SRC_URI="https://github.com/phiresky/ripgrep-all/tarball/424e293942009283c735579f65dd90c2f314094f -> ripgrep-all-0.10.6-424e293.tar.gz
https://direct.funtoo.org/91/ca/1b/91ca1b5595170c30208289234fcfbfb7c218f16846aa71ef023d89f2092bc6723f55560ae41e4f0050bfcbd23353d98f2ee946bae0a899f91e57b5e1c1426c16 -> ripgrep_all-0.10.6-funtoo-crates-bundle-83b9919e60c19ea2a214cd60dd8e56f8102f94b62bcf0adc00f384dce020c1891f5d0edaf104b02d1a1c8155acb1232aa409a9f4952661f95559eab5f865715c.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	virtual/rust
	|| (
		app-text/pandoc-bin
		app-text/pandoc
	)
	app-text/poppler
	media-video/ffmpeg
	sys-apps/ripgrep
"

src_unpack() {
	cargo_src_unpack

	rm -rf ${S}
	mv ${WORKDIR}/phiresky-ripgrep-all-* ${S} || die
}