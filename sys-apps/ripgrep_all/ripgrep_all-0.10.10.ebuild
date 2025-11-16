# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="rga is a line-oriented search tool that allows you to look for a regex in a multitude of file types"
HOMEPAGE="https://github.com/phiresky/ripgrep-all"
SRC_URI="https://github.com/phiresky/ripgrep-all/tarball/e8cd5552379d60b12a17997177b7a8d34eedcdc4 -> ripgrep-all-0.10.10-e8cd555.tar.gz
https://direct.funtoo.org/21/3c/aa/213caac9c3ea590b12b5af9a17471e9ace920976df3cbe68b18b5c935f9cff8e8942f9ccf1b9733621c5d5cec4834640920c412ce193bc4fa93eca6fbf97fe84 -> ripgrep_all-0.10.10-funtoo-crates-bundle-4d6462fcb14535fa85865f0e12fd24253562c7cd76f9c96e1f5446d806e06fa0bdacb440de0e31dd2eb7b86a77a015b44078b6be7103fdcd7424b35dd19f99f9.tar.gz"

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