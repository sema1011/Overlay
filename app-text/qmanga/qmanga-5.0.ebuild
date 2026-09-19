# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs xdg

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
"
RDEPEND="${DEPEND}
	djvu? ( app-text/djvu )
	epub? ( app-text/ebook-tools )
	ocr? ( >=app-text/tesseract-4.0 >=app-text/leptonica-1.82 )
	poppler? ( app-text/poppler[cxx] )
"
BDEPEND="
	ocr? ( >=app-text/leptonica-1.82 )
	>=dev-qt/qtbase-6.5:6
"

PATCHES=(
	"${FILESDIR}"/${P}-combined.patch
)

src_prepare() {
	default
}

src_configure() {
	local myqmakeargs=(
		"CONFIG+=c++20"
		"CONFIG+=portage"
	)

	use poppler && myqmakeargs+=( "CONFIG+=use_poppler" "PKGCONFIG+=poppler-cpp poppler" )
	use ocr && myqmakeargs+=( "CONFIG+=use_ocr" "PKGCONFIG+=tesseract" "LIBS+=-lleptonica" )
	use djvu && myqmakeargs+=( "CONFIG+=use_djvu" "PKGCONFIG+=ddjvuapi" )
	use epub && myqmakeargs+=( "CONFIG+=use_epub" "LIBS+=-lepub" )

	qmake6 "${myqmakeargs[@]}"
}

src_compile() {
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	# Install desktop file and icons
	insinto /usr/share/applications
	doins qmanga.desktop
	newins img/Alien9.png qmanga.png
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
