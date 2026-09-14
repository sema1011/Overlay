EAPI=8
inherit cmake

# xdg-utils
DESCRIPTION="An Internet radio player"
HOMEPAGE="https://github.com/ebruck/radiotray-ng"
SRC_URI="https://github.com/ebruck/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3.0-only"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test shibboleth appindicator ncurses curl"
IUSE_DESCRIPTION="\
    test: Build and run tests (requires a test framework)\n\
    shibboleth: Support for Shibboleth authentication\n\
    appindicator: Use AppIndicator to create system tray icons\n\
    ncurses: Enable support for console mode\n\
    curl: Require CURL library for network requests"
RESTRICT=""

RDEPEND="
    dev-libs/jsoncpp
    media-libs/gstreamer
    dev-libs/libxdg-basedir
    dev-libs/libbsd
	appindicator? ( dev-libs/libappindicator:= )
    x11-libs/libnotify
    dev-cpp/glibmm
    dev-cpp/giomm
    x11-libs/wxGTK:3.0-gtk3
    sys-apps/lsb-release
    ncurses? ( dev-libs/ncurses:= )
    curl? ( net-misc/curl:= )
"
DEPEND="${RDEPEND}
"

src_prepare() {
    cd "${S}" || return 1
    # Extract source code
    tar xjf ${P}.tar.bz2
}

src_configure() {
    local USE="$1"
    local OPTIONS=""
    if use appindicator; then
        OPTIONS+=" -DWITH_APPINDICATOR=ON "
    fi
    if use ncurses; then
        OPTIONS+=" -DWITH_NCURSES=ON "
    fi
    if use curl; then
        OPTIONS+=" -DCURL_LIBRARY=libcurl \
                   -DCURL_INCLUDEDIR=/usr/include/curl \
                  "
    fi

    cmake_src_configure "-DWITH_SHIBBOLETH=${USE_shibboleth:-OFF} \
                        -DBUILD_TESTING=${USE_test:=-OFF}" "${OPTIONS}" .
}
