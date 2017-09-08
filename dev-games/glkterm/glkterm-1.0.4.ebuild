# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="ncurses implementation of the Glk API"
HOMEPAGE="https://github.com/erkyrath/glkterm"
SRC_URI="https://github.com/erkyrath/glkterm/archive/${P}.tar.gz"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	>=dev-games/glk-0.7.4"

S="${WORKDIR}/glkterm-${P}"

src_prepare() {
	cp ${FILESDIR}/meson.build ${S}
	
	sed -i -e "s/@@_VERSION_@@/${PV}/" meson.build
	sed -i -e "s/@@_DESCRIPTION_@@/${DESCRIPTION}/" meson.build
	
	eapply_user
}
