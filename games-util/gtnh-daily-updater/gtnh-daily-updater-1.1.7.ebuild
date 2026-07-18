# Copyright 2020-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Updates daily and experimental GTNH packs to the latest version"
HOMEPAGE="https://github.com/Caedis/gtnh-daily-updater"
LICENSE=""

SRC_URI="https://github.com/Caedis/${PN}/archive/refs/tags/1.1.7.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/sema1011/Dep/raw/refs/heads/main/${P}-deps.tar.xz"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	>=dev-lang/go-1.25.6
        >=dev-vcs/git-2.52.0
"

DEPEND="${RDEPEND}"

src_compile() {
    ego build
}

src_install() {
    dobin gtnh-daily-updater

    default
}