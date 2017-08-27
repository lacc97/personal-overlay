# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic multilib versionator

DESCRIPTION="A re-implementation of the Ruby VM designed for speed"
HOMEPAGE="http://rubini.us"
SRC_URI="https://github.com/rubinius/rubinius/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+llvm"

RDEPEND="
	llvm? ( >=sys-devel/llvm-3.6 )
	dev-libs/openssl:0
	sys-libs/ncurses
	sys-libs/readline:0
	dev-libs/libyaml
	virtual/libffi
	sys-libs/zlib
"
# RDEPEND="
# 	llvm? ( >=sys-devel/llvm-3.6 )
# 	dev-libs/openssl:0
# 	=dev-ruby/redcard-1*
# 	sys-libs/ncurses
# 	sys-libs/readline:0
# 	dev-libs/libyaml
# 	virtual/libffi
# 	sys-libs/zlib
# "


DEPEND="${RDEPEND}
	dev-ruby/bundler
"
# DEPEND="${RDEPEND}
# 	=dev-ruby/rake-12*
# 	=dev-ruby/daedalus-core-0*
# 	=dev-ruby/rubinius-bridge-1.0*
# 	=dev-ruby/rubinius-build_tools-1.0*
# 	dev-ruby/bundler
# "

pkg_setup() {
	unset RUBYOPT
}

src_prepare() {
	# src_test will wait until all processes are reaped, so tune down
	# the long sleep process a bit.
	sed -i -e 's/sleep 1000/sleep 300/' spec/ruby/core/io/popen_spec.rb || die

	# Avoid specs that cannot work in the portage context
	rm -f spec/ruby/core/argf/read_nonblock_spec.rb || die

	# Drop error CFLAGS per Gentoo policy.
	sed -i -e '/Werror/ s:^:#:' rakelib/blueprint.rb || die

	# Use rake-12.0.0
	rm Gemfile.lock Gemfile.installed
	sed -i -e 's/gem "rake", "~> 10.0"/gem "rake", ">= 10.0"/' Gemfile || die

	# Use llvm-4
	sed -i -e 's/if api_version < 300 or api_version > 305/if api_version < 300 or api_version > 405/' configure || die

	# Fetch gems
	epatch "${FILESDIR}/${P}-configure-fetch.patch"

	bundle || die
}

src_configure() {
	conf=""
	if ! use llvm ; then
		conf+="--disable-llvm "
	fi

	#Rubinius uses a non-autoconf ./configure script which balks at econf
	INSTALL="${EPREFIX}/usr/bin/install -c" ./configure \
		--prefix /usr/$(get_libdir)/rubinius \
		--mandir /usr/share/man \
		--cc gcc \
		--cxx g++ \
		--release-build \
		--without-rpath \
		--with-vendor-zlib \
		${conf} \
		|| die "Configure failed"
}

src_compile() {
	RBXOPT="-Xsystem.log=syslog" rake build || die "Compilation failed"
}

src_test() {
	rake spec || die "Tests failed"
	einfo "Waiting for forked processes to die"
}

src_install() {
	# The install phase tries to determine if there are relevant
	addpredict /usr/local/lib64/ruby

	local minor_version=$(get_version_component_range 1-2)
	local librbx="usr/$(get_libdir)/rubinius"

	RBXOPT="-Xsystem.log=syslog" DESTDIR="${D}" rake install || die "Installation failed"

	dosym /${librbx}/bin/rbx /usr/bin/rbx || die "Couldn't make rbx symlink"

	insinto /${librbx}/${minor_version}/site
	doins "${FILESDIR}/auto_gem.rb" || die "Couldn't install rbx auto_gem.rb"
	RBXOPT="-Xsystem.log=syslog" RBX_RUNTIME="${S}/runtime" RBX_LIB="${S}/lib" bin/rbx compile "${D}/${librbx}/${minor_version}/site/auto_gem.rb" || die "Couldn't bytecompile auto_gem.rb"
}
