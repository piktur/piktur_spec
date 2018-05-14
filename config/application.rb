# frozen_string_literal: true

load Gem.bin_path('piktur', 'piktur-env')

unless ENV['BUNDLE_GEMFILE']
  begin
    require 'bundler/inline'
  rescue LoadError => err
    $stderr.puts 'Bundler version 1.10 or later is required. Please update your Bundler'
    raise err
  end

  # @note you can add common dependencies to the existing Gemfile aswell
  # if ENV.key?('BUNDLE_GEMFILE')
  #   eval_gemfile(ENV['BUNDLE_GEMFILE'])
  # else
  #   gemfile(false) do
  #     gem 'dependency'
  #   end
  # end
  gemfile(false) do
    gh = 'https://github.com'
    bb = 'https://bitbucket.org'

    source ENV['GEM_SOURCE']

    ruby ENV.fetch('RUBY_VERSION').sub('ruby-', '')

    core = Gem.loaded_specs['piktur_core']
    require_relative File.join(core.gem_dir, 'lib/piktur/core/version.rb')

    gem 'pg'

    gem 'rails',                    Piktur::Core.rails_version, require: false

    gem 'activemodel',              Piktur::Core.rails_version, require: false
    gem 'activejob',                Piktur::Core.rails_version, require: false
    gem 'activerecord',             Piktur::Core.rails_version, require: false
    gem 'actionmailer',             Piktur::Core.rails_version, require: false
    gem 'actionpack',               Piktur::Core.rails_version, require: false
    gem 'actioncable',              Piktur::Core.rails_version, require: false
    gem 'activesupport',            Piktur::Core.rails_version, require: false
  end
end

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

    routes.draw do
      #  mount Piktur::Engine => '/'
    end

  end

end