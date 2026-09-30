# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="xdotool type for wayland"
HOMEPAGE="https://github.com/atx/wtype"
SRC_URI="https://github.com/atx/wtype/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/wayland-1.0:0=
	>=x11-libs/libxkbcommon-1.0:0=
"
RDEPEND="${DEPEND}"
