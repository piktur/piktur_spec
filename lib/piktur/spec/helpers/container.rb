# frozen_string_literal: true

require 'dry/container'
require 'dry/container/stub'

module Piktur::Spec::Helpers

  module Container

    module_function

    # @param [Module] namespace
    # @return [Object] the container instance
    def containerize(namespace, stub: true)
      namespace.singleton_class.send(:attr_accessor, :container) unless
        namespace.singleton_class.respond_to?(:container)

      namespace.container = Dry::Container.new.tap { |obj| obj.enable_stubs! if stub }
    end

  end

end

RSpec.shared_examples 'a container' do |container|
  describe '.container' do
    subject { container }

    it { should respond_to(:[]) }

    it { should respond_to(:register) }

    it { should respond_to(:resolve) }

    it { should respond_to(:namespace) }

    it { should be_a(::Dry::Container::Mixin) }
  end
end

RSpec.shared_context 'stub container' do |namespace|
  before(:context) do
    ::Test.safe_const_reset(:Container, ::Class.new { include ::Dry::Container::Mixin })
    ::Test.safe_const_reset(:ContainerInstance, ::Test::Container.new.enable_stubs!)
    containerize(namespace, stub: true)
  end

  before do
    # allow(namespace).to receive(:container).and_return(::Test::ContainerInstance)
  end
end

RSpec.configure do |config|
  config.include Piktur::Spec::Helpers::Container
end
