# frozen_string_literal: true

require_relative './spec_helper'

# Initialize the Rails application
require_relative File.expand_path('./config/environment.rb', APP_ROOT)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
# Add additional requires below this line.

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

RSpec.configure do |c|
  c.fixture_path = "#{::Rails.root}/spec/fixtures"

  c.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  c.filter_rails_from_backtrace!

  c.include Piktur::Spec::Helpers::Features, type: :feature
end

require_relative './helpers.rb'
