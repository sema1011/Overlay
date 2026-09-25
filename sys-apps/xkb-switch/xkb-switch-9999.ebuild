# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Switch and query keyboard layout via X11 XKB protocol"
HOMEPAGE="https://github.com/ierton/xkb-switch"
EGIT_REPO_URI="https://github.com/ierton/xkb-switch.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libxkbfile
"
DEPEND="${RDEPEND}"

src_install() {
	cmake_src_install
}
