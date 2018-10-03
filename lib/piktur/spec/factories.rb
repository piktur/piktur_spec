# frozen_string_literal: true

module Piktur

  module Spec

    module Factories

      class << self

        # @param [ROM::Container] env
        def call(env)
          return if env.nil?
          ::Piktur.load_initializer('factories')
          load!(env)
        end

        private

          def load!(env)
            return if ::Piktur.env.production?

            rom(env) if defined?(::ROM::Factory)
            factory_bot if defined?(::FactoryBot)

            true
          rescue ::ArgumentError, ::LoadError => err
            ::Piktur.logger.error(err.message)
          end

          def rom(env)
            ::Object.safe_const_reset(
              :Factory,
              ::ROM::Factory.configure { |config| config.rom = env }.struct_namespace(::Object)
            )

            find_paths do |path, railtie|
              path = path.join('rom')

              path.exist? && path.find do |path|
                next if path.directory?
                ::Kernel.load path
              rescue ::ROM::ElementNotFoundError => err
                # @todo Likely due to DB.config reset before constants cleared. In this case
                # the ROM container will not contain the corresponding relation.
                ::Piktur.logger.error(err.message)
              ensure
                next
              end
            end
          end

          def factory_bot
            ::FactoryBot.definition_file_paths.clear

            find_paths do |path|
              ::FactoryBot.definition_file_paths << path.join('factory_bot')
            end

            ::FactoryBot.find_definitions unless ::Piktur.rails?
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
