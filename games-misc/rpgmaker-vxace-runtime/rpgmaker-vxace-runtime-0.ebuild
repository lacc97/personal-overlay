# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Runtime package to run RPG Maker VXAce games"
HOMEPAGE="https://www.rpgmakerweb.com/download/additional/run-time-packages"
SRC_URI="https://cached-downloads.degica.com/degica-downloads/RPGVXAce_RTP.zip -> ${P}.zip"

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

S=${WORKDIR}/RTP100

src_install() {
	mkdir -p ${D}/usr/share/rpgmaker/vxace
	innoextract -d ${D}/usr/share/rpgmaker/vxace Setup.exe || die "Failed to extract RTP"
	mv ${D}/usr/share/rpgmaker/vxace/app ${D}/usr/share/rpgmaker/vxace/rtp || die "Failed to extract RTP"

	echo "#!/bin/bash" >> rpgvxace
	echo "mkxp --rgssVersion=3 --RTP='/usr/share/rpgmaker/vxace/rtp' --winResizable=true --syncToRefreshrate=true --midi.soundFont=/usr/share/sounds/sf2/FluidR3_GM.sf2 --SE.sourceCount=16 \$@" >> rpgvxace
	dobin rpgvxace
}

