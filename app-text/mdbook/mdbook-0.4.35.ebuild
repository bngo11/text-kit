# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/94e0a44e152d8d7c62620e83e0632160977b1dd5 -> mdBook-0.4.35-94e0a44.tar.gz
https://direct.funtoo.org/4f/3a/d2/4f3ad257a6a3a18965e6409444c7da6e4ad323be2dca4077eb097e12af27da417282362bac5725e2bf1566b4d9458dc45d521b69575ab6aa5b3058d8ea3d12ba -> mdbook-0.4.35-funtoo-crates-bundle-fd2d2f7ee3b734781d1a225b9a9902fc239239b407b02dd4ebf74f294133bb965980e1c0d5172e93c4b5423622564dec6ca99e9484470d2929e87e0a0d6d3563.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-94e0a44"

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