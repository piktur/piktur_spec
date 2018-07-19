# frozen_string_literal: true

require 'fileutils'
require 'database_cleaner'

module Piktur::Spec::Helpers

  # Seeds test database before request suite runs when records for the following do NOT
  # exist:
  #   - {User}
  #   - {Account}
  #   - {Catalogue}
  #   - {Catalogue::Item}
  #
  # ## Database preparation
  #
  # `ActiveRecord::Migration.maintain_test_schema!` drops the database before each run. This is
  # rather inefficient, instead call `Rails.application.load_seed` in before hook when necessary
  # @see Piktur::Spec::Helpers::DB
  #
  # @example Check existence of residual records
  #   ApplicationRecord.descendants.select(&:exists?).sum(&:count)
  # @see http://www.virtuouscode.com/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/ DatabaseCleaner configuration advice}
  #
  # @see rom-sql/spec/shared/database_setup.rb
  module DB

    # Cludge until migrations finalized and split into numbered files
    def self.migrations_modified?
      migrations = ::ROOT.join('db/migrations.rb')
      last_run   = ::SPEC_ROOT.join('.status')
      last_run.exist? || ::FileUtils.touch(::SPEC_ROOT.join('.status'))

      ::File.mtime(migrations) > ::File.mtime(last_run)
    end

    def run_migrations(migrations)
      migrations.each do |migration|
        begin
          migration.apply(gateway.connection, :up)
        rescue StandardError => error
          ::Piktur.debug(binding, true, error: error)
        end
      end
    end

    def reverse_migrations(migrations)
      migrations.reverse.each do |migration|
        begin
          migration.apply(gateway.connection, :down)
        rescue StandardError => error
          ::Piktur.debug(binding, true, error: error)
        end
      end
    end

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

    extend self

  end

end

conn = Piktur::DB.connection
fn = Piktur::Spec::Helpers::DB

RSpec.configure do |config|
  config.prepend_before(:suite) do
    unless Rails.application.initialized?
      Piktur::DB.send(:to_prepare)

      if Piktur::Spec::Helpers::DB.migrations_modified?
        # fn.reset_db!
        fn.run_migrations()
      end

      DatabaseCleaner[:sequel, connection: conn].strategy = :transaction

      Rails.application.load_seed if defined?(::Rails) && ::Rails.application
    end
  end

  # @example Rollback around **each** example; misses transactions triggered within before(:all)
  #
  #   config.around(:each) { |example| DatabaseCleaner.cleaning { example.run } }
  #
  # Rollback around **each** file!
  #
  # Cleanup around **suite**, whilst less taxing MAY lead to conflicts ie. when using static factory
  # data, persistence will fail on uniqueness constraints
  #
  # @example
  #   c.before(:suite) { DatabaseCleaner.start }
  #   c.after(:suite)  { DatabaseCleaner.clean }
  config.before(:all) do
    DatabaseCleaner[:sequel, connection: conn].start
  end

  config.after(:all) do
    DatabaseCleaner[:sequel, connection: conn].clean
  end

  config.after(:suite) do
    # Piktur::DB.reverse_migrations! if migrations_modified?
    FileUtils.touch(SPEC_ROOT.join('.status'))
  end

  # The name of this setting is a bit misleading. What it really means in Rails is "run every test
  # method within a transaction." In the context of rspec-rails, it means "run every example
  # within a transaction."
  #
  # The idea is to start each example with a clean database, create whatever data is necessary for
  # that example, and then remove that data by simply rolling back the transaction at the end of
  # the example.
  #
  # Disable if using `database_cleaner`
  config.use_transactional_fixtures = false
end

module Test

  if defined?(::ApplicationRecord)
    const_set(:Record, ::Class.new(::ApplicationRecord) {
      self.table_name = 'test'
    })
  end

  class Entity < ::ApplicationStruct
    attribute(:id, 'int')
  end

end
