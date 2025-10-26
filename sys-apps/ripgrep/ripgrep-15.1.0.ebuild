# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cargo

DESCRIPTION="A search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="https://github.com/BurntSushi/ripgrep/tarball/af60c2de9d85e7f3d81c78601669468cf02dabab -> ripgrep-15.1.0-af60c2d.tar.gz
https://direct.funtoo.org/48/d1/b9/48d1b960109252a7d7bfdbc61debee0879885963c94950ce1248ae54360ca8adf8a85d2a63c71537f57008c05a92ad33c6a756c5e05a26c8046d676d0a334929 -> ripgrep-15.1.0-funtoo-crates-bundle-919b7a0176bf0d5901f42c6d790d1d7ab430849fedb43d99ca64a177d013481753bd2c68f4da25557786cd24029f65964481bcf21a79ff1c10ab2b853bd648c1.tar.gz"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT Apache-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="+man pcre"

DEPEND=""

RDEPEND="pcre? ( dev-libs/libpcre2 )"

BDEPEND="${RDEPEND}
	virtual/pkgconfig
	>=virtual/rust-1.34
	man? ( app-text/asciidoc )
"

QA_FLAGS_IGNORED="/usr/bin/ripgrep"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/BurntSushi-ripgrep-* ${S} || die
}

src_compile() {
	# allow building on musl with dynamic linking support
	# https://github.com/BurntSushi/rust-pcre2/issues/7
	use elibc_musl && export PCRE2_SYS_STATIC=0
	cargo_src_compile $(usex pcre "--features pcre2" "")
}

src_install() {
	cargo_src_install $(usex pcre "--features pcre2" "")

	# hack to find/install generated files
	# stamp file can be present in multiple dirs if we build additional features
	# so grab fist match only
	local BUILD_DIR="$(dirname $(find target/release -name ripgrep-stamp -print -quit))"

	if use man ; then
		newman - rg.1 <<-EOF
		$(target/$(usex debug debug release)/rg --generate man)
		EOF
	fi

	newbashcomp - rg <<-EOF
	$(target/$(usex debug debug release)/rg --generate complete-bash)
	EOF

	insinto /usr/share/fish/vendor_completions.d
	newins - rg.fish <<-EOF
	$(target/$(usex debug debug release)/rg --generate complete-fish)
	EOF

	insinto /usr/share/zsh/site-functions
	newins - _rg <<-EOF
	$(target/$(usex debug debug release)/rg --generate complete-zsh)
	EOF


	dodoc CHANGELOG.md FAQ.md GUIDE.md README.md
}