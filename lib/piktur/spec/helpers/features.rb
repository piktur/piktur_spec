# frozen_string_literal: true

module Piktur::Spec::Helpers

  module Features

    begin
      require 'capybara'
      require 'capybara/rspec'
      require 'capybara/rails' if defined?(::Rails) && ::Rails.application
    rescue ::LoadError => err
      ::Piktur.logger.error(err.message)
    end

  end

end
