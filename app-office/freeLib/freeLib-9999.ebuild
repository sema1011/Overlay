# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Cataloger for LibRusEc and Flibusta book libraries"
HOMEPAGE="https://github.com/petrovvlad/freeLib"

EGIT_REPO_URI="https://github.com/petrovvlad/freeLib.git"
EGIT_BRANCH="master"
# Клонируем только SmtpClient — для него нет системного аналога.
# quazip берём из системы (dev-libs/quazip).
EGIT_SUBMODULES=( '*' )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="djvu"

DEPEND="
	dev-libs/quazip
	dev-libs/qtkeychain
	dev-cpp/tbb
	app-arch/libarchive
	dev-qt/qtbase:6=[gui,widgets,network,sqlite]
	dev-qt/qtsvg:6
	dev-qt/qtwebsockets:6
	dev-qt/qthttpserver:6
	dev-qt/qt5compat:6
	djvu? ( app-text/djvu )
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qttools:6"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}
