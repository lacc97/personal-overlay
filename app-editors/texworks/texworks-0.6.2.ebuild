# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Environment for authoring TeX/LaTeX/ConTeXt with focus on usability"
HOMEPAGE="https://www.tug.org/texworks/"
SRC_URI="https://github.com/TeXworks/texworks/archive/release-${PV}.zip -> texworks-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	app-text/poppler[qt5]
	>=app-text/hunspell-1.2.8"
DEPEND="${RDEPEND}
	 app-arch/unzip"
S="${WORKDIR}/${PN}-release-${PV}"
