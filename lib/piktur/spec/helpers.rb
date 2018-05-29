# frozen_string_literal: true

require 'active_support/dependencies/autoload'

module Piktur::Spec::Helpers

  extend ::ActiveSupport::Autoload

  autoload :JSONAPI

  module Features

    begin
      require 'capybara'
      require 'capybara/rspec'
      require 'capybara/rails' if defined?(Rails)
    rescue LoadError => e

    end

  end

  module Factories

    def self.extended(base)
      base.delegate :factory_for, to: :class
    end

    # @return [Symbol]
    def factory_for(klass)
      ::FactoryBot.find_by_class(klass)
    end

  end

end
