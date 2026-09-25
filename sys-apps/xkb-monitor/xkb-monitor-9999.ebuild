# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Utility to monitor keyboard layout changes via xkbcommon"
HOMEPAGE="https://github.com/drougas/xkb-monitor"
EGIT_REPO_URI="https://github.com/drougas/xkb-monitor.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-libs/wayland
	>=x11-libs/libxkbcommon-1.0
"
DEPEND="${RDEPEND}
	dev-util/wayland-scanner
"

src_compile() {
	# Strip layer-shell support to avoid wayland-protocols dependency
	emake SKIP_WLR_LAYER_SHELL=1 OPTIMIZE="-O2" STRIP=true
}

src_install() {
	dobin xkb-monitor
}
