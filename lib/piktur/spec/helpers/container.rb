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

    # @return [Dry::Container] if guard false, the container instance
    # @return [nil] if guard true
    def container(container = __callee__, namespace: ::Piktur, guard: true, stub: false, &block)
      return guard(__callee__, namespace, stub, &block) if guard

      yield(namespace.send(__callee__)) if block_given?
      namespace.send(__callee__)
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

    private def guard(method, namespace, stub = false, &block)
      return unless block_given?

      ivar = "@__#{method}".to_sym
      setter = "#{method}=".to_sym

      # save state
      instance_variable_set(ivar, namespace.send(method))

      yield(
        namespace.send(method)
          .clone(freeze: false)
          .tap { |copy| stub && copy.enable_stubs! }
      )

      # restore previous state
      namespace.send(setter, instance_variable_get(ivar))
      remove_instance_variable(ivar)

      nil
    end

  end

end
