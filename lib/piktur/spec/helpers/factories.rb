# frozen_string_literal: true

module Piktur::Spec::Helpers

  module Factories

    require 'rom/factory'

    def self.extended(base)
      base.delegate :factory_for, to: :class
    end

    # @return [Symbol]
    def factory_for(klass)
      if defined?(::FactoryBot)
        ::FactoryBot.find_by_class(klass)
      elsif defined?(::ROM::Factory)
        (klass.respond_to?(:model_name) && klass.singularize).to_sym ||
          Inflector.singularize(klass.to_s).to_sym
      else
        Piktur.logger.warn { UNDEFINED_MSG % klass }
      end
    end

    class << self

      UNDEFINED_MSG = %{Factory %s undefined}

      def call
        config = ::ROM::Factory.configure { |c| c.rom = ::ROM.env }
        ::Object.const_set(:Factory, config.struct_namespace(::Object))
      end

      def load!(lib: :rom)
        fn = -> (path) {
          if path.directory?
            fn[path]
          elsif path.file?
            load_factory path.basename('.rb'), lib: lib
          end
        }

        SPEC_ROOT.join('factories').children(&fn)
      end

      def load_factory(name, lib: :rom)
        require_relative SPEC_ROOT.join("factories/#{lib}/#{Inflector.pluralize(name.to_s)}.rb")
      rescue LoadError => error
        ::Piktur.logger.error(UNDEFINED_MSG % name)
      end

    end

  end

end
