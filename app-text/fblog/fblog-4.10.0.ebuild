# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Small command-line JSON Log viewer"
HOMEPAGE="https://github.com/brocode/fblog"
SRC_URI="https://github.com/brocode/fblog/tarball/269966f4c2fcf61544c9ef92342f56b04e152fbe -> fblog-4.10.0-269966f.tar.gz
https://direct.funtoo.org/d6/ac/79/d6ac797d5fa3b17b2273e8a5e16b5eccbb5bc5fa0bd08106f1f9dbc76bc1b5077189de87aa6590daabc0d494d2ea2ab6c54763ba7571f3f25328830c70084dc7 -> fblog-4.10.0-funtoo-crates-bundle-007e27cdcde2cbeca6f96cc6062df96b576d9fd0fe76d00ea37594a271cf007089d7b970ae37a5c2475a647d0ab076cbeb822a493e8a12be99932422e2a30fef.tar.gz"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT Apache-2.0 Unlicense WTFPL-2 ZLIB"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

DOCS=(
	README.md
	sample.json.log
	sample_context.log
	sample_nested.json.log
	sample_numbered.json.log
)

QA_FLAGS_IGNORED="/usr/bin/fblog"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/brocode-fblog-* ${S} || die
}