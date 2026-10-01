# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Qt Single Application library - prevents multiple instances"
HOMEPAGE="https://github.com/qtproject/qt-solutions/tree/master/qtsingleapplication"
SRC_URI="https://github.com/qtproject/qt-solutions/archive/777e95ba69952f11eaec0adfb0cb987fabcdecb3.tar.gz -> qtsingleapplication-777e95ba.tar.gz"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/qt-solutions-777e95ba69952f11eaec0adfb0cb987fabcdecb3/qtsingleapplication"

DEPEND="
	>=dev-qt/qtbase-6.2:6=[gui,network,widgets]
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-qt/qttools-6:6
"

src_configure() {
	local myqmakeargs=(
		"CONFIG+=staticlib"
		"CONFIG+=release"
	)

	cd "${S}/buildlib" || die
	qmake6 "${myqmakeargs[@]}"
}

src_compile() {
	emake -C buildlib
}

src_install() {
	dolib.a buildlib/../lib/libQt6Solutions_SingleApplication-head.a || die

	# Install headers
	insinto /usr/include
	doins src/qtsingleapplication.h src/qtsinglecoreapplication.h
	doins src/qtlocalpeer.h src/qtlockedfile.h

	# Install qmake feature file (manually created for Gentoo)
	insinto /usr/lib64/qt6/mkspecs/features
	echo "INCLUDEPATH += /usr/include" > "${D}/usr/lib64/qt6/mkspecs/features/qtsingleapplication.prf"
	echo "LIBS += -lQt6Solutions_SingleApplication-head" >> "${D}/usr/lib64/qt6/mkspecs/features/qtsingleapplication.prf"

	# Install license
	insinto /usr/share/licenses/${P}
	doins "${S}/../LICENSES/BSD-3-Clause.txt"
}
