# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit git-r3 python-r1

DESCRIPTION="Keyboard Layout Indicator for LXQt panel using StatusNotifierItem"
HOMEPAGE="https://gitflic.ru/project/npo_rbs/lxqt-panel-kb-indicator"
EGIT_REPO_URI="https://gitflic.ru/project/npo_rbs/lxqt-panel-kb-indicator.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	sys-apps/xkb-monitor
	lxqt-base/lxqt-panel
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i 's|/usr/local/bin/xkb-monitor|stdbuf -oL /usr/bin/xkb-monitor|' kb-indicator
	sed -i '/subprocess.Popen/,/bufsize=1/{s|text=True,|text=True, shell=True,|}' kb-indicator
}

src_install() {
	dobin kb-indicator

	# Autostart for all users
	insinto /etc/xdg/autostart
	doins "${FILESDIR}"/kb-indicator.desktop
}
