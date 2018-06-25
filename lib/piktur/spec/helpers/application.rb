# frozen_string_literal: true

require_relative File.expand_path('../../../../config/application.rb', __dir__)

module Piktur::Spec

  module Helpers::Application

    # @return [Rails::Application]
    def new_app
      ::Piktur::Spec::Application.new
    end

  end

  class << self

    attr_accessor :app

  end

  self.app = Application.new

end
