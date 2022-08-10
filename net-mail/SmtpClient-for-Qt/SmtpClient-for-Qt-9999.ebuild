# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake xdg

DESCRIPTION="SMTP Client for Qt"
HOMEPAGE="https://github.com/petrovvlad/SmtpClient-for-Qt"


if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/petrovvlad/SmtpClient-for-Qt.git"
	EGIT_SUBMODULES=('*')
	inherit git-r3
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/petrovvlad/SmtpClient-for-Qt/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/SmtpClient-for-Qt-${PV}"
fi


LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
REQUIRED_USE="
"

RDEPEND="
	>=dev-qt/qtcore-5.15:5
"
DEPEND="${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
"
#BUILD_DIR="${WORKDIR}/${P}/freeLib/build"
#CMAKE_USE_DIR="${WORKDIR}/${P}/"

src_configure() {
	CMAKE_BUILD_TYPE='Release'
	cmake_src_configure
}
