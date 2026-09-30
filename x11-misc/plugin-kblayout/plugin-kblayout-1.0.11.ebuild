# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Keyboard layout switcher plugin for LXQt panel"
HOMEPAGE="https://github.com/sema1011/plugin-kblayout"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sema1011/plugin-kblayout.git"
else
	SRC_URI="https://github.com/sema1011/plugin-kblayout/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X wayland"

DEPEND="
	>=dev-qt/qtbase-6.5.0
	>=dev-qt/qttools-6.5.0
	>=lxqt-base/liblxqt-2.0.0
	>=dev-util/lxqt-build-tools-2.0.0
	>=x11-libs/libxkbcommon-1.0
	X? (
		x11-libs/libxcb[xkb]
		x11-libs/libxkbcommon[X]
	)
	wayland? (
		dev-libs/wayland
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DKBLAYOUT_X11=$(usex X ON OFF)
		-DKBLAYOUT_WAYLAND=$(usex wayland ON OFF)
	)

	cmake_src_configure
}
