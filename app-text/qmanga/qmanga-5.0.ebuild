# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Manga and book reader written with Qt"
HOMEPAGE="https://github.com/kernel1024/qmanga"
SRC_URI="https://github.com/kernel1024/qmanga/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="djvu ocr poppler"

DEPEND="
	>=dev-qt/qtbase-6.5:6[dbus,sql,widgets,xml,network]
	>=dev-libs/libzip-1.0:=
	dev-libs/icu:=
	dev-libs/openssl:=
	dev-cpp/tbb:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}
	djvu? ( app-text/djvu )
	ocr? ( >=app-text/tesseract-4.0:=[leptonica] )
	poppler? ( >=media-gfx/poppler-0.83[cpp] )
"
BDEPEND="${DEPEND}
	>=dev-qt/qtbase-6.5:6
"

src_prepare() {
	default

	# Fix INSTALL_PREFIX to match Portage
	sed -i 's|isEmpty(INSTALL_PREFIX):INSTALL_PREFIX = /usr|INSTALL_PREFIX = /usr|' qmanga.pro || die
}

src_configure() {
	local myqmakeargs=(
		"CONFIG+=optimize_full"
	)

	use poppler && myqmakeargs+=( "CONFIG+=use_poppler" )
	use ocr && myqmakeargs+=( "CONFIG+=use_ocr" )
	use djvu && myqmakeargs+=( "CONFIG+=use_djvu" )
	use epub && myqmakeargs+=( "CONFIG+=use_epub" )

	qmake6 "${myqmakeargs[@]}"
}

src_compile() {
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	# Install desktop file and icons
	domenu qmanga.desktop
	dodir /usr/share/icons/hicolor/48x48/apps
	cp img/Alien9.png "${D}"/usr/share/icons/hicolor/48x48/apps/qmanga.png || die
}
