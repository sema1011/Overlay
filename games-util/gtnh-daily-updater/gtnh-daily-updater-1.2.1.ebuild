# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Updates daily and experimental GTNH packs to the latest version"
HOMEPAGE="https://github.com/Caedis/gtnh-daily-updater"
LICENSE="GPL-2.0-or-later"

SRC_URI="https://github.com/Caedis/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/sema1011/Dep/raw/refs/heads/main/${P}-deps.tar.xz"

SLOT="0"
KEYWORDS="~amd64 ~x86"

# Go компилирует статические бинарники — go нужен только для сборки
BDEPEND="
    >=dev-lang/go-1.25.6
"

# git нужен в рантайме — инструмент работает с git-репозиториями модпаков
RDEPEND="dev-vcs/git"

src_compile() {
	ego build -o gtnh-daily-updater .
}

src_install() {
	dobin gtnh-daily-updater
	default
}
