# frozen_string_literal: true

module Piktur::Spec::Helpers

  # Seeds test database before request suite runs when records for the following do NOT
  # exist:
  #   - {User}
  #   - {Account}
  #   - {Catalogue}
  #   - {Catalogue::Item}
  module DB

    def database_configuration
      begin
        ::Rails.configuration.database_configuration
      rescue StandardError
        {
          adapter:  'postgresql',
          # encoding: 'unicode',
          # pool:     10 ,
          # timeout:  20000 ,
          host:     '127.0.0.1',
          username: 'daniel',
          password: nil,
          database: "piktur_#{ENV['RAILS_ENV']}",
          port:     5432
        }
      end
    end

    ::RSpec.configuration.prepend_before(:suite) {
      # unless ActiveRecord::Base.connection.table_exists?(:test)
      #   ActiveRecord::Base.connection.create_table :test do |t| # force: true
      #     t.jsonb :data
      #   end
      # end

      ::Rails.application.load_seed if defined?(::Rails) && ::Rails.application
    }

  end

end

module Test

  if defined?(::ApplicationRecord)
    const_set(:Record, Class.new(::ApplicationRecord) {
      self.table_name = 'test'
    })
  end

  class Entity < ::ROM::Struct # < ::ApplicationStruct
    ::ApplicationModel[self, :Struct]
    attribute :id, ::Dry::Types['int']
  end

end
