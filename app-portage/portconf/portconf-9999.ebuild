# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v3+

EAPI=8

inherit git-r3

DESCRIPTION="/etc/portage cleaner"
HOMEPAGE="https://github.com/sema1011/portconf"
EGIT_REPO_URI="https://github.com/sema1011/portconf.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~*"
IUSE=""

src_install(){
	insinto /etc/
	newins portconf.conf portconf.conf
	dobin portconf
}
