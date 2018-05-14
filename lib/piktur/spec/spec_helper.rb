# frozen_string_literal: true

# Ensure correct environment set
ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'test'

require 'rspec/mocks'
require 'pry'

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

RSpec.configure do |c|
  c.color_mode = :on

  # Override `filter_run_including` when all filtered
  c.run_all_when_everything_filtered = true

  c.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  c.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  c.warnings = false

  # c.example_status_persistence_file_path = "spec/examples.txt"

  c.disable_monkey_patching!

  if c.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    c.default_formatter = 'doc'
  end

  c.profile_examples = 10

  # c.threadsafe = true

  c.order = :defined
  # Kernel.srand c.seed
end

require_relative './helpers.rb'
