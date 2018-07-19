# frozen_string_literal: true

require 'securerandom'

require_relative './container.rb'

module Piktur::Spec::Helpers

  module Security

    def reset_configuration!
      ::Piktur::Security::Config.jwt.create_config
    end

    def generate_jwt(opts)
      issuer.call(**opts)
    end

    # @param (see Piktur::UserProxy)
    def Proxy(type, role)
      require 'piktur/security/entity/user_proxy'

      ::Piktur::UserProxy[type, role]
    end

  end

end

require 'piktur/core'
require 'piktur/security'

RSpec.configure do |config|
  config.before(:all) do
    Piktur::Security.install unless
      defined?(Rails) && Rails.application&.initialized?
  end

  config.include Piktur::Spec::Helpers::Security

  let(:issuer) { ::Piktur::Security::JWT::Issuer.new(issuer: 'https://api.piktur.io') }
end
