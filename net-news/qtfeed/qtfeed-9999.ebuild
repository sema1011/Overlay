# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 qmake-utils xdg

DESCRIPTION="Qt5/Qt6 only RSS/Atom feed reader without HTML engine"
HOMEPAGE="https://gitverse.ru/sema1011/QtFeed"
EGIT_REPO_URI="https://gitverse.ru/sema1011/QtFeed.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-qt/qtbase-6.2:6=[dbus,sql,widgets,xml,network]
	>=dev-qt/qtsvg-6:6
	>=dev-qt/qtimageformats-6:6
	>=dev-qt/qttools-6:6
	>=dev-qt/qt5compat-6:6
	dev-libs/libxml2:=
	dev-db/sqlite:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/python
"

src_configure() {
	local myqmakeargs=(
		"USE_QT=6"
		"CONFIG+=release"
		"CONFIG-=debug_and_release"
		"PREFIX=/usr"
		"QMAKE_LIBDIR=/usr/$(get_libdir)"
	)

	cd "${S}" || die
	qmake6 "${myqmakeargs[@]}"
}

src_compile() {
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
