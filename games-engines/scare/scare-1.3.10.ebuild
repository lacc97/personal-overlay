# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils meson

DESCRIPTION="Adrift 4 interpreter"
HOMEPAGE="https://sites.google.com/site/scarehome/"
SRC_URI="https://sites.google.com/site/scarehome/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+glk -glkterm +glktermw"
REQUIRED_USE="glk? ( ^^ ( glkterm glktermw ) )"

RDEPEND=""
DEPEND="${RDEPEND}
	glkterm? ( dev-games/glkterm )
	glktermw? ( dev-games/glktermw )"

#S=${WORKDIR}/${P}

src_prepare() {
	cp ${FILESDIR}/meson.build meson.build
	
	sed -i -e "s/@@_VERSION_@@/${PV}/" meson.build
	
	echo "option('use_glk', type : 'boolean', value : true)" >> meson_options.txt
	echo "option('glk_backend', type : 'string', value : 'glkterm')" >> meson_options.txt
	
	eapply_user
}

src_configure() {
	local glkback = ""
	if use glkterm; then
		glkback="glkterm"
    elif use glktermw; then
		glkback="glktermw"
	fi

	local emesonargs=(
		-Duse_glk=$(usex glk true false)
		-Dglk_backend="${glkback}"
	)
	
	meson_src_configure
}
