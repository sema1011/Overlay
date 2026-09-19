# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Yet Another Comic Reader - comic and manga reader"
HOMEPAGE="https://yacreader.com/"
SRC_URI="https://github.com/YACReader/yacreader/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtbase:6=[gui,widgets,network,sql,opengl]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
	dev-qt/qtspeech:6
	dev-qt/qtdeclarative:6=[opengl,svg]
	dev-qt/qt5compat:6
	app-text/poppler[qt6]
	app-arch/libarchive
"
RDEPEND="${DEPEND}"

BDEPEND="
	dev-qt/qttools:6
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
		-DBUILD_SERVER_STANDALONE=OFF
		-DDECOMPRESSION_BACKEND=libarchive
		-DPDF_BACKEND=poppler
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
