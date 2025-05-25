# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/cdbf6d2806ca182b148eef1288a15381f58c199c -> mdBook-0.4.50-cdbf6d2.tar.gz
https://direct.funtoo.org/31/49/04/3149049427a026ba459429d023660174472b4489b98e59ebb368963e6431a67a3f693acfd794f376cea78e38a10b900dc1c50d167692b489dc6950964cd1a298 -> mdbook-0.4.50-funtoo-crates-bundle-ccaa5c05bfa33215ddf9051b8ce5586d5ac9935422e30a39a5abfc8862d6f7afdc86d3979a45fd92d25537187ccbd920698e6c8ea89589f4acd1ac801d9b765a.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-cdbf6d2"

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