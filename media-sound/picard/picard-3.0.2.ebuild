# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 xdg

DESCRIPTION="Cross-platform music tagger powered by the MusicBrainz database"
HOMEPAGE="
	https://picard.musicbrainz.org/
	https://github.com/metabrainz/picard
"
SRC_URI="https://github.com/metabrainz/picard/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/picard-release-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="discid fingerprints markdown multimedia nls"

BDEPEND="
	nls? ( dev-qt/qttools:6[linguist] )
"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
		dev-python/fasteners[${PYTHON_USEDEP}]
		>=dev-python/pyjwt-2.0[${PYTHON_USEDEP}]
		dev-python/pyqt6[gui,network,qml,widgets,${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		media-libs/mutagen[${PYTHON_USEDEP}]
		discid? ( dev-python/discid[${PYTHON_USEDEP}] )
		markdown? ( dev-python/markdown[${PYTHON_USEDEP}] )
	')
	fingerprints? ( media-libs/chromaprint[tools] )
"
DEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep 'dev-python/pyqt6[testlib,${PYTHON_USEDEP}]')
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove tests that require git/external access
	rm -rf test/test_git.py || die
	rm -rf test/plugins3/test_cli.py || die
	rm -rf test/plugins3/test_manager.py || die
	rm -rf test/plugins3/test_plugin_source.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	local build_args=(
		--disable-autoupdate
	)
	if ! use nls; then
		build_args+=( --disable-locales )
	fi
	distutils-r1_python_compile "${build_args[@]}"
}

python_install() {
	local install_args=(
		--disable-autoupdate
		--skip-build
	)
	if ! use nls; then
		install_args+=( --disable-locales )
	fi
	distutils-r1_python_install "${install_args[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
