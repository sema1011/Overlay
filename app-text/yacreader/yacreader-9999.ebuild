# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt6 git-r3

DESCRIPTION="Yet Another Comic Reader - comic and manga reader"
HOMEPAGE="https://yacreader.com/"
EGIT_REPO_URI="https://github.com/YACReader/yacreader.git"
EGIT_BRANCH="develop"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-qt/qtcore:6
	dev-qt/qtgui:6
	dev-qt/qtwidgets:6
	dev-qt/qtquick:6
	dev-qt/qtquickcontrols2:6
	dev-qt/qtquickwidgets:6
	dev-qt/qtqml:6
	dev-qt/qtqmlworkerscript:6
	dev-qt/qtsql:6
	dev-qt/qtmultimedia:6
	dev-qt/qtnetwork:6
	dev-qt/qtsvg:6
	dev-qt/qtopenglwidgets:6
	dev-qt/qtshadertools:6
	dev-qt/qttexttospeech:6
	dev-qt/qt5compat:6
	media-libs/poppler[qt6]
	media-libs/libarchive
"
RDEPEND="${DEPEND}"

BDEPEND="
	dev-build/cmake
	dev-util/qt6-tools:[assistant,designer]
	dev-util/extra-cmake-modules
	virtual/pkgconfig
"

src_configure()
	cmake_build \
		-DBUILD_TESTS=OFF \
		-DBUILD_SERVER_STANDALONE=OFF \
		-DDECOMPRESSION_BACKEND=libarchive \
		-DPDF_BACKEND=poppler

src_install()
	cmake_src_install
