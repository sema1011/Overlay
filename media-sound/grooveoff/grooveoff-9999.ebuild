# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Offline Grooveshark.com music"
HOMEPAGE="https://github.com/gcala/grooveoff"
EGIT_REPO_URI="https://github.com/gcala/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	media-libs/taglib:=
	dev-libs/kdsingleapplication
	dev-qt/qtbase:6=[gui,widgets,network,xml,dbus]
	dev-qt/qtsvg:6
	dev-qt/qtmultimedia:6
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/qttools:6
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}

# CMakeLists.txt already handles all installation

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
