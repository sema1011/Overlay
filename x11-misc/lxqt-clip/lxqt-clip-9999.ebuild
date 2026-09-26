# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="LXQt clipboard history applet"
HOMEPAGE="https://github.com/lxqt/lxqt-clip"
EGIT_REPO_URI="https://github.com/lxqt/lxqt-clip.git"
EGIT_PROJECT="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

PATCHES=(
	"${FILESDIR}"/cmake-remove-translate.patch
)

RDEPEND="
	dev-qt/qtbase:6[dbus,gui,widgets]
	>=kde-frameworks/kguiaddons-6.0:6
	x11-libs/libX11
	lxqt-base/liblxqt
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DQT_NO_PRIVATE_MODULE_WARNING=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Install desktop files (lxqt_translate_desktop removed by patch)
	insinto /usr/share/applications
	doins "${FILESDIR}"/lxqt-clip.desktop
	insinto /etc/xdg/autostart
	doins "${FILESDIR}"/lxqt-clip-autostart.desktop
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
