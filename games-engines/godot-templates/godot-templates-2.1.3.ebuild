# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib scons-utils toolchain-funcs eutils versionator

DESCRIPTION="A feature-packed, cross-platform game engine to create 2D and 3D games from a unified interface"
HOMEPAGE="https://godotengine.org/"

GODOT_VERSION_SUFFIX="$(get_major_version)"
	
LICENSE="MIT"
SLOT="${GODOT_VERSION_SUFFIX}"
KEYWORDS="~amd64"
IUSE="-custom-cflags -lto +pulseaudio +build-templates +prebuilt-templates -system-enet -system-freetype -system-libogg -system-libpng -system-libtheora -system-libvorbis -system-libvpx -system-libwebp -system-openssl -system-opusfile -system-zlib +udev" #TODO Add system-squish flag

SRC_URI="prebuilt-templates? ( https://downloads.tuxfamily.org/godotengine/${PV}/Godot_v${PV}-stable_export_templates.tpz -> ${P}.zip )
	build-templates? ( https://github.com/godotengine/godot/archive/${PV}-stable.tar.gz -> godot-${PV}.tar.gz )"

REQUIRED_USE="|| ( build-templates prebuilt-templates )
	!build-templates? ( pulseaudio )
	custom-cflags? ( build-templates )"

RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	media-libs/glu
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXinerama
	virtual/opengl
	build-templates? (
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
		udev? ( virtual/udev ) )
	pulseaudio? ( media-sound/pulseaudio )"

DEPEND="${DEPEND} ${RDEPEND}"

S="${WORKDIR}/godot-${PV}-stable"

GODOT_OPT_DIR="/opt/godot-${GODOT_VERSION_SUFFIX}"

src_configure() {
	GODOT_TOOLCHAIN_OPTIONS=(
        CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
    )
	
	if use custom-cflags ; then
		GODOT_BUILD_OPTIONS=(
			CFLAGS="${CFLAGS}"
			CCFLAGS="${CXXFLAGS}"
			LINKFLAGS="${LDFLAGS}"
			unix_global_settings_path="${GODOT_OPT_DIR}"
		)
	else
		GODOT_BUILD_OPTIONS=(
			unix_global_settings_path="${GODOT_OPT_DIR}"
		)
	fi
	
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
	if ! use prebuilt-templates && use build-templates; then
		mkdir ${WORKDIR}/templates
	fi

	if use build-templates ; then
		escons "${GODOT_TOOLCHAIN_OPTIONS[@]}" "${GODOT_BUILD_OPTIONS[@]}" "${GODOT_BUILTIN_OPTIONS[@]}" "${GODOT_OTHER_OPTIONS[@]}" "target=release" "bits=32" "tools=no"
		mv bin/godot.x11.opt.32 ${WORKDIR}/templates/linux_x11_32_release || die
		
		escons "${GODOT_TOOLCHAIN_OPTIONS[@]}" "${GODOT_BUILD_OPTIONS[@]}" "${GODOT_BUILTIN_OPTIONS[@]}" "${GODOT_OTHER_OPTIONS[@]}" "target=release_debug" "bits=32" "tools=no"
		mv bin/godot.x11.opt.debug.32 ${WORKDIR}/templates/linux_x11_32_debug || die
		
		escons "${GODOT_TOOLCHAIN_OPTIONS[@]}" "${GODOT_BUILD_OPTIONS[@]}" "${GODOT_BUILTIN_OPTIONS[@]}" "${GODOT_OTHER_OPTIONS[@]}" "target=release" "bits=64" "tools=no"
		mv bin/godot.x11.opt.64 ${WORKDIR}/templates/linux_x11_64_release || die
		
		escons "${GODOT_TOOLCHAIN_OPTIONS[@]}" "${GODOT_BUILD_OPTIONS[@]}" "${GODOT_BUILTIN_OPTIONS[@]}" "${GODOT_OTHER_OPTIONS[@]}" "target=release_debug" "bits=64" "tools=no"
		mv bin/godot.x11.opt.debug.64 ${WORKDIR}/templates/linux_x11_64_debug || die
	else
		QA_PREBUILT="${QA_PREBUILT}
			${GODOT_OPT_DIR#/}/templates/linux_x11_32_release
			${GODOT_OPT_DIR#/}/templates/linux_x11_32_debug
			${GODOT_OPT_DIR#/}/templates/linux_x11_64_release
			${GODOT_OPT_DIR#/}/templates/linux_x11_64_debug"
	fi
}

src_install() {
	cd ${WORKDIR}
	insinto ${GODOT_OPT_DIR#/}
	doins -r templates
	cd ${S}
}

pkg_postinst() {
	if use build-templates && ! use custom-cflags ; then
		einfo "The export templates have been compiled with the default"
		einfo "CFLAGS and CXXFlAGS provided by the Godot SCons build system."
		einfo "If you want to build using your provided CFLAGS and CXXFLAGS"
		einfo "enable the custom-cflags use flag."
	fi
}
