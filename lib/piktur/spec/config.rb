# frozen_string_literal: true

require 'piktur'

module Piktur

  module Spec

    class Config

      extend ::Piktur::Configurable

      # @return [Regexp]
      SUPPORT_MATCHER = /(spec|test)\/support/

      class << self

        # @example
        #   configure { |config| config.dirs = { 'piktur_api' => 'API::Application' } }
        #
        # @return [Hash{String=>Pathname}] A hash of `Pathname`s keyed by the service name.
        def spec_directories
          h = {}
          Services.specs.each { |name, spec| h[name] = Pathname(spec.gem_dir).join('spec') }
          h
        end
        alias dirs spec_directories

        # @param [Array<String>] services
        #
        # @return [Hash{String=>Array<String>}]
        def support_files(services)
          h = {}
          services.each { |service| h[service] = provided_by(service) }
          h
        end

        private

          # @param [String] name
          #
          # @return [Array<String>] A list of files
          def provided_by(name)
            return unless (gemspec = gemspec(name))
            gemspec.test_files
              .select { |f| f.match?(SUPPORT_MATCHER) }
              .map { |f| ::File.expand_path(f, gemspec.gem_dir) }
          end

          def gemspec(name)
            Services.specs[name]
          end

      end

      default = %w(piktur)
      # @!attribute [rw] support
      #   Returns a hash keyed by service name listing support files provided by the service.
      #   @see .support_files
      #   @return [Hash{}]
      setting :support, default, reader: true, &Types.Constructor(Hash, &method(:support_files))
        .default { type[default] }
        .method(:call)

    end

  end

end
