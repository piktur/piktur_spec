# frozen_string_literal: true

require 'dry/container'
require 'dry/container/stub'

module Piktur::Spec::Helpers

  module Container

    module_function

    def reset_container!(container = :container, namespace: ::Piktur, stub: true)
      namespace.send("#{container}=".to_sym, nil)
      namespace.send(container).tap { |obj| stub && obj.enable_stubs! }
    end

  end

end

RSpec.shared_context 'container' do
  include Piktur::Spec::Helpers::Container

  let(:container) { reset_container!(__method__, stub: true) }
  let(:types) { reset_container!(__method__, stub: true) }
  let(:test_container) do
    ::Test.safe_const_set(:Container, ::Class.new {
      include ::Dry::Container::Mixin
      include ::Piktur::Support::Container::Mixin
    })

    ::Test::Container.new.enable_stubs!
  end

  after(:all) { ::Test.safe_remove_const(:Container) }
end

RSpec.shared_examples 'a container' do
  describe '.container' do
    it { should respond_to(:[]) }

    it { should respond_to(:register) }

    it { should respond_to(:resolve) }

    it { should respond_to(:namespace) }

    it { should be_a(::Dry::Container::Mixin) }
  end
end
