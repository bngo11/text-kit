# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/94b922d27aea47183ebf270e2f6f32561d960852 -> mdBook-0.4.40-94b922d.tar.gz
https://direct.funtoo.org/b8/29/a6/b829a69a2d8ed6841e7a52da59b25a95435b05c3d8006b42526c736c460e1b14a37601cac585ceb1449169e8b93e6698f4193cd213eadf4fa8acf0d173d69857 -> mdbook-0.4.40-funtoo-crates-bundle-b0bc51d6571af35c26111b8f32bc2bd2337edbe4cc3c2f632fd8df25f2733602cb25bbf20f4fe42fc0d7332c541354b39e3f985a4d1c09ab92ad69b206f0ad06.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-94b922d"

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