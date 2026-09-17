# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit cmake wxwidgets xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ebruck/radiotray-ng.git"
else
	SRC_URI="https://github.com/ebruck/radiotray-ng/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="Internet radio player for Linux based on GStreamer"
HOMEPAGE="https://github.com/ebruck/radiotray-ng"
LICENSE="GPL-3+"
SLOT="0"
IUSE="appindicator test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/glibmm
	dev-libs/boost:=
	dev-libs/jsoncpp:=
	dev-libs/libbsd
	dev-libs/libxdg-basedir
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-good:1.0
	net-misc/curl
	x11-libs/libnotify
	x11-libs/wxGTK:${WX_GTK_VER}
	appindicator? ( dev-libs/libayatana-appindicator )
	!appindicator? ( sys-libs/ncurses:= )
"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/lsb-release"

src_prepare() {
	cmake_src_prepare

	# Патчи совместимости с актуальными версиями зависимостей
	sed -i \
		-e 's/-Werror//g' \
		-e 's/glibmm-2\.4/glibmm-2.68/g' \
		-e 's/giomm-2\.4/giomm-2.68/g' \
		-e 's/BusType::BUS_TYPE_SESSION/BusType::SESSION/g' \
		-e 's/BusType::BUS_TYPE_SYSTEM/BusType::SYSTEM/g' \
		-e 's/BusType::BUS_TYPE_STARTER/BusType::STARTER/g' \
		-e 's/CXX_STANDARD 14/CXX_STANDARD 17/' \
		-e 's/gnu++14/gnu++17/' \
		-e 's/pkg_search_module(APPINDICATOR REQUIRED ayatana-appindicator3-0.1)/pkg_search_module(APPINDICATOR ayatana-appindicator3-0.1)/' \
		CMakeLists.txt || die

	# BusType патчи нужны и в исходнике
	sed -i \
		-e 's/BusType::BUS_TYPE_SESSION/BusType::SESSION/g' \
		-e 's/BusType::BUS_TYPE_SYSTEM/BusType::SYSTEM/g' \
		-e 's/BusType::BUS_TYPE_STARTER/BusType::STARTER/g' \
		src/radiotray-ng/extras/rtng_dbus/rtng_dbus.cpp || die

    # user-agent.cmake пытается вызвать git, но в tarball нет .git — заглушаем
	sed -i 's/execute_process(COMMAND git/#execute_process(COMMAND git/' cmake/user-agent.cmake || die

}

src_configure() {
	setup-wxwidgets

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Удаляем autostart
	rm -f "${ED}/etc/xdg/autostart/radiotray-ng.desktop" || die

	# CMake ставит доки в /usr/share/doc/radiotray-ng/ — удаляем целиком
	rm -rf "${ED}/usr/share/doc/radiotray-ng" || die

	# Ставим документацию по-Gentoo-овски
	einstalldocs
}
