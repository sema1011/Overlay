# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Network status indicator plugin for LXQt panel"
HOMEPAGE="https://github.com/sema1011/plugin-netstatus"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sema1011/plugin-netstatus.git"
else
	SRC_URI="https://github.com/sema1011/plugin-netstatus/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""

DEPEND="
	>=dev-qt/qtbase-6.5.0[dbus,widgets]
	>=dev-qt/qttools-6.5.0
	>=lxqt-base/liblxqt-2.0.0
	>=kde-frameworks/networkmanager-qt-6.0.0
"
RDEPEND="${DEPEND}"
