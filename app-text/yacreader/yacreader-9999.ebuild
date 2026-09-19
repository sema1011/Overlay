# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Yet Another Comic Reader - comic and manga reader"
HOMEPAGE="https://yacreader.com/"
EGIT_REPO_URI="https://github.com/YACReader/yacreader.git"
EGIT_BRANCH="develop"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-qt/qtbase:6=[gui,widgets,network,sql,svg,multimedia,opengl,shadercompiler,texttospeech]
	dev-qt/qtdeclarative:6=[qml,quick,quickcontrols2,quickwidgets,shadertools]
	dev-qt/qt5compat:6
	dev-qt/qtwayland:6
	media-libs/poppler[qt6]
	media-libs/libarchive
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
