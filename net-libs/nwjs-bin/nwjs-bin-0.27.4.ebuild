# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AMD64_NAME="nwjs-v${PV}-linux-x64"
X86_NAME="nwjs-v${PV}-linux-ia32"

DESCRIPTION="NW.js lets you call all Node.js modules directly from DOM and enables a new way of writing applications with all Web technologies"
HOMEPAGE="https://nwjs.io/"
SRC_URI="
	amd64? ( https://dl.nwjs.io/v${PV}/${AMD64_NAME}.tar.gz -> ${P}-amd64.tar.gz )
	x86? ( https://dl.nwjs.io/v${PV}/${X86_NAME}.tar.gz -> ${P}-x86.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RDEPEND="
	app-arch/bzip2:=
	>=net-print/cups-1.3.11:=
	dev-libs/expat:=
	dev-libs/glib:2
	>=dev-libs/libxml2-2.9.4-r3:=[icu]
	dev-libs/libxslt:=
	dev-libs/nspr:=
	>=dev-libs/nss-3.14.3:=
	>=dev-libs/re2-0.2016.05.01:=
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/fontconfig:=
	media-libs/freetype:=
	>=media-libs/harfbuzz-1.5.0:=[icu(-)]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	>=media-libs/openh264-1.6.0:=
	sys-apps/dbus:=
	sys-apps/pciutils:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
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
"
DEPEND="${RDEPEND}"

QA_PREBUILT="
	usr/libexec/nwjs/nw
	usr/libexec/nwjs/lib/libffmpeg.so
	usr/libexec/nwjs/lib/libnode.so
	usr/libexec/nwjs/lib/libnw.so
"

src_unpack() {
	if use x86; then 
		S="${WORKDIR}/${X86_NAME}"
	else
		S="${WORKDIR}/${AMD64_NAME}"
	fi
	
	default
}

src_install() {
	exeinto /usr/libexec/nwjs
	doexe nw
	
	exeinto /usr/libexec/nwjs/lib
	doexe lib/libffmpeg.so lib/libnode.so lib/libnw.so
	
	insinto /usr/share/nwjs
	doins -r locales
	doins credits.html icudtl.dat natives_blob.bin nw_100_percent.pak nw_200_percent.pak resources.pak snapshot_blob.bin
}
