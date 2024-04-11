# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Small command-line JSON Log viewer"
HOMEPAGE="https://github.com/brocode/fblog"
SRC_URI="https://github.com/brocode/fblog/tarball/3d84f75930ee5db5d726a21263fa57c7800e6a24 -> fblog-4.9.0-3d84f75.tar.gz
https://direct.funtoo.org/df/52/f1/df52f12535016ae9708e2e9d0ca50188e5939d37cd26aba09bcfd758e0ee0e46eead8fb777362724daee9c8490dab060aff867342b072a74961254da82a2b94f -> fblog-4.9.0-funtoo-crates-bundle-2cb75687e7e70708b765a4409f159de6a8290ffa6bc1aee90b309c9fc5cc665f9ee5adb460e98080c8da0ae7bc317e550a3570305c56d068d092341b5bec4a6c.tar.gz"

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