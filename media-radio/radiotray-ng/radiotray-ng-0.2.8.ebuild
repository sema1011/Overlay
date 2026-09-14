# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
# xdg-utils

DESCRIPTION="An Internet radio player"
HOMEPAGE="https://github.com/ebruck/radiotray-ng"
SRC_URI="https://github.com/ebruck/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/jsoncpp
	media-libs/gstreamer
	dev-libs/libxdg-basedir
	dev-libs/libbsd
	dev-libs/libappindicator:3
	x11-libs/libnotify
	dev-cpp/glibmm
	x11-libs/wxGTK:3.0-gtk3
	sys-apps/lsb-release
"
#    pkg_search_module(APPINDICATOR REQUIRED appindicator3-0.1)
#if (NOT APPINDICATOR_FOUND)
#    pkg_search_module(NCURSES      REQUIRED ncurses)



#src_configure() {
#	local mycmakeargs=(
#		-DBUILD_SHIBBOLETH_SUPPORT="$(usex shibboleth)"
#		-DBUILD_TESTING="$(usex test)"
#	)
#	cmake_src_configure
#}
