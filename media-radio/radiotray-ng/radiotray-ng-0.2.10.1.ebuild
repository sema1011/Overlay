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

PATCHES=(
	"${FILESDIR}/${P}-compatibility.patch"
)

src_prepare() {
	default
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
