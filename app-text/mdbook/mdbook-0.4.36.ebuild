# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/b7f46213c7df8f499eca0c82e7b41804cc15e369 -> mdBook-0.4.36-b7f4621.tar.gz
https://direct.funtoo.org/f9/01/aa/f901aa95417ad60fb8ff48b4610b34fc669e4f525296f8443ec8577874b727955a552f319f807293ee89f3a4afc3396bc95c94d81a759f4ad8fb89b2183cbf10 -> mdbook-0.4.36-funtoo-crates-bundle-128e0fc353029bd355e37881fb40f906da2a82711878d17d9b44d6b7c1c7bcab6a4d9f0d14eb2ed783e54501279e10d09229b7f07c320fc5486aa7af2e97811b.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-b7f4621"

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