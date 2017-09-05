# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/popcorn-official/popcorn-desktop.git"
	inherit git-r3
else
	SRC_URI="https://github.com/popcorn-official/popcorn-desktop/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A multi-platform, free software BitTorrent client that includes an integrated media player"
HOMEPAGE="https://popcorntime.sh/"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/popcorn-official/popcorn-desktop.git"
else
	SRC_URI="https://github.com/popcorn-official/popcorn-desktop/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="strip"

RDEPEND="dev-libs/glib:2
	>=dev-libs/nss-3.14.3:=
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/fontconfig:=
	media-libs/freetype:=
	>=net-libs/nodejs-0.12.0[npm]
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

if [[ ${PV} != 9999 ]]; then
	S="${WORKDIR}/popcorn-desktop-${PV}"
fi

OPT_DIR_NAME="popcorn-time"

NWJS_VER="0.24.3"

src_prepare() {
	sed -i -e "s_\"guppy-pre-commit\": \"^0.3.0\"_\"guppy-pre-commit\": \"^0.4.0\"_" package.json
	sed -i -e "s/const nwVersion = '.*'/const nwVersion = '${NWJS_VER}'/" gulpfile.js
	sed -i -e "s_https://get.popcorntime.sh/repo/nw/_https://dl.nwjs.io/_" gulpfile.js
	
	eapply_user
}

src_configure() {
	npm install bower gulp
	npm install
	npx bower install
}

src_compile() {
	npx gulp build
}

src_install() {
	cd build/Popcorn-Time/
	mv linux* ${OPT_DIR_NAME}
	
	insinto /opt
	doins -r ${OPT_DIR_NAME}
	
	cd ${OPT_DIR_NAME}
	exeinto /opt/${OPT_DIR_NAME}
	doexe Popcorn-Time
	
	echo -e "#!/bin/bash\n/opt/${OPT_DIR_NAME}/Popcorn-Time" > popcorn-time.sh
	newbin popcorn-time.sh popcorn-time
	
	newicon -s 256 src/app/images/icon.png popcorn-time.png
	
	make_desktop_entry popcorn-time "Popcorn Time" popcorn-time
}
