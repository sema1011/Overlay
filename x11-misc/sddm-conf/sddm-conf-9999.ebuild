# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="SDDM configuration editor written in C++"
HOMEPAGE="https://github.com/qtilities/sddm-conf"

EGIT_REPO_URI="https://github.com/qtilities/sddm-conf.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

BDEPEND="
	>=dev-cpp/qtilitools-0.1.2
	>=dev-qt/qttools-6:6[linguist]
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	>=sys-auth/polkit-0.110:=[introspection]
	x11-misc/sddm
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DPROJECT_QT_VERSION=6
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
