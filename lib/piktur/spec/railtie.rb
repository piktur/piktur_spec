# frozen_string_literal: true

require 'rails'

module Piktur

  module Spec

    class Railtie < ::Rails::Railtie

      rake_tasks do
        load File.expand_path('./tasks/spec.rake', __dir__)
      end

    end

  end

end
