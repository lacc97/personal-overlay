# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A multi-platform, free software BitTorrent client that includes an integrated media player"
HOMEPAGE="https://popcorntime.sh/"
SRC_URI="x86? ( https://get.popcorntime.sh/build/Popcorn-Time-${PV}-Linux-32.tar.xz -> ${P}-x86.tar.xz )
	amd64? ( https://get.popcorntime.sh/build/Popcorn-Time-${PV}-Linux-64.tar.xz -> ${P}-amd64.tar.xz )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

RDEPEND="dev-libs/glib:2
	>=dev-libs/nss-3.14.3:=
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/fontconfig:=
	media-libs/freetype:=
	sys-apps/dbus:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXext:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXScrnSaver:=
	x11-libs/libXtst:=
	x11-libs/pango:=
	app-arch/snappy:=
	media-libs/flac:=
	>=media-libs/libwebp-0.4.0:=
	sys-libs/zlib:=[minizip]
	x11-misc/xdg-utils
	virtual/opengl
	virtual/ttf-fonts"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

OPT_DIR_NAME="popcorn-time-bin"

src_unpack() {
	mkdir ${OPT_DIR_NAME}
	cd ${OPT_DIR_NAME}
	unpack ${A}
}

src_install() {
	cd ${WORKDIR}
	
	insinto /opt
	doins -r ${OPT_DIR_NAME}
	
	cd ${OPT_DIR_NAME}
	exeinto /opt/${OPT_DIR_NAME}
	doexe Popcorn-Time
	
	echo -e "#!/bin/bash\n/opt/${OPT_DIR_NAME}/Popcorn-Time" > popcorn-time-bin.sh
	newbin popcorn-time-bin.sh popcorn-time-bin
	
	newicon -s 256 src/app/images/icon.png popcorn-time-bin.png
	
	make_desktop_entry popcorn-time-bin "Popcorn Time" popcorn-time-bin
}
