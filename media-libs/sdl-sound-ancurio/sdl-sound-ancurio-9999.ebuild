# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit git-r3 autotools eutils multilib-minimal

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="A library that handles the decoding of sound file formats (Ancurio fork)"
HOMEPAGE="https://github.com/Ancurio/SDL_sound"
EGIT_REPO_URI="https://github.com/Ancurio/SDL_sound"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="flac mikmod modplug mp3 mpeg physfs speex static-libs vorbis"

RDEPEND="
	abi_x86_32? (
		!app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
		!<=app-emulation/emul-linux-x86-sdl-20140406
	)
	media-libs/libsdl2[${MULTILIB_USEDEP}]
	flac? ( >=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}] )
	mikmod? ( >=media-libs/libmikmod-3.2.0[${MULTILIB_USEDEP}] )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1[${MULTILIB_USEDEP}] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
	speex? ( >=media-libs/speex-1.2_rc1-r1[${MULTILIB_USEDEP}] >=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )
	physfs? ( >=dev-games/physfs-2.0.3-r1[${MULTILIB_USEDEP}] )
	mpeg? ( >=media-libs/smpeg-0.4.4-r10[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# S=${WORKDIR}/${MY_P}
# src_prepare() {
# 	epatch "${FILESDIR}"/${P}-{underlinking,automake-1.13}.patch
# 	mv configure.in configure.ac || die
# 	eautoreconf
# }

src_prepare() {
	sed -i -e "s/SDL_sound/SDL_sound_ancurio/" SDL_sound.pc.in
	sed -i -e "s/libSDL_sound/libSDL_sound_ancurio/" Makefile.am
	sed -i -e "s/SDL_sound.pc/SDL_sound_ancurio.pc/" Makefile.am
	sed -i -e "s/SDL_sound.pc/SDL_sound_ancurio.pc/" configure.in
	sed -i -e 's/AM_INIT_AUTOMAKE(SDL_sound, $VERSION)/AM_INIT_AUTOMAKE(SDL_sound_ancurio, $VERSION)/' configure.in
	
	mv SDL_sound.pc.in SDL_sound_ancurio.pc.in
	
	./bootstrap
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-dependency-tracking \
		--enable-midi \
		$(use_enable mpeg smpeg) \
		$(use_enable mp3 mpglib) \
		$(use_enable flac) \
		$(use_enable speex) \
		$(use_enable static-libs static) \
		$(use_enable mikmod) \
		$(use_enable modplug) \
		$(use_enable physfs) \
		$(use_enable vorbis ogg)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc CHANGELOG.txt CREDITS.txt README.txt TODO.txt
	if ! use static-libs ; then
		find "${D}" -type f -name '*.la' -exec rm {} + \
			|| die "la removal failed"
	fi
# 	echo 'prefix=/usr' >> SDL_sound.pc
# 	echo 'exec_prefix=${prefix}' >> SDL_sound.pc
# 	echo 'libdir=${prefix}/lib' >> SDL_sound.pc
# 	echo 'includedir=${prefix}/include' >> SDL_sound.pc
# 	echo 'Name: SDL_sound' >> SDL_sound.pc
# 	echo 'Description: audio decoding library for Simple DirectMedia Layer'>> SDL_sound.pc
# 	echo 'Version: '${PV} >> SDL_sound.pc
# 	echo 'Requires: sdl2 >= 1.2.15' >> SDL_sound.pc
# 	echo 'Libs: -L${libdir} -lSDL_sound'>> SDL_sound.pc
# 	echo 'Cflags: -I${includedir}/SDL2' >> SDL_sound.pc
# 	insinto /usr/lib/pkgconfig
# 	doins SDL_sound.pc
}
