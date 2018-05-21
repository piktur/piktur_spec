# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('./lib', __dir__)

require_relative './lib/piktur/spec/version.rb'

Gem::Specification.new do |s|
  s.name        = 'piktur_spec'
  s.version     = Piktur::Spec::VERSION
  s.authors     = ['Daniel Small']
  s.email       = ['piktur.io@gmail.com']
  s.homepage    = 'https://bitbucket.org/piktur/piktur_spec'
  s.summary     = 'Piktur a complete Portfolio Management System for Artists'
  # s.source      = 'https://bitbucket.org/piktur/piktur_core'
  s.description = 'Minimal testing environment for Piktur gems'
  s.license = ''
  s.files = Dir[
    '{bin,config,lib}/**/*.rb',
    'Gemfile',
    'Gemfile.common',
    'Gemfile.dummy',
    'piktur_spec.gemspec'
  ]
  s.require_paths = %w(lib)

  # @!group Security
  # @note `dotenv` preferred over `figaro`, for `foreman` compatibility
  s.add_dependency 'dotenv',                            '~> 2.1'
  # @!endgroup

  s.add_dependency 'amoeba',                            '~> 3.1'
  s.add_dependency 'aruba',                             '~> 0.14'
  s.add_dependency 'better_errors',                     '~> 2.1'
  s.add_dependency 'capybara',                          '~> 2.7'
  s.add_dependency 'database_cleaner',                  '~> 1.5'
  s.add_dependency 'factory_bot_rails',                 '~> 4.8'
  s.add_dependency 'faker',                             '~> 1.6'
  s.add_dependency 'jasmine',                           '~> 2.4'
  s.add_dependency 'listen',                            '>= 3.0.5', '< 3.2'
  s.add_dependency 'rspec-rails',                       '~> 3.7'
  s.add_dependency 'shoulda-matchers',                  '~> 3.1'
  s.add_dependency 'simplecov',                         '~> 0.12'
  s.add_dependency 'spring',                            '~> 2.0'
  s.add_dependency 'spring-watcher-listen',             '~> 2.0'

  # s.add_dependency 'byebug',                            '~> 9.0'
  s.add_dependency 'pry',                               '~> 0.10'
  s.add_dependency 'pry-rails',                         '~> 0.3'
  s.add_dependency 'pry-rescue',                        '~> 1.4'
  s.add_dependency 'pry-stack_explorer',                '~> 0.4'

  s.add_dependency 'rubocop',                           '~> 0.50'

  s.add_dependency 'benchmark-ips',                     '~> 2.7'
  s.add_dependency 'ruby-prof',                         '~> 0.1'
end
