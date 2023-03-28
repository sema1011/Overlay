# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm linux-info

DESCRIPTION="Core control application."
HOMEPAGE="https://gitlab.com/corectrl/corectrl"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://gitlab.com/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/botan:2
	dev-libs/glib:2
	dev-libs/quazip
	dev-qt/qtcharts:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sys-auth/polkit
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

CONFIG_CHECK="~CONNECTOR ~NETLINK_DIAG"

src_configure() {
	local mycmakeargs=(
		-DWITH_PCI_IDS_PATH=/usr/share/misc/pci.ids
	)
	ecm_src_configure
}
 
