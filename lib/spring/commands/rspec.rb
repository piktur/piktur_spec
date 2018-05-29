# frozen_string_literal: true

module Spring

  module Commands

    # Implements the RSpec command for Spring
    # @note You must require this file from `./config/spring.rb` to register the command.
    # @see https://github.com/jonleighton/spring-commands-rspec
    class RSpec

      def env(*)
        'test'
      end

      def exec_name
        'rspec'
      end

      def gem_name
        'rspec-core'
      end

      def call
        ::RSpec.configuration.start_time = ::Time.zone.now if
          defined?(::RSpec.configuration.start_time)
        load ::Gem.bin_path(gem_name, exec_name)
      end

    end

  end

  register_command 'rspec', Commands::RSpec.new

end
