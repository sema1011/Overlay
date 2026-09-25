# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Collection of CMake modules for Qt-based projects by Qtilities"
HOMEPAGE="https://github.com/qtilities/qtilitools"
SRC_URI="https://github.com/qtilities/qtilitools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="
	dev-build/cmake
"

src_install() {
	cmake_src_install
}
