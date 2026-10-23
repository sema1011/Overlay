# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Updates daily and experimental GTNH packs to the latest version"
HOMEPAGE="https://github.com/Caedis/gtnh-daily-updater"
SRC_URI="https://github.com/Caedis/${PN}/releases/download/${PV}/${P}-linux-amd64.zip"
S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

src_install() {
	dobin gtnh-daily-updater
	default
}
