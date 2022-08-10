# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Home library with librusec/flibusta support"
HOMEPAGE="https://github.com/petrovvlad/freeLib"


if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/petrovvlad/freeLib.git"
	EGIT_SUBMODULES=('*')
	inherit git-r3
else
	SRC_URI="https://github.com/petrovvlad/freeLib/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/freeLib-${PV}"
fi


LICENSE="GPL-3"
SLOT="0"
IUSE=""
REQUIRED_USE="
"

RDEPEND="
	>=dev-qt/qtcore-5.15:5
	>=dev-qt/qtsql-5.15:5
	>=dev-qt/qtxml-5.15:5
	>=dev-qt/qtnetwork-5.15:5
	>=dev-qt/qtwidgets-5.15:5
	>=dev-libs/quazip-1.2
"
DEPEND="${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
"
BUILD_DIR="${WORKDIR}/${P}/freeLib/build"
CMAKE_USE_DIR="${WORKDIR}/${P}/"

src_configure() {
	CMAKE_BUILD_TYPE='Release'
	cmake_src_configure
}
