# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib scons-utils toolchain-funcs eutils versionator

SRC_URI="https://github.com/godotengine/godot/archive/${PV}-stable.tar.gz -> godot-${PV}.tar.gz"
DESCRIPTION="A feature-packed, cross-platform game engine to create 2D and 3D games from a unified interface"
HOMEPAGE="https://godotengine.org/"

GODOT_VERSION_SUFFIX="$(get_major_version)"

LICENSE="MIT"
SLOT="${GODOT_VERSION_SUFFIX}"
KEYWORDS="~amd64"
IUSE="-lto +pulseaudio +system-enet +system-freetype +system-libogg +system-libpng +system-libtheora +system-libvorbis +system-libvpx +system-libwebp +system-openssl +system-opusfile +system-zlib +udev" #TODO Add system-squish flag

RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	media-libs/glu
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXinerama
	virtual/opengl
	pulseaudio? ( media-sound/pulseaudio )
	system-openssl? ( dev-libs/openssl )
	system-libogg? ( media-libs/libogg )
	system-libpng? ( media-libs/libpng )
	system-libtheora? ( media-libs/libtheora )
	system-libvorbis? ( media-libs/libvorbis )
	system-libvpx? ( media-libs/libvpx )
	system-libwebp? ( media-libs/libwebp )
	system-opusfile? ( media-libs/opusfile )
	system-enet? ( net-libs/enet )
	system-zlib? ( sys-libs/zlib )
	udev? ( virtual/udev )"

DEPEND="${DEPEND} ${RDEPEND}"

S="${WORKDIR}/godot-${PV}-stable"

GODOT_OPT_DIR="/opt/godot-${GODOT_VERSION_SUFFIX}"
GODOT_TOOLS_BIN="godot-${GODOT_VERSION_SUFFIX}-tools"

# GODOT_TOOLCHAIN_OPTIONS=""
# GODOT_BUILD_OPTIONS=""
# GODOT_BUILTIN_OPTIONS=""
# GODOT_OTHER_OPTIONS=""

src_configure() {
	GODOT_TOOLCHAIN_OPTIONS=(
        CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
    )
	
	GODOT_BUILD_OPTIONS=(
        CFLAGS="${CFLAGS}"
		CCFLAGS="${CXXFLAGS}"
		LINKFLAGS="${LDFLAGS}"
		unix_global_settings_path="${GODOT_OPT_DIR}"
    )
	
	GODOT_BUILTIN_OPTIONS=(
        builtin_enet=$(usex system-enet no yes)
		builtin_freetype=$(usex system-freetype no yes)
		builtin_libogg=$(usex system-libogg no yes)
		builtin_libpng=$(usex system-libpng no yes)
		builtin_libtheora=$(usex system-libtheora no yes)
		builtin_libvorbis=$(usex system-libvorbis no yes)
		builtin_libvpx=$(usex system-libvpx no yes)
		builtin_libwebp=$(usex system-libwebp no yes)
		builtin_openssl=$(usex system-openssl no yes)
        builtin_opusfile=$(usex system-opusfile no yes)
		builtin_zlib=$(usex system-zlib no yes)
    )
	
	GODOT_OTHER_OPTIONS=(
        use_lto=$(usex lto)
		pulseaudio=$(usex pulseaudio)
		udev=$(usex udev)
		platform=x11
    )
}

src_compile() {
	escons "${GODOT_TOOLCHAIN_OPTIONS[@]}" "${GODOT_BUILD_OPTIONS[@]}" "${GODOT_BUILTIN_OPTIONS[@]}" "${GODOT_OTHER_OPTIONS[@]}" "tools=yes" "target=release_debug"
	mv bin/godot.x11.opt.tools.64 "${S}/${GODOT_TOOLS_BIN}" || die
}

src_install() {
	newicon -s scalable icon.svg godot-${GODOT_VERSION_SUFFIX}.svg
	newicon -s 256 icon.png godot-${GODOT_VERSION_SUFFIX}.png

	dobin ${GODOT_TOOLS_BIN}
	make_desktop_entry godot-${GODOT_VERSION_SUFFIX}-tools "Godot ${GODOT_VERSION_SUFFIX} Tools" godot-${GODOT_VERSION_SUFFIX}
}
