# frozen_string_literal: true

require 'piktur'

module Piktur

  module Spec

    class Config

      extend ::Dry::Configurable

      # @!method spec_dirs
      #   @return [Hash{Symbol=>Pathname}]
      setting :dirs, {}, { reader: true } do |input|
        {}.tap do |obj|
          input.each do |k, v|
            next unless (railtie = Support::Inflector.constantize(v, ::Piktur))
            obj[k] = railtie.root.join('spec')
          end
        end
      end

      # @!method support
      #   Returns a list of spec support files within given gem directories
      #   @return [Array<String>]
      setting :support, %w(piktur_core), reader: true do |input|
        {}.tap do |obj|
          input.each do |e|
            binding.pry
            next unless (service = ::Piktur.services.fetch(e.to_s)) && service.gemspec
            obj[service.name] = service.gemspec.test_files
              .select { |f| f.match?(/(spec|test)\/support/) }
          end
        end
      end

    end

  end

end