# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="A meta-gem for the Rubinius components that compile Ruby source code to bytecode"
HOMEPAGE="https://rubygems.org/gems/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "=dev-ruby/rubinius-ast-1*"
ruby_add_rdepend "=dev-ruby/rubinius-compiler-1*"
ruby_add_rdepend "=dev-ruby/rubinius-melbourne-1*"
ruby_add_rdepend "=dev-ruby/rubinius-processor-1*"
ruby_add_rdepend "=dev-ruby/rubinius-toolset-2*"
