# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Audio File Encoder. Extracts audio tracks from an audio CD image"
HOMEPAGE="https://flacon.github.io/ https://github.com/flacon/flacon"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PN}-v${PV}"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-6.5:6[dbus,network,widgets]
	>=dev-libs/taglib-1.12:=
	app-i18n/uchardet
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

