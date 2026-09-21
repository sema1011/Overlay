# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Updates daily and experimental GTNH packs to the latest version"
HOMEPAGE="https://github.com/Caedis/gtnh-daily-updater"
LICENSE="GPL-2.0-or-later"
KEYWORDS="~amd64"
SLOT="0"

SRC_URI="https://github.com/Caedis/${PN}/releases/download/${PV}/${P}-linux-amd64.zip"

S="${WORKDIR}"

src_install() {
	dobin gtnh-daily-updater
	default
}
