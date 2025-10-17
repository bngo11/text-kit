# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cargo

DESCRIPTION="A search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="https://github.com/BurntSushi/ripgrep/tarball/3a612f88b805e14aef45bfa43e25a54abc6297fc -> ripgrep-15.0.0-3a612f8.tar.gz
https://direct.funtoo.org/70/41/76/704176605dc7d8ba1f480ec41caadc702ea3226ff89faca8eee0509b974bb206726338a0faef05b3861dafe8cfdf39274ce848d831d637dcf8041324b1b25950 -> ripgrep-15.0.0-funtoo-crates-bundle-41ca4e0c548bbb8156339e6c4dcb1bc9b7409f4ed0c882000ad338658e6138ab1e3afb392bdf2ffddabc102650d9e1799d25b0a572f28b747959728044870f0f.tar.gz"

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