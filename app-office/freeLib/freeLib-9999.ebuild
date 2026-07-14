# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Home library with librusec/flibusta support"
HOMEPAGE="https://github.com/petrovvlad/freeLib"
LICENSE="GPL-3"

EGIT_REPO_URI="https://github.com/petrovvlad/${PN}.git"

SLOT="0"
KEYWORDS="~amd64 ~x86"

QTMIN=6.10.3
IUSE="djvu"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[gui,widgets,xml,dbus,network,sql]
	>=dev-qt/qthttpserver-${QTMIN}:6=[websockets]
	>=dev-qt/qtsvg-${QTMIN}:6
	dev-libs/quazip
	dev-cpp/tbb
	dev-libs/qtkeychain
	app-arch/libarchive
	djvu? ( app-text/djvu:= )
	app-text/poppler
	kde-frameworks/kio
	kde-frameworks/kstatusnotifieritem
"

DEPEND="${RDEPEND}"

BUILD_DIR="${WORKDIR}/${P}/freeLib/build"
CMAKE_USE_DIR="${WORKDIR}/${P}/"

src_configure() {
	CMAKE_BUILD_TYPE='Release'
	local mycmakeargs=(
			$(cmake_use_find_package djvu DjVuLibre)
		)
	cmake_src_configure
}
