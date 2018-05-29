# frozen_string_literal: true

require 'piktur'

module Piktur

  # @see file:README.markdown
  module Spec

    extend ::ActiveSupport::Autoload

    autoload :Ext
    autoload :Config
    autoload :Helpers

    # @return [void]
    def self.define_test_application!
      yield if block_given?
      load File.expand_path('../../config/application.rb', __dir__)
    end

    # Initializes the Rails application defined at config/application.rb
    # @return [void]
    def self.init_test_application!
      yield if block_given?
      load File.expand_path('../../config/environment.rb', __dir__)
    end

    # @example
    #   Piktur::Spec.init_coverage_reporting! do
    #     # define app specific configuration here
    #   end
    # @note In order to accurately assess coverage `SimpleCov.start` **must** be called **before
    #   application loaded**
    # @see https://github.com/colszowka/simplecov/issues/16#issuecomment-113091244 simplecov#16
    def self.init_coverage_reporting!(rails: false, &block)
      return unless ENV['COVERAGE']
      require 'simplecov'

      # Save results to CI artifacts directory
      # @see https://circleci.com/docs/code-coverage/#adding-and-configuring-a-coverage-library
      if ENV['CIRCLECI'] && ENV['CIRCLE_ARTIFACTS']
        dir = ::File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
        ::SimpleCov.coverage_dir(dir)
      end

      if rails
        ::SimpleCov.start('rails', &block)
      else
        ::SimpleCov.start(&block)
      end
    end

  end

  # @!method spec
  #   @see Piktur::Spec::Config
  Config.setting :spec, Spec::Config, reader: true

end
