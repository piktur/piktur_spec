# frozen_string_literal: true

module Piktur::Spec::Helpers

  module Features

    require 'capybara'
    require 'capybara/rspec'
    require 'capybara/rails'

  end

  module Factories

    def self.extended(base)
      base.delegate :factory_for, to: :class
    end

    # @return [Symbol]
    def factory_for(klass)
      ::FactoryBot.find_by_class(klass)
    end

  end

  # Seeds test database before request suite runs when records for the following do NOT
  # exist:
  #   - {User}
  #   - {Account}
  #   - {Catalogue}
  #   - {Catalogue::Item}
  module Database

    def db_connection
      config = {
        adapter:  'postgresql',
        # encoding: 'unicode',
        # pool:     10 ,
        # timeout:  20000 ,
        host:     '127.0.0.1',
        username: 'daniel',
        password: nil,
        database: 'piktur_test',
        port:     5432
      }

      # ActiveRecord::Base.establish_connection(config)
    end

    ::Object.const_set(:TestRecord, Class.new(ApplicationRecord) {
      self.table_name = 'test'
    })

    ::RSpec.configuration.prepend_before(:suite) { ::Rails.application.load_seed }

  end

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

  # JSONAPI document factory
  module JSONAPI

    ROOT_URL = 'https://piktur.io/api/v1'
    Model    = ::Struct.new(:model_name)
    Instance = Model.new(::Piktur::Models::Name.new('Example'))

    def self.call(errors: nil, **options)
      doc = if errors.is_a?(Array)
              Errors.new(errors: errors, **options)
            elsif errors
              Errors.new(**options)
            else
              Document.new(options)
            end
      doc.deep_stringify_keys! if options[:stringify]
      doc.to_json if options[:json]
      doc.deep_transform_keys! { |k| ::Inflector.camelize(k, false) } if options[:camelize]
      doc
    end

    module InstanceMethods

      def initialize(links: nil, meta: nil, **)
        ::Hash.new.tap do |h|
          self.links = links
          self.meta  = meta
        end
      end

      def links=(input)
        self[:links] = input || { root: ROOT_URL }
      end

      def meta=(input)
        self[:meta] = input || { updated_at: '02-02-2020' }
      end

    end

    class Document < ::Hash

      include InstanceMethods

      def initialize(data: {}, included: nil, jsonapi: nil, links: nil, meta: nil, collection: false)
        ::Hash.new.tap do |h|
          self.data     = collection ? ::Array.new(2) { Resource.new } : Resource.new(data.to_h)
          self.included = included || linked_resources
          self.jsonapi  = jsonapi
          self.links    = links
          self.meta     = meta
        end
      end

      def data=(input)
        self[:data] = input
      end

      def included=(input)
        # self[:data][:relationships].each_value { |resource| Resource.new(**resource) }
        self[:included] = input
      end

      def jsonapi=(input)
        self[:jsonapi] = input || { 'version' => '1.0', 'meta' => {} }
      end

      def links=(input)
        self[:links] = input || %i(first prev next last).zip(pagination).to_h
      end

      def meta=(input)
        self[:meta] = input || { updated_at: '02-02-2020' }
      end

      def type
        self[:data].is_a?(::Array) ? self[:data].first[:type] : self.dig(:data, :type)
      end

      def pagination
        uri = "#{ROOT_URL}/#{type.pluralize}"
        [1,2,4,5].map { |i| "#{uri}?page[count]=#{i}&page[size]=10" }
      end

      private

        def linked_resources
          if self[:data].is_a?(::Array)
            arr = []
            self[:data].each do |resource|
              build_linked_resources(resource, arr)
            end
          else
            build_linked_resources(self[:data])
          end
        end

        def build_linked_resources(resource, arr = [])
          resource[:relationships].each do |_, relationship|
            if relationship.is_a?(::Array)
              relationship.each { |relationship| arr << Resource.new(relationship[:data]) }
            else
              arr << Resource.new(relationship[:data])
            end
          end

          arr
        end

    end

    class ResourceIdentifier < ::Hash

      include InstanceMethods

      def initialize(id: nil, type: nil, links: nil, meta: nil, **options)
        ::Hash.new.tap do |h|
          self.id    = id
          self.type  = type
          self.links = links
          self.meta  = meta
        end
      end

      def id=(input)
        self[:id] = input || ::SecureRandom.uuid
      end

      def type=(input)
        self[:type] = input || Instance.model_name.singular
      end

      def links=(input)
        self[:links] = input || { self: "#{ROOT_URL}/#{self[:type]}/#{self[:id]}" }
      end

    end

    class Resource < ResourceIdentifier

      def initialize(attributes: nil, relationships: nil, **options)
        super(options).tap do |h|
          self.attributes    = attributes
          self.relationships = relationships
        end
      end

      def attributes=(input)
        self[:attributes] = input.presence || { name: ::Faker::Name.name }
      end

      def relationships=(input)
        self[:relationships] = input.presence || { example: Relationship.new }
      end

    end

    class Relationship < ResourceIdentifier

      def initialize(data: nil, **options)
        ::Hash.new.tap do |h|
          self.links = {}
          self.meta  = {}
          self.data  = data
        end
      end

      def data=(input)
        self[:data] = ResourceIdentifier.new(input.to_h)
      end

    end

    class Errors < Document

      def initialize(jsonapi: nil, errors: [], links: nil, meta: nil)
        ::Hash.new.tap do |h|
          self.errors  = ::Array.new(2) { Error.new }
          self.jsonapi = jsonapi
          self.links   = links
          self.meta    = meta
        end
      end

      def links=(input)
        self[:links] = { support: "#{ROOT_URL}/help" }
      end

      def errors=(input)
        self[:errors] = input || ::Array.new(2) { Error.new }
      end

    end

    class Error < ResourceIdentifier

      HTTP_STATUS_CODES = ::Rack::Utils::HTTP_STATUS_CODES.to_a

      def initialize(links: nil, status: nil, code: nil, title: nil, detail: nil, source: nil, **options)
        super(options).tap do |h|
          self.links = links
          self.status = status
          self.code = code
          self.detail = detail
          self.source = source
        end
      end

      def links=(input)
        self[:links] = input || { about: ::String.new(ROOT_URL) << '/help' }
      end

      def status=(input)
        self[:status], self[:title] = input || HTTP_STATUS_CODES.sample
      end

      def code=(input)
        self[:code] = input || 123
      end

      def detail=(input)
        self[:detail] = input || ::Faker::Lorem.sentence
      end

      def source=(input)
        self[:source] = input || { pointer: pointer, parameter: nil }
      end

      def pointer
        ::String.new('/') << ['data', ::Faker::Lorem::words(2)].join('/')
      end

    end

  end

end
