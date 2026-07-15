# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cargo

DESCRIPTION="A search tool that combines the usability of ag with the raw speed of grep"
HOMEPAGE="https://github.com/BurntSushi/ripgrep"
SRC_URI="https://github.com/BurntSushi/ripgrep/tarball/e89fff89ac9af12e8d4ce9d5fd07beb408ca730f -> ripgrep-15.2.0-e89fff8.tar.gz
https://direct.funtoo.org/f4/f1/9e/f4f19eeff70f66b007cb89d3ce4b053195e8d9b89d6b64fce0e6f3a4558b9926bd81e517421dcede9eaa5caab2ba27cd531184a51ed324b3b418591750a044b7 -> ripgrep-15.2.0-funtoo-crates-bundle-b75405efe059b46ab03ab8a346d44b302918523c37be62d46427a7bbc8d8b3134c1a668fa5aaf159839131b8c813e521648fb8651b4be757703130242536ff24.tar.gz"

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