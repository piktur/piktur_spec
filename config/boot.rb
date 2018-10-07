# frozen_string_literal: true

load File.expand_path('bin/env', Dir.pwd)

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and run `bundle install`'
end
