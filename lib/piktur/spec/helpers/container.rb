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
    def container(
      container = __callee__,
      namespace: ::Piktur,
      guard: true,
      stub: false,
      replace: false,
      &block
    )
      return _replace(__callee__, namespace, stub, &block) if replace
      return _guard(__callee__, namespace, stub, &block) if guard

      yield(namespace.send(__callee__)) if block_given?
      namespace.send(__callee__)
    end

    # @return [String]
    def to_key(input, namespace_separator = '.')
      if input.is_a?(::Array)
        input.map { |e| to_key(e) }.join(namespace_separator)
      else
        ::Piktur::Support::Container::Key.format(input, namespace_separator)
      end
    end

    # Temporarily replace the container returned from `method`
    #
    # @return [void]
    private def _replace(method, namespace, *args)
      _guard(method, namespace, *args) do |container|
        namespace.instance_variable_set("@#{method}".to_sym, container)

        yield(container) if block_given?
      end
    end

    # @yield A temporary copy of the container to the block
    #
    # @return [void]
    private def _guard(method, namespace, stub = false, &block)
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
