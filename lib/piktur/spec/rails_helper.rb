# frozen_string_literal: true

# Ensure correct environment set
ENV['RAILS_ENV'] = 'test'

require_relative './spec_helper'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if ::Piktur.env.production?

# Add additional global requires below this line.
require 'rspec/rails'

# Don't init coverage from shared helper. Let the requirer decide when to boot coverage
# reporting.
# Piktur::Spec.init_coverage_reporting!

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

# ## Database preparation
#
# `ActiveRecord::Migration.maintain_test_schema!` drops the database before each run. This is
# rather inefficient, instead call `Rails.application.load_seed` in before hook when necessary
# @see Piktur::Spec::Helpers::Database
RSpec.configure do |c|
  c.fixture_path = "#{::Rails.root}/spec/fixtures"

  c.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  c.filter_rails_from_backtrace!

  # The name of this setting is a bit misleading. What it really means in Rails is "run every test
  # method within a transaction." In the context of rspec-rails, it means "run every example
  # within a transaction."
  #
  # The idea is to start each example with a clean database, create whatever data is necessary for
  # that example, and then remove that data by simply rolling back the transaction at the end of
  # the example.
  #
  # Disable if using `database_cleaner`
  c.use_transactional_fixtures = false

  # @example Check existence of residual records
  #   ApplicationRecord.descendants.select(&:exists?).sum(&:count)
  # @see http://www.virtuouscode.com/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/ DatabaseCleaner configuration advice}
  c.before(:suite) do
    require 'database_cleaner'

    DatabaseCleaner.strategy = :transaction
  end

  c.include Piktur::Spec::Helpers::Features, type: :feature

  # Rollback around **each** example; misses transactions triggered within before(:all)
  # c.around(:each) { |example| DatabaseCleaner.cleaning { example.run } }

  # Rollback around **each** file!
  # Cleanup around **suite**, whilst less taxing MAY lead to conflicts ie. when using static factory
  # data, persistence will fail on uniqueness constraints
  # @example
  #   c.before(:suite) { DatabaseCleaner.start }
  #   c.after(:suite)  { DatabaseCleaner.clean }
  c.before(:all) do
    DatabaseCleaner.start

    unless ActiveRecord::Base.connection.table_exists?(:test)
      ActiveRecord::Base.connection.create_table :test do |t| # force: true
        t.jsonb :data
      end
    end
  end

  c.after(:all) do
    DatabaseCleaner.clean
  end
end

require 'shoulda-matchers'

Shoulda::Matchers.configure do |c|
  c.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec

    with.library :rails
  end
end

require_relative './helpers.rb'
