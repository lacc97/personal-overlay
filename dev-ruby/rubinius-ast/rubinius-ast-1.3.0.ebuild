# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"
RUBY_FAKEGEMS_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="An Abstract Syntax Tree for the Rubinius language platform"
HOMEPAGE="https://rubygems.org/gems/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/rake-10.0"
ruby_add_bdepend ">=dev-ruby/bundler-1.3"
