# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs xdg git-r3

DESCRIPTION="Manga and book reader written with Qt"
HOMEPAGE="https://github.com/kernel1024/qmanga"

EGIT_REPO_URI="https://github.com/kernel1024/qmanga.git"

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

src_prepare() {
	default

	# Remove INSTALLS for desktop/icons - we install them manually
	sed -i '/^INSTALLS/s/ desktop icons//' qmanga.pro || die
	sed -i '/^desktop\.\|icons\./d' qmanga.pro || die
}

src_configure() {
	local myqmakeargs=(
		"CONFIG+=portage"
	)

	use poppler && myqmakeargs+=( "CONFIG+=use_poppler" "PKGCONFIG+=poppler-cpp poppler" )
	use ocr && myqmakeargs+=( "CONFIG+=use_ocr" "PKGCONFIG+=tesseract lept" )
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
