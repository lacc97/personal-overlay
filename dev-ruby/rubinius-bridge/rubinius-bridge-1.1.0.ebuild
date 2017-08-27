# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="Classes and methods to run other Rubinius tools under MRI."
HOMEPAGE="https://rubygems.org/gems/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/rake-10.0"
ruby_add_bdepend ">=dev-ruby/bundler-1.3"
ruby_add_rdepend "=dev-ruby/redcard-1.0*"
