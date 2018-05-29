# frozen_string_literal: true

module Piktur::Spec::Helpers

  # Seeds test database before request suite runs when records for the following do NOT
  # exist:
  #   - {User}
  #   - {Account}
  #   - {Catalogue}
  #   - {Catalogue::Item}
  module Database

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

    # unless ActiveRecord::Base.connection.table_exists?(:test)
    #   ActiveRecord::Base.connection.create_table :test do |t| # force: true
    #     t.jsonb :data
    #   end
    # end

    # ::Object.const_set(:TestRecord, Class.new(::ApplicationRecord) {
    #   self.table_name = 'test'
    # })

    ::RSpec.configuration.prepend_before(:suite) { ::Rails.application.load_seed }

  end

end
