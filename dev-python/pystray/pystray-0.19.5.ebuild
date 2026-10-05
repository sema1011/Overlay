# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Cross platform tray icon for Python"
HOMEPAGE="https://github.com/moses-palmer/pystray"
SRC_URI="https://github.com/moses-palmer/pystray/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-libs/libayatana-appindicator
"
DEPEND="
	${RDEPEND}
"
