# frozen_string_literal: true

require 'dry/container'
require 'dry/container/stub'
require 'piktur/container'

module Piktur::Spec::Helpers

  module Container

    module_function

    # @return [Piktur::Container::Aggregate]
    def __container__
      ::Piktur.__container__
    end

    # @return [void]
    def reset_container!(stub: true)
      ::Piktur::Container.reset! do |aggregate|
        aggregate.each { |container| stub && container.enable_stubs! }
      end
    end

    # @return [Dry::Container] if guard false, the container instance
    # @return [nil] if guard true
    def container(guard: true, stub: false, replace: false, &block)
      return _replace(__callee__, stub, &block) if replace
      return _guard(__callee__, stub, &block) if guard

      yield(__container__) if block_given?

      __container__.__send__(__callee__)
    end

    # Temporarily replace the container returned from `method`
    #
    # @return [void]
    private_class_method def _replace(name, *args)
      _guard(name, *args) do |container|
        __container__.__send__("#{name}=".to_sym, container)

        yield(container) if block_given?
      end
    end

    # @yield A temporary copy of the container to the block
    #
    # @return [void]
    private_class_method def _guard(name, stub = false, &block)
      return unless block_given?

      ivar = "@__#{name}".to_sym

      # save state
      instance_variable_set(ivar, __container__.__send__(name))

      yield(
        __container__.__send__(name)
          .clone(freeze: false)
          .tap { |copy| stub && copy.enable_stubs! }
      )

      # restore previous state
      __container__.__send__("#{name}=".to_sym, instance_variable_get(ivar))
      remove_instance_variable(ivar)

      nil
    end

  end

end
