# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs xdg-utils

CMAKE_BUILD_TYPE=""
SRC_URI="https://api.github.com/repos/freedesktop/poppler/tarball/refs/tags/poppler-22.02.0 -> poppler-22.02.0.tar.gz"
KEYWORDS="*"
SLOT="0/118"

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="https://poppler.freedesktop.org/"

LICENSE="GPL-2"
IUSE="cairo cjk curl +cxx debug doc +introspection +jpeg +jpeg2k +lcms nss png qt5 tiff +utils"

# No test data provided
RESTRICT="test"

BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"
DEPEND="
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	cairo? (
		dev-libs/glib:2
		x11-libs/cairo
		introspection? ( dev-libs/gobject-introspection:= )
	)
	curl? ( net-misc/curl )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( >=media-libs/openjpeg-2.3.0-r1:2= )
	lcms? ( media-libs/lcms:2 )
	nss? ( >=dev-libs/nss-3.19:0 )
	png? ( media-libs/libpng:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtxml:5
	)
	tiff? ( media-libs/tiff:0 )
"
RDEPEND="${DEPEND}
	cjk? ( app-text/poppler-data )
"

DOCS=( AUTHORS NEWS README.md README-XPDF )

PATCHES=(
	"${FILESDIR}/${PN}-20.12.1-qt5-deps.patch"
	"${FILESDIR}/${PN}-0.57.0-disable-internal-jpx.patch"
)

src_unpack() {
	unpack $A
	mv ${WORKDIR}/freedesktop-poppler-* ${S} || die
}

src_prepare() {
	cmake_src_prepare

	# Clang doesn't grok this flag, the configure nicely tests that, but
	# cmake just uses it, so remove it if we use clang
	if [[ ${CC} == clang ]] ; then
		sed -e 's/-fno-check-new//' -i cmake/modules/PopplerMacros.cmake || die
	fi

	if ! grep -Fq 'cmake_policy(SET CMP0002 OLD)' CMakeLists.txt ; then
		sed -e '/^cmake_minimum_required/acmake_policy(SET CMP0002 OLD)' \
			-i CMakeLists.txt || die
	else
		einfo "policy(SET CMP0002 OLD) - workaround can be removed"
	fi
}

src_configure() {
	xdg_environment_reset
	local mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT5_TESTS=OFF
		-DBUILD_CPP_TESTS=OFF
		-DRUN_GPERF_IF_PRESENT=OFF
		-DENABLE_SPLASH=ON
		-DENABLE_ZLIB=ON
		-DENABLE_ZLIB_UNCOMPRESS=OFF
		-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
		-DUSE_FLOAT=OFF
		-DWITH_Cairo=$(usex cairo)
		-DENABLE_LIBCURL=$(usex curl)
		-DENABLE_CPP=$(usex cxx)
		-DWITH_JPEG=$(usex jpeg)
		-DENABLE_DCTDECODER=$(usex jpeg libjpeg none)
		-DENABLE_LIBOPENJPEG=$(usex jpeg2k openjpeg2 none)
		-DENABLE_CMS=$(usex lcms lcms2 none)
		-DWITH_NSS3=$(usex nss)
		-DWITH_PNG=$(usex png)
		$(cmake_use_find_package qt5 Qt5Core)
		-DWITH_TIFF=$(usex tiff)
		-DENABLE_UTILS=$(usex utils)
		-DENABLE_QT6=OFF
	)
	use cairo && mycmakeargs+=( -DWITH_GObjectIntrospection=$(usex introspection) )

	cmake_src_configure
}

src_install() {
	cmake_src_install
}