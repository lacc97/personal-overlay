# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils
DESCRIPTION="Free clone of the touhou games"
HOMEPAGE="https://taisei-project.org/"
SRC_URI="https://github.com/laochailan/taisei/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio -lto"

RDEPEND="dev-libs/libzip
	>=media-libs/libpng-1.5.0
	>=media-libs/libsdl2-2.0.5
	audio? ( media-libs/sdl2-mixer )
	media-libs/sdl2-ttf
	sys-libs/zlib
	virtual/opengl
	virtual/pkgconfig"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DNO_AUDIO=$(usex audio off on)
		-DRELEASE_USE_LTO=$(usex lto)
	)
	
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
