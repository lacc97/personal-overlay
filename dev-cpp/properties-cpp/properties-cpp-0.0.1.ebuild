# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PV="${PV}+14.10.20140730"

DESCRIPTION="A very simple convenience library for handling properties and signals in C++11"
HOMEPAGE="https://launchpad.net/properties-cpp"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-doc -test"

RDEPEND="test? ( dev-cpp/gtest )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	if ! use test ; then
		sed -i -e "/add_subdirectory(tests)/d" CMakeLists.txt || die
	fi
	
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPROPERTIES_CPP_ENABLE_DOC_GENERATION=$(usex doc)
	)
	
	cmake-utils_src_configure
}
