# frozen_string_literal: true

require 'piktur'

Object.safe_const_set :SPEC_ROOT, File.expand_path('spec', Dir.pwd)

module Piktur

  # @see file:README.markdown
  module Spec

    extend ::ActiveSupport::Autoload

    autoload :Ext
    autoload :Config
    autoload :Helpers
    autoload :Manifest

    # @return [void]
    def self.configure(&config)
      Piktur::Spec::Config.configure(&config)
    end

    # @return [Dry::Configurable::Class]
    def self.config
      Piktur::Spec::Config.config
    end

    # Setup gems
    # @return [void]
    def self.setup!
      return unless ENV['DISABLE_SPRING']
      Bundler.require(:default, :test, :benchmark)
    end

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
    #
    # @note In order to accurately assess coverage `SimpleCov.start` **must** be called **before
    #   application loaded**
    #
    # @see https://github.com/colszowka/simplecov/issues/16#issuecomment-113091244 simplecov#16
    #
    # @param [Proc] block Configure coverage
    # @option options [Boolean] :rails (false) Start in Rails mode
    def self.init_coverage_reporting!(rails: false, &block) # rubocop:disable MethodLength
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
