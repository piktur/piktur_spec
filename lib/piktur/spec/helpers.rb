# frozen_string_literal: true

require 'active_support/dependencies/autoload'
require 'piktur/constants'

module Piktur::Spec::Helpers

  extend ::ActiveSupport::Autoload

  autoload :Application
  autoload :Container
  autoload :DB
  autoload :Factories
  autoload :Features
  autoload :Files
  autoload :Inheritance
  autoload :JSONAPI
  autoload :Models
  autoload :Security

end

Piktur::Support.install(:object)

Object.include(Piktur::Constants)

Object.safe_const_set :ROOT,      Pathname.pwd
Object.safe_const_set :SPEC_ROOT, ROOT.join('spec')
Object.safe_const_set :LIB,       ROOT.join('lib')
Object.safe_const_set :APP,       ROOT.join('app')

# Assign arbitrary constants and doubles to this constant within your test suite.
Test = Module.new
