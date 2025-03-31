# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/b7a27d2759e80d804a33a4bc9c31b2b6863a5cb2 -> mdBook-0.4.48-b7a27d2.tar.gz
https://direct.funtoo.org/2f/8e/70/2f8e7000513b7546a1a21245f20660f5c1f409815cec771dcc74408fef3f7a589c00bba05eae1f45bb235160882051134cd2071345d4d8ab49c7eefc9d6771fc -> mdbook-0.4.48-funtoo-crates-bundle-1832443b4de3690f8f5c9857923492943c4037e0690a4e06aef27df9dfbbde4308e1195de9550f959800caa8c20e5223d370bfb0096becaa8497c70e9dcdd4ab.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-b7a27d2"

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