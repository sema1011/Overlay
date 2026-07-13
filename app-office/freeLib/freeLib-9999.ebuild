# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic cmake xdg

DESCRIPTION="Home library with librusec/flibusta support"
HOMEPAGE="https://github.com/petrovvlad/freeLib"


if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/petrovvlad/freeLib.git"
	inherit git-r3
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/petrovvlad/freeLib/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/freeLib-${PV}"
fi


LICENSE="GPL-3"
SLOT="0"

IUSE=""
REQUIRED_USE="
"

CDEPEND="
"

RDEPEND="
	>=dev-qt/qtbase-6.5:6=[gui,widgets,xml,dbus,network,sql]
	>=dev-qt/qthttpserver-6.5:6=[websockets]
	>=dev-qt/qtsvg-6.5:6
	>=dev-libs/quazip-1.5
	dev-cpp/tbb
	dev-libs/qtkeychain
	>=app-arch/libarchive-3.8.7
	app-text/djvu
	app-text/poppler
	kde-frameworks/kio
	kde-frameworks/kstatusnotifieritem
"

DEPEND="${RDEPEND}
"

BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-4.1.4
"
BUILD_DIR="${WORKDIR}/${P}/freeLib/build"
CMAKE_USE_DIR="${WORKDIR}/${P}/"

src_configure() {
	CMAKE_BUILD_TYPE='Release'
	local mycmakeargs=(
	
	)
	append-flags -Wa,--noexecstack
	cmake_src_configure
}
