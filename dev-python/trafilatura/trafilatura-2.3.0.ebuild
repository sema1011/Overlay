# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python & Command-line tool to gather text and metadata on the Web"
HOMEPAGE="https://github.com/adbar/trafilatura"
SRC_URI="https://github.com/adbar/trafilatura/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/charset-normalizer[${PYTHON_USEDEP}]
	dev-python/courlan[${PYTHON_USEDEP}]
	dev-python/htmldate[${PYTHON_USEDEP}]
	dev-python/justext[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
