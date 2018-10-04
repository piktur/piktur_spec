# frozen_string_literal: true

module Piktur

  module Spec

    module Factories

      class << self

        # @param [ROM::Container] env
        def call(*args)
          return if ::Piktur.env.production?

          ::Piktur.load_initializer('factories')
          load!(*args)
        end

        private

          def load!(*args)
            factory_bot if defined?(::FactoryBot)
            rom_factory(*args) if defined?(::ROM::Factory)

            true
          rescue ::ArgumentError, ::LoadError => err
            ::Piktur.logger.error(err.message)
          end

          def rom_factory(env = ::Piktur::DB.container, load: false)
            return unless env && load

            ::Object.safe_const_reset(
              :Factory,
              ::ROM::Factory.configure { |config| config.rom = env }.struct_namespace(::Object)
            )

            find_rom_factory_paths.each do |path|
              ::Kernel.load(path)
            rescue ::ROM::ElementNotFoundError => err
              # @note Factory registration will fail unless corresponding ROM::Relation defined.
              #   This may occur if DB.config and DB.container reset before full constant reload
              #   DB.container is not able to re-register relations.
              ::Piktur.logger.error(err.message)
            end
          end

          def factory_bot
            find_factory_bot_paths

            # FactoryBot::Railtie loads definitions within after_initialize callbacks
            ::FactoryBot.find_definitions unless ::Piktur.rails?
          end

          def find_rom_factory_paths
            paths = []

            find_paths do |path, railtie|
              (path = path.join('rom')).exist? && path.find do |path|
                next if path.directory?
                paths << path
              end
            end

            paths
          end

          def find_factory_bot_paths
            ::FactoryBot.definition_file_paths.clear

            find_paths do |path|
              ::FactoryBot.definition_file_paths << path.join('factory_bot')
            end
          end

          def find_paths
            ::Piktur.railties.each do |railtie|
              next if railtie.itself?
              yield(railtie.root.join('spec', 'factories'), railtie) if block_given?
            end
          end

      end

    end

  end

end
