# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils versionator

DESCRIPTION="An implementation of Ruby on the JVM"
HOMEPAGE="http://www.jruby.org/"
SRC_URI="https://github.com/jruby/jruby/archive/${PV}.tar.gz -> ${P}.tar.gz"

JRUBY_VER="$(get_version_component_range 1-2)"
JRUBY_PKG="jruby-${JRUBY_VER}"

LICENSE="EPL-1.0 GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~x86"
SLOT="${JRUBY_VER}"

RDEPEND=">=dev-java/ant-1.8
	dev-java/maven-bin:3.3
	>=virtual/jdk-1.7"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

DOCS="COPYING LICENSE.RUBY README.md"

src_prepare() {
	cp ${FILESDIR}/settings.xml ${S}/
	
	eapply_user
}

src_compile() {
	mvn -s settings.xml || die
}

src_install() {
	dosym /usr/libexec/${JRUBY_PKG}/bin/jruby /usr/bin/${JRUBY_PKG}

	exeinto /usr/libexec/${JRUBY_PKG}/bin
	doexe bin/jgem
	doexe bin/jirb
	doexe bin/jirb_swing
	doexe bin/jruby
	doexe bin/jrubyc
	
	local my_lib_dir=$(usex x86 i386-Linux x86_64-Linux)
	for lib_dir in lib/jni/* ; do
		if [ "${lib_dir}" != "lib/jni/${my_lib_dir}" ] ; then
			rm -r "${lib_dir}"
		fi
	done
	
	insinto /usr/libexec/${JRUBY_PKG}
	doins -r lib
	
	einstalldocs
}
