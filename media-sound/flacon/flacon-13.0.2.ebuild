# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Tests require lots of disk space
CHECKREQS_DISK_BUILD=10G

inherit check-reqs cmake xdg-utils

DESCRIPTION="Extracts audio tracks from an audio CD image to separate tracks"
HOMEPAGE="https://flacon.github.io/"
SRC_URI="https://github.com/flacon/flacon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alac alacenc ape aac +flac +mp3 +ogg opus sox tta +wavpack test"

BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

RDEPEND="
	app-i18n/uchardet
	dev-qt/qtbase:6[gui,network,widgets,concurrent]
	media-libs/taglib:=
	aac? ( media-libs/faac )
	alac? ( media-sound/alac_decoder )
	alacenc? ( media-sound/alacenc )
	ape? ( media-sound/mac )
	flac? ( media-libs/flac )
	mp3? ( media-sound/lame )
	ogg? ( media-sound/vorbis-tools )
	opus? ( media-sound/opus-tools )
	sox? ( media-sound/sox )
	tta? ( media-sound/ttaenc )
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/yaml-cpp
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-13.0.2-no-man-compress.patch
)

RESTRICT="!test? ( test )"

pkg_pretend() {
	use test && check-reqs_pkg_pretend
}

pkg_setup() {
	use test && check-reqs_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	# Tests fail with enabled sandbox (file access)
	local -x SANDBOX_ON=0

	"${BUILD_DIR}"/flacon_test || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
