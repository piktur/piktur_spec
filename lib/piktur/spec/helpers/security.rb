# frozen_string_literal: true

require 'securerandom'
require_relative './container.rb'
require 'piktur/security'

module Piktur::Spec::Helpers

  module Security

    def reset_configuration!
      ::Piktur::Security::Config.jwt.create_config
    end

    def Token(opts) # rubocop:disable MethodName
      ::Piktur::Security::JWT::Token.new(**opts)
    end

    def Proxy(name, role)
      require 'piktur/security/entity/user_proxy'
      ::Piktur::UserProxy[name, role]
    end

  end

end

Piktur::Security.install

RSpec.configure do |config|
  config.before(:all) { require 'piktur/security/authorization/roles' }
  config.include Piktur::Spec::Helpers::Security
end
