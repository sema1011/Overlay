# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg-utils

DESCRIPTION="Qt6 only RSS/Atom feed reader without HTML engine"
HOMEPAGE="https://gitverse.ru/sema1011/QtFeed"
EGIT_REPO_URI="https://gitverse.ru/sema1011/QtFeed.git"

LICENSE="GPL-3+"
SLOT="0"
IUSE="clang lto tests wayland"

DEPEND="
	>=dev-qt/qtbase-6.2:6=[dbus,sql,widgets,xml,network]
	>=dev-qt/qtsvg-6:6
	>=dev-qt/qtimageformats-6:6
	>=dev-qt/qttools-6:6
	dev-libs/libxml2:=
	dev-db/sqlite:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DENABLE_LTO=$(usex lto ON OFF)
		-DQTFEED_BUILD_TESTS=$(usex tests ON OFF)
		-DHAVE_X11=$(usex wayland OFF ON)
		-DHAVE_WAYLAND=$(usex wayland ON OFF)
	)

	if use clang; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER=clang
			-DCMAKE_CXX_COMPILER=clang++
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
