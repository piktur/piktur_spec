# frozen_string_literal: true

begin
  load Gem.bin_path('piktur', 'env')
rescue Gem::Exception => err
  require 'pry'
  binding.pry
  load File.join(ENV.fetch('PIKTUR_HOME'), 'piktur/bin/env')
end

# require 'bundler/inline'

# gemfile(true) do
#   gh = 'https://github.com'
#   bb = 'https://bitbucket.org'

#   source ENV['GEM_SOURCE']

#   ruby ENV.fetch('RUBY_VERSION').sub('ruby-', '')

#   gem 'piktur_core', git:    "#{bb}/piktur/piktur_core.git",
#                      branch: 'rom'
# end

# require 'piktur_core'

%w(rails active_record/railtie action_controller/railtie).each { |f| require f }

Bundler.require(*Rails.groups)

module Piktur::Spec

  class Application < ::Rails::Application

    secrets.secret_token    = ENV.fetch('SECRET_TOKEN', SecureRandom.hex(64))
    secrets.secret_key_base = ENV.fetch('SECRET_KEY_BASE', SecureRandom.hex(64))

    config.logger = Logger.new($stdout)
    Rails.logger  = config.logger

    config.before_configuration do
      ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'piktur_test')
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    initializer 'piktur.spec.finisher_hook',
                after: :set_clear_dependencies_hook,
                group: :all do
      # Perform final setup after absolute last in `Dummy::Application.initializers_chain`
    end

  end

end
