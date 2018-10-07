# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'optparse'

# @example
#   bin/rails spec:isolation -- --pattern=**/application_* --root=$PWD --groups=db,models

module Piktur::Spec
  DEFAULT_MANIFEST_PATH = ::File.expand_path('./spec/manifest.rb', ::Dir.pwd)
  DEFAULT_RSPEC_PATH = ::File.expand_path('./bin/rspec', ::Dir.pwd)
  DEFAULT_RSPEC_OPTIONS = %w(--fail-fast)
  DEFAULT_RSPEC_COMMAND = "#{DEFAULT_RSPEC_PATH} #{DEFAULT_RSPEC_OPTIONS.join(' ')} %s"

  # Spec runner options parser.
  #
  # @note Options must be declared using format `--option=value`
  class Parser

    include ::Singleton

    def self.call(options = EMPTY_OPTS); instance.call(options); end

    def self.file_list; instance.file_list; end

    def self.rspec_opts; instance.rspec_opts; end

    def call(options = EMPTY_OPTS)
      @options = defaults.merge(options)
      parser.parse!(parser.order!(::ARGV), into: @options)
    rescue ::OptionParser::InvalidOption => err
      rspec_opts.concat(err.args) # pass unrecognised args to RSpec::Core::Parser
    ensure
      file_list
    end

    def file_list
      @file_list ||= ::Rake::FileList[groups]
    end

    def rspec_opts
      @rspec_opts ||= DEFAULT_RSPEC_OPTIONS.dup
    end

    private

      def parser
        ::OptionParser.new do |p|
          p.banner = 'Usage: bin/rails spec:default -- [options]'
          p.on('-g', '--groups=[ARRAY]', ::Array, 'Build FileList from prdefined groups or patterns')
        end
      end

      def groups
        ::Kernel.load DEFAULT_MANIFEST_PATH

        @options.delete(:groups).map { |group| ::Manifest.send(group) }
      end

      def defaults
        {
          root: ::Dir.pwd,
          groups: %i(focus)
        }
      end
    end

end

Rake::Task[:spec].clear # Clear default RSpec::Rails tasks

namespace :spec do
  task :prepare do
    ENV['ENV'] = ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'test'

    ARGV.shift
    Piktur::Spec::Parser.call
  rescue ::NoMethodError => err
    puts err.message
  end

  RSpec::Core::RakeTask.new(default: [:prepare]) do |t|
    t.rspec_opts = Piktur::Spec::Parser.rspec_opts
    t.rspec_path = Piktur::Spec::DEFAULT_RSPEC_PATH
    t.pattern = Piktur::Spec::Parser.file_list
  end

  desc 'Run specs in isolation'
  task isolation: [:prepare] do
    Piktur::Spec::Parser.file_list.each do |f|
      sh(format(Piktur::Spec::DEFAULT_RSPEC_COMMAND, f))
    end
  end
end
