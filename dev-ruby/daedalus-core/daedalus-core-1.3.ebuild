# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="daedalus-core.gemspec"

inherit ruby-fakegem

DESCRIPTION="Build system to build rubinius"
HOMEPAGE="https://rubygems.org/gems/daedalus-core"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/rake-0.9"
ruby_add_bdepend ">=dev-ruby/rspec-2.8"
