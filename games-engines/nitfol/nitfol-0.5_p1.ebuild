# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="Z-code interpreter"
HOMEPAGE="http://nitfol.sourceforge.net/"
SRC_URI="https://github.com/lacc97/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-glkterm +glktermw"
REQUIRED_USE="^^ ( glkterm glktermw )"

RDEPEND="
	glkterm? ( dev-games/glkterm )
	glktermw? ( dev-games/glktermw )"
DEPEND="${RDEPEND}"

src_configure() {
	local glkback = ""
	if use glkterm; then
		glkback="glkterm"
    elif use glktermw; then
		glkback="glktermw"
	fi

	local emesonargs=(
		-Dglk_backend="${glkback}"
	)
	
	meson_src_configure
}
