# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PV="${PV}"

DESCRIPTION="A simple convenience library for handling processes in C++11"
HOMEPAGE="https://launchpad.net/process-cpp"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-doc -test"

RDEPEND="test? ( dev-cpp/gtest )
	dev-cpp/properties-cpp
	dev-libs/boost
	dev-libs/libxml2
	sys-apps/dbus"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

src_prepare() {
	if ! use test ; then
		sed -i -e "/add_subdirectory(tests)/d" CMakeLists.txt || die
	fi
	
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPROCESS_CPP_ENABLE_DOC_GENERATION=$(usex doc)
	)
	
	cmake-utils_src_configure
}
