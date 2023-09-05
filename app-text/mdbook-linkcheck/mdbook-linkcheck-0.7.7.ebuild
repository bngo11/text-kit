# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo flag-o-matic

DESCRIPTION="A backend for 'mdbook' which will check your links for you."
HOMEPAGE="https://github.com/Michael-F-Bryan/mdbook-linkcheck"
SRC_URI="https://github.com/Michael-F-Bryan/mdbook-linkcheck/tarball/bed5ebbae325d41bdccec382ecbe30f795738ca2 -> mdbook-linkcheck-0.7.7-bed5ebb.tar.gz
https://direct.funtoo.org/35/c3/ab/35c3abda81bbfdc9e5ef2156cf5b6c7883b9212aa81d5e4f2a15df90a097f499879b9e46b61aebba24cf612e422197b201fabfb972ffc9d451c7cf61e0784a10 -> mdbook-linkcheck-0.7.7-funtoo-crates-bundle-9e5f0c9c5a30a338cfa884b513e1a28164406fe5a5f9423346e2456a956730633ea578619d227ffb521568d0ed0267cd7d7a22ba14f2186cae6879b14f2c3dc6.tar.gz"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}/Michael-F-Bryan-mdbook-linkcheck-bed5ebb"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

QA_FLAGS_IGNORED="usr/bin/${PN}"