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
IUSE="djvu epub ocr poppler"

DEPEND="
	>=dev-qt/qtbase-6.5:6[dbus,sql,widgets,xml,network]
	>=dev-libs/libzip-1.0:=
	dev-libs/icu:=
	dev-libs/openssl:=
	dev-cpp/tbb:=
	sys-libs/zlib:=
	media-libs/leptonica:=
"
RDEPEND="${DEPEND}
	djvu? ( app-text/djvu )
	epub? ( app-text/libgepub )
	ocr? ( >=app-text/tesseract-4.0 )
	poppler? ( app-text/poppler[cxx] )
"
BDEPEND="${DEPEND}
	>=dev-qt/qtbase-6.5:6
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-tbb.patch
	"${FILESDIR}"/${P}-fix-lept.patch
	"${FILESDIR}"/${P}-fix-pixstruct.patch
	"${FILESDIR}"/${P}-fix-zfilecopier.patch
	"${FILESDIR}"/${P}-fix-pdfreader.patch
	"${FILESDIR}"/${P}-fix-tbb-emit.patch
)

src_prepare() {
	default

	# Fix INSTALL_PREFIX to match Portage
	sed -i 's|isEmpty(INSTALL_PREFIX):INSTALL_PREFIX = /usr|INSTALL_PREFIX = /usr|' qmanga.pro || die
}

src_configure() {
	local myqmakeargs=(
		"CONFIG+=optimize_full"
		"CONFIG+=c++20"
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
