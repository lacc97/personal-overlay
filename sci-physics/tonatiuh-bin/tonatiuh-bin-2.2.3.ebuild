# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils flag-o-matic

DESCRIPTION="A Monte Carlo ray tracer for the optical simulation of solar concentrating systems"
HOMEPAGE="https://github.com/iat-cener/tonatiuh"
SRC_URI="
	x86? ( https://github.com/iat-cener/tonatiuh/releases/download/${PV}/Tonatiuh-linux32-${PV}.tar.gz -> ${PN}-x86-${PV}.tar.gz )
	amd64? ( https://github.com/iat-cener/tonatiuh/releases/download/${PV}/Tonatiuh-linux64-${PV}.tar.gz -> ${PN}-amd64-${PV}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-bundled-libs"
RESTRICT="strip"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtscript:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
	media-libs/coin[javascript]
	media-libs/SoQt
	kde-apps/marble"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Tonatiuh-linux"

BUNDLED_LIBS="
	libCoin.so.60
	libQtCore.so.4
	libQtGui.so.4
	libQtOpenGL.so.4
	libQtScript.so.4
	libQtSvg.so.4
	libQtWebKit.so.4
	libQtXml.so.4
	libSoQt.so.20
	libsqlite3.so"

src_prepare() {
	epatch "${FILESDIR}/tonatiuh-bin.patch"
	
	if ! use bundled-libs; then
		cd bin/release
		rm ${BUNDLED_LIBS}
		cd ../../
	fi
	
	mv bin libexec
	mv libexec/release libexec/tonatiuh

	eapply_user
}

src_install() {
	mv Tonatiuh.sh tonatiuh
	dobin tonatiuh
	
	insinto /usr
	doins -r libexec
	
	cd libexec/tonatiuh
	
	exeinto /usr/libexec/tonatiuh
	doexe Tonatiuh
}
