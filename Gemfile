# frozen_string_literal: true

# rubocop:disable Lint/UselessAssignment, Style/ExtraSpacing

gh = 'https://github.com'
bb = 'https://bitbucket.org'

# source 'https://rubygems.org'
source ENV['GEM_SOURCE']

ruby ENV.fetch('RUBY_VERSION').sub('ruby-', '')

gemspec

gem 'piktur',                   git:     "#{bb}/piktur/piktur.git",
                                branch:  'master'
