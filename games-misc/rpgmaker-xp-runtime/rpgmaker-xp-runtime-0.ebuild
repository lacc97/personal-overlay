# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Runtime package to run RPG Maker XP games"
HOMEPAGE="https://www.rpgmakerweb.com/download/additional/run-time-packages"
SRC_URI="https://s3-ap-northeast-1.amazonaws.com/degica-prod.product-files/20/xp_rtp104e.exe -> ${P}.exe"

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

S=${WORKDIR}

src_install() {
	mkdir -p ${D}/usr/share/rpgmaker/xp
	innoextract -d ${D}/usr/share/rpgmaker/xp ${DISTDIR}/${P}.exe || die "Failed to extract RTP"
	rm -r ${D}/usr/share/rpgmaker/xp/sys || die "Failed to extract RTP"
	mv ${D}/usr/share/rpgmaker/xp/app ${D}/usr/share/rpgmaker/xp/rtp || die "Failed to extract RTP"

	echo "#!/bin/bash" >> rpgxp
	echo "mkxp --rgssVersion=1 --RTP='/usr/share/rpgmaker/xp/rtp' --winResizable=true --syncToRefreshrate=true --midi.soundFont=/usr/share/sounds/sf2/FluidR3_GM.sf2 --SE.sourceCount=16 \$@" >> rpgxp
	dobin rpgxp
}

