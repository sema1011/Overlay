EAPI=8
inherit cmake xdg-utils

DESCRIPTION="An Internet radio player"
HOMEPAGE="https://github.com/ebruck/radiotray-ng"
SRC_URI="https://github.com/ebruck/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

IUSE_DESCRIPTION="\
    test: Build and run tests (requires a test framework)\n\
    "
RDEPEND="
    dev-libs/jsoncpp
    media-libs/gstreamer
    media-plugins/gst-plugins-meta
    dev-libs/libxdg-basedir
    dev-libs/libbsd
	dev-libs/libayatana-appindicator
    x11-libs/libnotify
    dev-cpp/glibmm
    x11-libs/wxGTK
    sys-apps/lsb-release
    sys-libs/ncurses
    net-misc/curl
"
DEPEND="${RDEPEND}
"
src_prepare() {
    cmake_src_prepare
    cd "${S}" || return 1
    find "${S}" -name "*.gz" -o -name "*changelog*" -exec rm {} \; 2>/dev/null || true
    eapply_user
}

src_configure() {
    CMAKE_BUILD_TYPE='Release'
#	local mycmakeargs=(
#		-DBUILD_TESTING="$(usex test)"
#	)
    cmake_src_configure 
}

pkg_postinst () {
    xdg_icon_cache_update
    rm -f /etc/xdg/autostart/radiotray-ng.desktop
}
