# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7


inherit meson vala xdg

DESCRIPTION="Wallpaper App for Linux"
HOMEPAGE="https://github.com/calo001/fondo"
SRC_URI="https://github.com/calo001/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

BUILD_DIR="${WORKDIR}/${P}-build"

LICENSE="GPL-3.0"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-libs/glib-2.50:2
	>=x11-libs/gtk+-3.22:3[introspection]
	dev-util/meson
	dev-lang/vala
	dev-libs/granite
	dev-libs/json-glib
	net-libs/libsoup:2.4
	x11-libs/xapp
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	meson_src_configure
}
