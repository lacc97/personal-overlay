# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="A container-based approach to boot a full Android system on a regular GNU/Linux system"
HOMEPAGE="https://anbox.io/"
EGIT_REPO_URI="https://github.com/anbox/anbox"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-test"

RDEPEND="app-emulation/lxc
	dev-cpp/dbus-cpp
	dev-cpp/gmock
	dev-cpp/gtest
	dev-cpp/properties-cpp
	dev-libs/boost
	dev-libs/glib:2
	dev-libs/protobuf
	media-libs/libsdl2
	media-libs/mesa[egl,gles2]
	sys-libs/libcap"
DEPEND="${RDEPEND}"

# CMAKE_MAKEFILE_GENERATOR="ninja"

src_prepare() {
	sed -i -e "s_/usr/bin/env python_/usr/bin/env python2_" scripts/gen-emugl-entries.py || die
	
	if use test ; then
		sed -i -e "s/SOURCE_DIR \"\${GMOCK_SOURCE_DIR}\"/SOURCE_DIR \"\${CMAKE_CURRENT_SOURCE_DIR}\"/" cmake/FindGMock.cmake || die
	else
		sed -i -e "/find_package(GMock)/d" CMakeLists.txt || die
		sed -i -e "/add_subdirectory(tests)/d" CMakeLists.txt || die
	fi
	
	cmake-utils_src_prepare
}
