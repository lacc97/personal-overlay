# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Free Software implementation of the Ruby Game Scripting System (RGSS)"
HOMEPAGE="https://github.com/Ancurio/mkxp"
EGIT_REPO_URI="https://github.com/Ancurio/mkxp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MRI_VERSION=2.4

RDEPEND="
	dev-lang/ruby:${MRI_VERSION}
	>=dev-games/physfs-2.1
	dev-libs/boost
	dev-libs/libsigc++
	media-libs/openal
	media-libs/libsdl2
	media-libs/sdl2-image[jpeg,png]
	media-libs/sdl2-ttf
	media-libs/sdl-sound-ancurio[mp3,vorbis]
	media-libs/libvorbis
	media-sound/fluidsynth
	sys-libs/zlib
	virtual/opengl
	x11-libs/pixman"
DEPEND="${RDEPEND}
	app-editors/vim-core
	virtual/pkgconfig"

src_prepare() {
	sed -i -e "s/REQUIRED SDL_sound/REQUIRED SDL_sound_ancurio/" CMakeLists.txt
	
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSHARED_FLUID=ON
		-DWORKDIR_CURRENT=ON
		-DMRIVERSION=${MRI_VERSION}
	)
	
	cmake-utils_src_configure
}

src_install() {
	cd ${WORKDIR}/${P}_build
	
	mv mkxp.bin.x86_64 mkxp
	dobin mkxp
}

