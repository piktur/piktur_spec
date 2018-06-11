# frozen_string_literal: true

require_relative './spec_helper'

require_relative File.join(Object.const_get(:APP_ROOT), 'config/environment.rb')

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Piktur.env.production?

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

RSpec.configure do |c|
  c.fixture_path = "#{::Rails.root}/spec/fixtures"

  c.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  c.filter_rails_from_backtrace!

  c.include Piktur::Spec::Helpers::Features, type: :feature
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
%w(db models factories).each { require_relative "./helpers/#{f}.rb" }
