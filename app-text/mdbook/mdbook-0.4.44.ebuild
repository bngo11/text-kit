# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="https://github.com/rust-lang/mdBook/tarball/40d91fff29af051a400c866d53653d69b7529298 -> mdBook-0.4.44-40d91ff.tar.gz
https://direct.funtoo.org/7a/84/92/7a8492e9ced0fca4a4e626d257eee194ed3825c90946dc4a52c809525a742e981ab6e96df7291ffde52126ecc0e45cd207b909700affe559983782fb5c6df69e -> mdbook-0.4.44-funtoo-crates-bundle-4a4b465c481e86d55c6ccc6c98b4a3725d0f11fe32175c4e55464b4159229c1073efa138ec30d68fe4fb341cc2f964d074ee92badf1cc7c37e98529ef6b725a6.tar.gz"
S="${WORKDIR}/rust-lang-mdBook-40d91ff"

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