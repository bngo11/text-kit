# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/2ea30c00f00647d2b3f4c0f79b3e0e1eabc0b66d -> mdBook-0.5.4-2ea30c0.tar.gz
https://direct.funtoo.org/08/9d/b6/089db6041fe2785291800f53a49f6f70b9e2b4d25283059de2c92c543c4970a7be2b9f42ac3dcc7534ae260afc7c1d21e757a499985e5237cdc8a6ff01aebe56 -> mdbook-0.5.4-funtoo-crates-bundle-5e883e412af6c9569dc6ed33522c942bf052b25b02a4c9e0df918cf60a6aa0179038211cc417f18292d627debed24c0100ba43026a8129e6b2af84821931597b.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-2ea30c0"

# CC-BY-4.0/OFL-1.1: embeds fonts inside the executable
LICENSE="MPL-2.0 CC-BY-4.0 OFL-1.1"
LICENSE+="
	Apache-2.0 BSD ISC MIT Unicode-DFS-2016
	|| ( Artistic-2 CC0-1.0 )
" # crates
SLOT="0"
KEYWORDS="*"
IUSE="doc"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_compile() {
	cargo_src_compile

	if use doc; then
		if tc-is-cross-compiler; then
			ewarn "html docs were skipped due to cross-compilation"
		else
			target/$(usex debug{,} release)/${PN} build -d html guide || die
		fi
	fi
}

src_install() {
	cargo_src_install

	dodoc CHANGELOG.md README.md
	use doc && ! tc-is-cross-compiler && dodoc -r guide/html
}