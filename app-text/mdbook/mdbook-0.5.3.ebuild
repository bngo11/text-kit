# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/0ea415897758ea9b2904ed47ba9cb4901f9eb089 -> mdBook-0.5.3-0ea4158.tar.gz
https://direct.funtoo.org/5d/cb/b3/5dcbb3846f81613c92e41d2769f23d403c907ba63671ca3d97d2ba237e023c8665fa6fe39fcd8cbd0193e8b3211f718a09e19616b7a1672fb7e222bf926c3652 -> mdbook-0.5.3-funtoo-crates-bundle-4a945609d4b50472094e0804f714ce2993fc7208254d2db761a5f1f652525c72c5f1d0b4351e6c87e387b393d2e4c21f8c9c960b7b16a9955cec5de341d664d5.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-0ea4158"

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