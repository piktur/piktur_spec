# frozen_string_literal: true

# rubocop:disable Lint/UselessAssignment, Style/ExtraSpacing

gh = 'https://github.com'
bb = 'https://bitbucket.org'

# source 'https://rubygems.org'
source ENV['GEM_SOURCE']

ruby ENV.fetch('RUBY_VERSION').sub('ruby-', '')

# @!group Piktur
# @note Bundler will load all matching `{,*,*/*}.gemspec`. Due to local directory structure
#   `../piktur_admin.gemspec`, `../piktur_store.gemspec` etc. are parsed when running `bundle
#   install` on the local dev machine. You may want to override `glob: '*.gemspec'` to avoid this.
gem 'piktur',                   git:     "#{bb}/piktur/piktur.git",
                                branch:  'master'

gemspec name: 'piktur_spec'

# @note `require: false` defers loading. Require strategically within codebase.

# @note `dotenv` preferred over `figaro`, for `foreman` compatibility
gem 'dotenv'

eval_gemfile('./Gemfile.common')