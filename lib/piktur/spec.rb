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

    # Configure and/or load a subset of application namespaces under test
    #
    # @return [void]
    def self.env(&block)
      ::Piktur.logger.info <<~MSG
        Overload this method with behaviour necessary to setup a test environment without
        initializing the Rails application.

        ```
          # example_spec.rb
          Piktur::Spec.env do
            load(paths: %w(users profiles), index: true)
          end
        ```
      MSG
    end

    # @return [String]
    def self.status
      path = ::File.expand_path('.status', ::SPEC_ROOT)
      ::File.exist?(path) || ::FileUtils.touch(path)
      path
    end

    def self.last_run; ::File.mtime(status); end

    # @return [void]
    def self.configure(&config)
      Config.configure(&config)
    end

    # @return [Dry::Configurable::Class]
    def self.config
      Config.config
    end

    # @return [void]
    def self.define_rails_application!
      yield if block_given?
      require_relative ::File.expand_path('../../config/application.rb', __dir__)
    end

    # Initializes the Rails application defined at config/application.rb
    # @return [void]
    def self.init_rails_application!
      yield if block_given?
      require_relative ::File.expand_path('../../config/environment.rb', __dir__)
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
    def self.init_coverage_reporting!(rails: false, &block)
      return unless ENV['COVERAGE']
      require 'simplecov'

      # Save results to CI artifacts directory
      # @see https://circleci.com/docs/code-coverage/#adding-and-configuring-a-coverage-library
      if ENV['CIRCLECI'] && ENV['CIRCLE_ARTIFACTS']
        dir = ::File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
        ::SimpleCov.coverage_dir(dir)
      end

      ::SimpleCov.start(*(rails ? 'rails' : nil), &block)
    end

  end

end
