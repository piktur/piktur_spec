# frozen_string_literal: true

require 'active_support/dependencies/autoload'

module Piktur::Spec::Helpers

  extend ::ActiveSupport::Autoload

  autoload :JSONAPI
  autoload :Features
  autoload :DB
  autoload :Models

  module Factories

    def self.extended(base)
      base.delegate :factory_for, to: :class
    end

    # @return [Symbol]
    def factory_for(klass)
      ::FactoryBot.find_by_class(klass)
    end

  end

  def Object.safe_remove_const(constant, namespace = ::Object)
    return if constant.nil?
    namespace.send(:remove_const, constant) if namespace.const_defined?(constant)
  end

  def Object.safe_get_const(constant, namespace = ::Object)
    return if constant.nil?
    namespace.const_get(constant) if namespace.const_defined?(constant)
  end

  def Object.safe_set_const(constant, value, namespace = ::Object)
    return if constant.nil?
    namespace.const_set(constant, value) unless namespace.const_defined?(constant)
  end

  def Object.safe_reset_const(constant, value = nil, namepace = ::Object)
    return if constant.nil?
    ::Object.safe_remove_const(constant, namespace)
    ::Object.safe_set_const(constant, value, namespace)
  end

end

# You may assign arbitrary constants and doubles to this constant within your test suite.
Test = Module.new
