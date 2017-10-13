# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator eutils xdg-utils

DESCRIPTION="Adobe Flash standalone player"
HOMEPAGE="https://www.adobe.com/support/flashplayer/debug_downloads.html"
SRC_URI="https://fpdownload.macromedia.com/pub/flashplayer/updaters/$(get_major_version)/flash_player_sa_linux.x86_64.tar.gz -> ${P}-amd64.tar.gz"

LICENSE="AdobeFlash-11.x"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

RDEPEND="dev-libs/atk
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/fontconfig
	media-libs/freetype
	>=sys-libs/glibc-2.4
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/pango"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	dobin flashplayer
	
	make_desktop_entry flashplayer 'Adobe Flash Player' 'application-x-shockwave-flash' 'AudioVideo;Video;' 'MimeType=application/x-shockwave-flash'
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
