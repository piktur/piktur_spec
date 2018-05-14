# frozen_string_literal: true

require 'piktur'

module Piktur

  # @see file:README.markdown
  module Spec

    extend ::ActiveSupport::Autoload

    autoload :Ext
    autoload :Config

    # @return [void]
    def self.define_test_application!
      require_relative File.expand_path('../../config/application.rb', __dir__)
      yield if block_given?
    end

    # Initializes the Rails application defined at config/application.rb
    # @return [void]
    def self.init_test_application!
      require_relative File.expand_path('../../config/environment.rb', __dir__)
      yield if block_given?
    end

    # @example
    #   Piktur::Spec.init_coverage_reporting! do
    #     # define app specific configuration here
    #   end
    # @note In order to accurately assess coverage `SimpleCov.start` **must** be called **before
    #   application loaded**
    # @see https://github.com/colszowka/simplecov/issues/16#issuecomment-113091244 simplecov#16
    def self.init_coverage_reporting!(&block)
      return unless ENV['COVERAGE']
      require 'simplecov'

      # Save results to CI artifacts directory
      # @see https://circleci.com/docs/code-coverage/#adding-and-configuring-a-coverage-library
      if ENV['CIRCLECI'] && ENV['CIRCLE_ARTIFACTS']
        dir = ::File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
        ::SimpleCov.coverage_dir(dir)
      end

      ::SimpleCov.start('rails', &block)
    end

  end

end
