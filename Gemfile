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

group :development do
  gem 'rubocop',                require: false
  gem 'better_errors',          require: false
  gem 'bullet',                 require: false
  gem 'i18n_generators',        require: false
end

group :development, :test do
  gem 'amoeba',                 source: ENV['GEM_SOURCE']
  gem 'awesome_print',          source:  ENV['GEM_SOURCE'],
                                require: false
  gem 'benchmark-ips',          require: false
  # gem 'byebug',                 require: false
  gem 'factory_bot_rails',      require: false
  gem 'faker',                  require: false
  gem 'pry'
  gem 'pry-rails'               require: false
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'ruby-prof',              require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'aruba',                  require: false
  gem 'capybara',               require: false
  gem 'database_cleaner',       require: false
  gem 'jasmine',                require: false
  gem 'rspec-rails'
  gem 'shoulda-matchers',       git:    "#{gh}/thoughtbot/shoulda-matchers.git",
                                branch: 'rails-5'
  gem 'simplecov',              require: false
  gem 'wisper-rspec',           require: false
  gem 'wisper-testing',         require: false
end