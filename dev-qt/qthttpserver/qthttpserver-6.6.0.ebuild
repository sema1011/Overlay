# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt HTTP Server"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

#SRC_URI="https://github.com/qt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
#KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

IUSE="
"

RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6
	dev-qt/qtwebsockets:6
"
DEPEND="
"
src_prepare() {
	qt6-build_src_prepare
}

src_configure() {

	local qt=$(usex qt6 6 5)
	local mycmakeargs=(
	-DQT_VERSION_MAJOR=${qt}
	)
	qt6-build_src_configure

}

src_install() {

	qt6-build_src_install
}
