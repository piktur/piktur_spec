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
  autoload :Inheritance
  autoload :JSONAPI
  autoload :Loader
  autoload :Models
  autoload :Security

end
