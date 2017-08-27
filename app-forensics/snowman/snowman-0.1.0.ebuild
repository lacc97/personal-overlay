# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = 9999 ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

inherit cmake-utils ${GIT_ECLASS}

DESCRIPTION="Snowman decompiler"
HOMEPAGE="http://derevenets.com/"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/yegord/snowman.git"
else
	SRC_URI="https://github.com/yegord/snowman/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/boost-1.46.0
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5"
DEPEND="${DEPEND} ${RDEPEND}"

S="${WORKDIR}/${P}/src"

src_configure() {
	local mycmakeargs=(
		-DNC_QT5=ON
		-DNC_USE_THREADS=ON
		-DIDA_PLUGIN_ENABLED=OFF
	)
	
	cmake-utils_src_configure
}
