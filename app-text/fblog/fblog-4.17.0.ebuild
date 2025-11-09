# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Small command-line JSON Log viewer"
HOMEPAGE="https://github.com/brocode/fblog"
SRC_URI="https://github.com/brocode/fblog/tarball/04c8984abf2d1081f8a17733f0b5a14460f578a8 -> fblog-4.17.0-04c8984.tar.gz
https://direct.funtoo.org/c1/77/46/c1774606a9fa2971eba01c51ecdcebc538430fe4035c55a6683f13058cb4b4e0c509ea793cb2c12b828f76fa8ffeb837f4f2753dea1e3fe38617f5dbb3f1e6e8 -> fblog-4.17.0-funtoo-crates-bundle-24d42fa2be1a41f8aff21926291d2c8819083cf1f950a7d15a7c697491ba69a172f9db89e2ae7bba27e152c9055fbb7c950ee237be4f0e6ef6804ca3dcf495b5.tar.gz"

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