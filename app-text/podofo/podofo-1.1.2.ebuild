# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="PoDoFo is a C++ library to work with the PDF file format (slot 1)"
HOMEPAGE="https://github.com/podofo/podofo"
SRC_URI="https://github.com/podofo/podofo/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="1/4"
KEYWORDS="~amd64 ~arm64"
IUSE="+fontconfig +jpeg lcms +png test tiff"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2:=
	dev-libs/openssl:=
	media-libs/freetype:2=
	virtual/zlib:=
	fontconfig? ( media-libs/fontconfig:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	lcms? ( media-libs/lcms:2= )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( fontconfig? ( media-fonts/liberation-fonts ) )
"

src_configure() {
	local mycmakeargs=(
		# private prefix -- slot 1 coexists with slot 0
		-DCMAKE_INSTALL_INCLUDEDIR="include/podofo-1"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)/podofo-1"

		-DPODOFO_BUILD_STATIC=FALSE
		-DPODOFO_BUILD_TEST=$(usex test TRUE FALSE)
		-DPODOFO_BUILD_EXAMPLES=FALSE
		-DPODOFO_BUILD_UNSUPPORTED_TOOLS=FALSE

		-DPODOFO_WITH_FONTMANAGER=$(usex fontconfig ON OFF)
		-DPODOFO_WITH_LCMS2=$(usex lcms ON OFF)
		$(cmake_use_find_package jpeg JPEG)
		$(cmake_use_find_package png PNG)
		$(cmake_use_find_package tiff TIFF)
	)

	cmake_src_configure
}
