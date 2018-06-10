# frozen_string_literal: true

%w(
  rails
  action_controller/railtie
).each { |f| require f }

Bundler.require(*Rails.groups)

module Piktur

  module Spec

    # Minimal Rails application, used to mount and boot an engine and for testing.
    class Application < ::Rails::Application

      secrets.secret_token    = ::ENV.fetch('SECRET_TOKEN') { ::SecureRandom.hex(64) }
      secrets.secret_key_base = ::ENV.fetch('SECRET_KEY_BASE') { ::SecureRandom.hex(64) }
      config.cache_classes    = ::Piktur.env.production?
      config.eager_load       = ::Piktur.env.production?
      config.log_level        = ::Piktur.env.test? ? :error : :debug

      initializer 'piktur.spec.finisher_hook',
                  after: :set_clear_dependencies_hook,
                  group: :all do
        # Perform final setup after absolute last in `Dummy::Application.initializers_chain`
      end

    end

  end

end
