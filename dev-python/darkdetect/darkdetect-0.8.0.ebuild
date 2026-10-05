# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Detect OS Dark Mode from Python"
HOMEPAGE="https://github.com/albertosottile/darkdetect"
SRC_URI="https://github.com/albertosottile/darkdetect/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"
