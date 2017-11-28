# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils xdg-utils

DESCRIPTION="Load Valve Texture Format files in Qt5 applications"
HOMEPAGE="https://github.com/panzi/qvtf"
EGIT_REPO_URI="https://github.com/panzi/qvtf"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/vtflib"
DEPEND="${RDEPEND}
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's/-Werror//' CMakeLists.txt
	
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQT5VTF=Yes
	)
	
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
}
