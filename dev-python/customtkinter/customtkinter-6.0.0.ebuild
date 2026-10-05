# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="CustomTkinter - Custom Widgets for Tkinter"
HOMEPAGE="https://github.com/TomSchimansky/CustomTkinter"
SRC_URI="https://github.com/TomSchimansky/CustomTkinter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"
S="${WORKDIR}/CustomTkinter-${PV}"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
