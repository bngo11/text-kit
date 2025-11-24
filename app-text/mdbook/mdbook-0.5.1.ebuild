# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/d63aeb6526356464f627b2d7de413b5b6bbb87c2 -> mdBook-0.5.1-d63aeb6.tar.gz
https://direct.funtoo.org/1d/43/17/1d4317e6ddfd1ba6a32101ccbf87941f527ffe0f0882f52047b3029e57a21648fc24ebb007950c73d00e4e7472067d39bbbeba2ff49ac82de8e474fd80680179 -> mdbook-0.5.1-funtoo-crates-bundle-80746f32052bb657bd1b8145269b41219c0bb8550c57843f5a238d00d20e2fe96d501f08c2ac3ad18920821e63ae173454eebd80be19b186e9d1571f311029af.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-d63aeb6"

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