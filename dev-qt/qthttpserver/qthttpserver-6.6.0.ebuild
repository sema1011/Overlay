# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop llvm optfeature qt6-build

DESCRIPTION="Qt HTTP Server"

SRC_URI="https://github.com/qt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

IUSE="
"

REQUIRED_USE="
"

RESTRICT="test"

LLVM_MAX_SLOT=17

RDEPEND="
	dev-qt/qtbase:6
	dev-qt/qtwebsockets:6
"
DEPEND="
	${RDEPEND}
"

pkg_setup() {
	use clang && llvm_pkg_setup
}

src_configure() {

	qt6-build_src_configure
}

src_install() {

	qt6-build_src_install
}
