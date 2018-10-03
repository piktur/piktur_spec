# frozen_string_literal: true

require 'active_support/dependencies/autoload'

module Piktur::Spec

  module Helpers

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

  # Load custom helper file; if it exists, before applying global helpers to the test suite.
  require_relative config.helpers if ::File.exist?(config.helpers)

end
