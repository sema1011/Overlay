# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

EGIT_REPO_URI="https://github.com/sema1011/fb2info.git"

inherit git-r3 python-r1

DESCRIPTION="Simple FB2 thumbnailer for Linux desktop file managers"
HOMEPAGE="https://github.com/sema1011/fb2info"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/pillow[${PYTHON_USEDEP}]')
"
DEPEND="${RDEPEND}"

src_install() {
	dobin fb2info.py
	doins fb2.thumbnailer
}
