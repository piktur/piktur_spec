# frozen_string_literal: true

module Piktur

  module Spec

    module Factories

      # @param [ROM::Container] env
      def self.call(env)
        return if env.nil?
        ::Piktur.load_initializer('factories')
        load!(env)
      end

      private_class_method def self.load!(env) # rubocop:disable MethodLength
        return if ::Piktur.env.production?

        ::FactoryBot.definition_file_paths.clear

        ::Piktur.railties.each do |railtie|
          next if railtie.itself?

          path = railtie.root.join('spec', 'factories')
          ::FactoryBot.definition_file_paths << path.join('factory_bot')

          if defined?(::ROM::Factory)
            ::Factory ||= ::ROM::Factory.configure do |config|
              config.rom = env
            end.struct_namespace(::Object)

            path = path.join('rom')
            path.exist? && path.find do |path|
              next if path.directory?
              require_relative path
            end
          end
        end

        ::FactoryBot.find_definitions unless ::Piktur.rails?

        true
      rescue ::ArgumentError, ::LoadError => err
        ::Piktur.logger.error(err.message)
      end

    end

  end

end
