# frozen_string_literal: true

%w(
  rails
  active_record/railtie
  action_controller/railtie
).each { |f| require f }

Bundler.require(*Rails.groups)

module Piktur::Spec

  class Application < ::Rails::Application

    secrets.secret_token    = ENV.fetch('SECRET_TOKEN') { SecureRandom.hex(64) }
    secrets.secret_key_base = ENV.fetch('SECRET_KEY_BASE') { SecureRandom.hex(64) }
    config.cache_classes    = Rails.env.production?
    config.eager_load       = Rails.env.production?

    initializer 'piktur.spec.finisher_hook',
                after: :set_clear_dependencies_hook,
                group: :all do
      # Perform final setup after absolute last in `Dummy::Application.initializers_chain`
    end

  end

end