# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="A Python module to read and work with Portable Executable files"
HOMEPAGE="https://github.com/erocarrera/${PN}"
SRC_URI="https://github.com/erocarrera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="test"

python_test() {
	${EPYTHON} run_tests.py || die
}
