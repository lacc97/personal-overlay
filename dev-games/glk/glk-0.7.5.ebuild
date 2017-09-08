# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Glk headers and layers"
HOMEPAGE="https://github.com/lacc97/glk"
SRC_URI="https://github.com/lacc97/glk/archive/v${PV}.tar.gz -> ${P}.tar.gz"
