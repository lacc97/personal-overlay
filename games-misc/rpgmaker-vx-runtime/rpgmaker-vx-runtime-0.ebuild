# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Runtime package to run RPG Maker VX games"
HOMEPAGE="https://www.rpgmakerweb.com/download/additional/run-time-packages"
SRC_URI="https://s3-ap-northeast-1.amazonaws.com/degica-prod.product-files/19/vx_rtp102e.zip -> ${P}.zip"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	games-engines/mkxp
	media-sound/fluid-soundfont
"
DEPEND="
	app-arch/innoextract
"

S=${WORKDIR}/RPGVX_RTP

src_install() {
	mkdir -p ${D}/usr/share/rpgmaker/vx
	innoextract -d ${D}/usr/share/rpgmaker/vx Setup.exe || die "Failed to extract RTP"
	mv ${D}/usr/share/rpgmaker/vx/app ${D}/usr/share/rpgmaker/vx/rtp || die "Failed to extract RTP"

	echo "#!/bin/bash" >> rpgvx
	echo "mkxp --rgssVersion=2 --RTP='/usr/share/rpgmaker/vx/rtp' --winResizable=true --syncToRefreshrate=true --midi.soundFont=/usr/share/sounds/sf2/FluidR3_GM.sf2 --SE.sourceCount=16 \$@" >> rpgvx
	dobin rpgvx
}

