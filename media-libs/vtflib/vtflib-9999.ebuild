# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Linux port of Nem's VTFLib"
HOMEPAGE="https://github.com/panzi/VTFLib"
EGIT_REPO_URI="https://github.com/panzi/VTFLib"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+s3tc"

RDEPEND="media-libs/libtxc_dxtn"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e '/install(CODE ${VTFLIB_PC_INSTALL_CODE})/d' CMakeLists.txt
	
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_LIBTXC_DXTN=$(usex s3tc ON OFF)
	)
	
	cmake-utils_src_configure
}

src_install() {
	dosym VTFLib13.pc /usr/lib/pkgconfig/VTFLib.pc
	
	cmake-utils_src_install
}
