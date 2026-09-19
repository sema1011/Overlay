# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="sqlite(+),ssl(+)"

inherit meson xdg

DESCRIPTION="Manga reader for GNOME"
HOMEPAGE="https://apps.gnome.org/Komikku/"
SRC_URI="https://codeberg.org/valos/Komikku/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/komikku"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/glib:2
	dev-libs/gobject-introspection
	x11-libs/gdk-pixbuf:2
	>=gui-libs/gtk-4.18:4
	>=gui-libs/gtksourceview-5:5
	>=gui-libs/libadwaita-1.8:1[introspection]
"
RDEPEND="
	${DEPEND}
	>=app-arch/brotli-1.2.0
	dev-python/beautifulsoup4
	dev-python/colorthief
	dev-python/dateparser
	dev-python/EbookLib
	dev-python/emoji
	dev-python/keyring
	dev-python/lxml
	dev-python/natsort
	dev-python/piexif
	>=dev-python/pillow-11.3.0
	dev-python/pygobject
	>=dev-python/pyjwt-2.10.1
	>=dev-python/pypdf-6.4.2
	dev-python/python-magic
	dev-python/pytesseract
	dev-python/rarfile
	>=dev-python/requests-2.32.4
	dev-python/unidecode
"
BDEPEND="
	dev-util/blueprint-compiler
	dev-util/desktop-file-utils
	sys-devel/gettext
	dev-libs/appstream
"

src_prepare() {
	meson_src_prepare

	# Fix broken shebang in launcher script
	sed "s|py_installation.full_path()|'${PYTHON}'|" -i bin/meson.build || die
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
