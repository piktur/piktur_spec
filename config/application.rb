# frozen_string_literal: true

require_relative './boot.rb'

%w(
  rails
  action_controller/railtie
).each { |f| require f }

Bundler.require(*Rails.groups)

module Piktur

  module Spec

    # Minimal Rails application, used to mount and boot an engine and for testing.
    class Application < ::Rails::Application

      secrets.secret_token = ::ENV.fetch('SECRET_TOKEN') { ::SecureRandom.hex(64) }
      secrets.secret_key_base = ::ENV.fetch('SECRET_KEY_BASE') { ::SecureRandom.hex(64) }
      config.cache_classes = ::Piktur.env.production?
      config.eager_load = ::Piktur.env.production?
      config.logger = ::Piktur.logger
      config.log_level = ::Piktur.env.test? ? :error : :debug

      # @note Ensure actual paths added ie. `Rails::Application#require_environment`
      paths.keys.each do |path|
        relative = ::File.join('spec', 'dummy', path)
        ::Dir[::File.expand_path(relative, ::ENGINE_ROOT) << '{,.rb}'].each do |absolute|
          ::File.exist?(absolute) && paths[path] << absolute[::ENGINE_ROOT.length + 1..-1]
        end
      end

      paths['config/initializers'] << File.expand_path('./initializers', __dir__)

      initializer 'piktur.spec.finisher_hook', after: :finisher_hook, group: :all do
        # Perform final setup after absolute last in `Dummy::Application.initializers_chain`
      end

    end

  end

end
