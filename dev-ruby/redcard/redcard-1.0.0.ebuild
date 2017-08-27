# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"
# RUBY_FAKEGEM_GEMSPEC="redcard.gemspec"

inherit ruby-fakegem

DESCRIPTION="A way to ensure that the running Ruby implementation matches the desired version."
HOMEPAGE="https://rubygems.org/gems/redcard"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/rake-10"
ruby_add_bdepend ">=dev-ruby/rspec-2.8"
