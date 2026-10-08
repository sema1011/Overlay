# Copyright 2026 Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 xdg

DESCRIPTION="Local MTProto proxy server for partial bypassing of Telegram loading"
HOMEPAGE="https://github.com/Flowseal/tg-ws-proxy"
SRC_URI="https://github.com/Flowseal/tg-ws-proxy/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+tray"

RDEPEND="
	dev-python/pyperclip[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/h2[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	tray? (
		dev-python/customtkinter[${PYTHON_USEDEP}]
		dev-python/darkdetect
		dev-python/pystray[${PYTHON_USEDEP}]
		dev-lang/python:3.14[tk]
		dev-python/pygobject
		dev-python/pycairo
		dev-libs/libayatana-appindicator
	)
"
DEPEND="
	${RDEPEND}
"

RESTRICT="test"

src_prepare() {
	# Remove non-Linux platform scripts
	rm -f windows.py macos.py utils/win32_theme.py
	# Remove force-include for deleted files only
	sed -i '/"windows.py"/d; /"macos.py"/d' pyproject.toml
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	# Install icon.ico for tray app (app looks for it in package root)
	dodir /usr/lib/python3.14/site-packages
	cp "${FILESDIR}"/tg-ws-proxy.ico "${D}"/usr/lib/python3.14/site-packages/icon.ico

	# Remove tray scripts for non-target platforms
	find "${D}"/usr/lib/python-exec -name 'tg-ws-proxy-tray-macos' -delete 2>/dev/null
	find "${D}"/usr/lib/python-exec -name 'tg-ws-proxy-tray-win' -delete 2>/dev/null
	find "${D}"/usr/bin -name 'tg-ws-proxy-tray-macos' -delete 2>/dev/null
	find "${D}"/usr/bin -name 'tg-ws-proxy-tray-win' -delete 2>/dev/null

	# Desktop file and icon for tray
	if use tray; then
		insinto /usr/share/applications
		doins "${FILESDIR}"/tg-ws-proxy-tray-linux.desktop

		# Install icons at all standard hicolor sizes
		for size in 16 22 24 32 48 64 128 256; do
			insinto /usr/share/icons/hicolor/${size}x${size}/apps
			newins "${FILESDIR}"/tg-ws-proxy-${size}.png tg-ws-proxy.png
		done
	fi
}

pkg_postinst() {
	if use tray; then
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use tray; then
		xdg_icon_cache_update
	fi
}
