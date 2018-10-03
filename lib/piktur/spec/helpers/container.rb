# frozen_string_literal: true

require 'dry/container'
require 'dry/container/stub'
require 'piktur/support/container'

module Piktur::Spec::Helpers

  module Container

    module_function

    def reset_container!(container = :container, namespace: ::Piktur, stub: true)
      namespace.send("#{container}=".to_sym, nil)
      namespace.send(container).tap { |obj| stub && obj.enable_stubs! }
    end

    def container(container = __callee__, namespace: ::Piktur, stub: false, &block)
      ivar = "@__#{__callee__}".to_sym
      setter = "#{__callee__}=".to_sym

      # save state
      instance_variable_set(ivar, namespace.send(__callee__))

      container = namespace.send(__callee__).clone(freeze: false)
      container = container.enable_stubs! if stub

      yield(container) if block_given?

      # restore previous state
      namespace.send(setter, instance_variable_get(ivar))
    end

    # @return [String]
    def to_key(input)
      ::Piktur::Support::Container::Key(
        case input
        when ::Array then input
        when ::Module then ::Inflector.underscore(input.name).split('/')
        when ::String then input.split(/(?:::|\/)/)
        else input
        end
      )
    end

  end

end
