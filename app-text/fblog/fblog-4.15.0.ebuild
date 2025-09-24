# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Small command-line JSON Log viewer"
HOMEPAGE="https://github.com/brocode/fblog"
SRC_URI="https://github.com/brocode/fblog/tarball/33fb2ffd82b623b718d2072a986e574eecabad02 -> fblog-4.15.0-33fb2ff.tar.gz
https://direct.funtoo.org/7c/85/7a/7c857af498a366fd652f67ce07a39b64c62a382388dea829bbb13052874edf54f9313551a703366fcd869e54b5af9bb682adecb0230d386ff01c64a4b5f31eac -> fblog-4.15.0-funtoo-crates-bundle-c06b1fa203705945e5f62158c262c359d88efbf724e2e4fd9a9655fc95334c22166ce9413ccf9b6e5cae0d025562946c882fd16002856ec20bc3408fc2145768.tar.gz"

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