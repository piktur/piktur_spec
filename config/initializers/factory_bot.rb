# frozen_string_literal: true

unless Piktur.env.production?
  require 'faker'
  require 'factory_bot_rails'

  # Find factory by `klass` and return `#name`
  #
  # @param [Class, String] klass
  #
  # @return [Symbol]
  def FactoryBot.find_by_class(klass)
    factories.to_a.find { |factory| factory.send(:class_name) == klass.to_s }&.name
  end
end
