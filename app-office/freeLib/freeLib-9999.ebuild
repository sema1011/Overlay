# Copyright 2020-2023 Gentoo Authors
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
IUSE="X qt6 qt6-imageformats"
REQUIRED_USE="
	qt6-imageformats? ( qt6 )
"

KIMAGEFORMATS_RDEPEND="
	media-libs/libavif:=
	media-libs/libheif:=
	media-libs/libjxl
"
CDEPEND="
"
RDEPEND="
	>=dev-libs/quazip-1.2
	!qt6? (
	>=dev-qt/qtcore-5.15:5=
	>=dev-qt/qtsql-5.15:5
	>=dev-qt/qtgui-5.15:5=[jpeg,png,X?]
	>=dev-qt/qtimageformats-5.15:5
	>=dev-qt/qtxml-5.15:5
	>=dev-qt/qtnetwork-5.15:5[ssl]
	>=dev-qt/qtsvg-5.15:5
	>=dev-qt/qtwidgets-5.15:5[png,X?]
	)
	qt6? (
	>=dev-qt/qtbase-6.5:6=[gui,network,opengl,widgets,X?]
	>=dev-qt/qtimageformats-6.5:6
	>=dev-qt/qtsvg-6.5:6
	>=dev-qt/qthttpserver-6.6.0
	qt6-imageformats? (
		>=dev-qt/qtimageformats-6.5:6=
		${KIMAGEFORMATS_RDEPEND}
		)
	)
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
	append-flags -Wa,--noexecstack
	cmake_src_configure
}
