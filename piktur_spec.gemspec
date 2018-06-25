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
  s.description = 'Minimal testing environment for Piktur gems'
  s.license     = ''
  s.files       = Dir[
    '{bin,config,lib}/**/*.rb',
    'Gemfile',
    'Gemfile.common',
    'Gemfile.dummy',
    'piktur_spec.gemspec',
    base: __dir__
  ]
  s.test_files    = Dir['spec/**/*.rb', base: __dir__]
  s.require_paths = %w(lib)
end
