# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'optparse'

# Options must be declared using format `--option=value`
#
# @example
#   bin/rails spec:isolation -- --pattern=**/application_* --root=$PWD --groups=db,models

DEFAULT_MANIFEST_PATH = File.expand_path('./spec/manifest.rb', Dir.pwd)
DEFAULT_RSPEC_PATH = File.expand_path('./bin/rspec', Dir.pwd)
DEFAULT_RSPEC_OPTIONS = %w(--fail-fast)
DEFAULT_RSPEC_COMMAND = "#{DEFAULT_RSPEC_PATH} #{DEFAULT_RSPEC_OPTIONS.join(' ')} %s"

parser = OptionParser.new
parser.banner = 'Usage: bin/rails spec:default -- [options]'
parser.on('-p', '--pattern=[STRING]', String)
parser.on('-d', '--root=[STRING]', String)
parser.on('-g', '--groups=[ARRAY]', Array)

Rake::Task[:spec].clear # Clear default RSpec::Rails tasks

namespace :spec do
  task :prepare do
    ENV['ENV'] = ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'test'
    Kernel.load DEFAULT_MANIFEST_PATH

    ARGV.shift
    parser.parse!(parser.order!(ARGV), into: options = {
      root: Dir.pwd,
      groups: %i(focus)
    })

    FILES = FileList[options.delete(:groups).map { |group| Manifest.send(group, options) }]
  rescue NoMethodError => err
    puts err.message
  end

  RSpec::Core::RakeTask.new(default: [:prepare]) do |t|
    t.rspec_opts = DEFAULT_RSPEC_OPTIONS
    t.rspec_path = DEFAULT_RSPEC_PATH
    t.pattern = FILES
  end

  desc 'Run specs in isolation'
  task isolation: [:prepare] do
    FILES.each { |f| sh(format(DEFAULT_RSPEC_COMMAND, f)) }
  end
end
