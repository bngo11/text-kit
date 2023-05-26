# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="rga is a line-oriented search tool that allows you to look for a regex in a multitude of file types"
HOMEPAGE="https://github.com/phiresky/ripgrep-all"
SRC_URI="https://github.com/phiresky/ripgrep-all/tarball/291033bf9f125af778e9008b8d9b346825dcc327 -> ripgrep-all-0.9.6-291033b.tar.gz
https://direct.funtoo.org/2f/35/bf/2f35bfa1a2ce4c7a7674743bab2bc5fa3ab93955a37b57a731180b38e49502a45d99a263142840e3070aed87a313127487792d6d8c754b910d97bf55a5d92495 -> ripgrep_all-0.9.6-funtoo-crates-bundle-d24e2804c6e4d4cb62ddfdfe649b4155092acc57cab090119a341e5d897456562f21f82ce425d30fca43da4b4f561d92fb6267f9ffb91fc5c1ae351ad264276a.tar.gz"

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