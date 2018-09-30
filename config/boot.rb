# frozen_string_literal: true

begin
  load Gem.bin_path('piktur', 'env')
rescue Gem::Exception
  load File.expand_path('piktur/bin/env', ENV.fetch('PIKTUR_HOME'))
end

require 'bundler/setup'
