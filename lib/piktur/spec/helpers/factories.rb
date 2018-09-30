# frozen_string_literal: true

module Piktur::Spec::Helpers

  module Factories

    UNDEFINED_MSG = %{Factory %s undefined}

    def self.extended(base)
      base.delegate :factory_for, to: :class
    end

    # @return [Symbol]
    def factory_for(klass)
      if defined?(::FactoryBot)
        ::FactoryBot.find_by_class(klass)
      elsif defined?(::ROM::Factory)
        (klass.respond_to?(:model_name) && klass.singularize).to_sym ||
          ::Inflector.singularize(klass.to_s).to_sym
      else
        ::Piktur.logger.warn { UNDEFINED_MSG % klass }
      end
    end

  end

end
