# frozen_string_literal: true

module Piktur::Spec::Helpers

  module Models

    # Generates test for presence and type of each expected attribute.
    # @param [Array] expected Expected attribute name, type and member_type
    # @return [Method]
    # @example
    #   # spec/models/catalogue/item/artwork/traits_spec.rb
    #   # [name, type, member_type]
    #   #
    #   has_attributes?([
    #     [:artforms, Array, Catalogue::Item::Medium],
    #     [:signed, BasicObject] # Boolean || TrueClass || FalseClass
    #   ])
    #
    def has_attributes?(*attrs)
      attrs.each do |(attr, type, member_type)|
        describe "##{attr}" do
          if member_type
            it "should respond to ##{attr} and return a [#{type}<#{member_type}>] or nil" do
              collection = subject.public_send(attr)
              expect(subject).to respond_to(attr)
              expect(collection).to be_a(type).or be(nil)
              expect(collection.sample).to be_a(member_type).or be(nil)
            end
          else
            it "should respond to ##{attr} and return a [#{type}] or nil" do
              value = subject.public_send(attr)
              expect(subject).to respond_to(attr)
              expect(value).to be_a(type).or be(nil)
            end
          end
        end
      end
    end

  end

end
