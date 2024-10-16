# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Calibre is an ebook management software"
HOMEPAGE="https://calibre-ebook.com"
SRC_URI="x86? ( http://download.calibre-ebook.com/5.38.0/calibre-5.38.0-i686.txz )
		amd64? ( http://download.calibre-ebook.com/5.38.0/calibre-5.38.0-x86_64.txz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!!app-text/calibre"

S="${WORKDIR}"

QA_PREBUILT="/opt/calibre-${PV}/*"

src_install() {
	# Bypass update-mime-database and update-desktop-database
	# to avoid clobbering the system cache
	mkdir "${T}/bin" || die
	cat - > "${T}/bin/update-mime-database" <<-EOF
	#!${BASH}
	exit 0
	EOF

	cp "${T}"/bin/update-{mime,desktop}-database || die
	chmod +x "${T}"/bin/update-{mime,desktop}-database || die
	PATH=${T}/bin:${PATH}

	XDG_DATA_DIRS="${D}/usr/share"
	dodir /opt/calibre-${PV}
	dodir /usr/share/applications
	dodir /usr/share/icons/hicolor
	dodir /usr/share/desktop-directories
	dodir /usr/share/mime/packages

	cp -r ${S}/* ${D}/opt/calibre-${PV}/
	newinitd "${FILESDIR}"/calibre-server-3.init calibre-server
	newconfd "${FILESDIR}"/calibre-server-3.conf calibre-server

	${D}/opt/calibre-${PV}/calibre_postinstall --root=${D}/usr
	rm ${D}/opt/calibre-${PV}/{,bin/}calibre{*install,-complete}

	cat <<- EOF > ${T}/calibre.symlink
		#!/bin/sh

		export QT_QPA_PLATFORM_PLUGIN_PATH=/opt/calibre-${PV}/plugins
		export LD_LIBRARY_PATH=/opt/calibre-${PV}/lib:$LD_LIBRARY_PATH

		/opt/calibre-${PV}/calibre --no-update-check \$@
		EOF

	for file in ${D}/opt/calibre-${PV}/*; do
		[ -f ${file} ] && dosym ${file/${D}/} /usr/bin/$(basename ${file})
	done
	newbin ${T}/calibre.symlink calibre
}