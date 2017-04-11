name 'fancy_execute'
maintainer 'Irving Popovetsky'
maintainer_email 'irving@chef.io'
license 'Apache 2.0'
description 'Overrides the execute resource to force live_streaming of output'
long_description 'Overrides the execute resource to force live_streaming of output'
source_url 'https://github.com/irvingpop/fancy_execute'
issues_url 'https://github.com/irvingpop/fancy_execute/issues'
version '2.0.0'

chef_version '>= 12.4' if respond_to?(:chef_version)
