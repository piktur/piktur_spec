# frozen_string_literal: true

module Piktur::Spec

  # Use Manifest to document progress and test aspects of the code base
  #
  # @example
  #   # spec/manifest.rb
  #   require 'piktur/spec/manifest'
  #
  #   module Run
  #     include Piktur::Spec::Manifest
  #
  #     MODELS = ['a', 'b']
  #     FOCUS  = ['component/a', 'feature/z']
  #   end
  #
  #   Run.models
  #   Run.focus
  #
  #   $ rspec spec/manifest.rb -f progress
  module Manifest

    # if Piktur.services
    #   ::Piktur.services.paths.each do |path|
    #     path = File.join(path, 'spec')
    #     $LOAD_PATH << path if File.exist?(path)
    #   end
    # end

    PATTERN  = 'spec/%s/{*,**/*}_spec.rb'

    # POLICIES = Set.new
    # PENDING  = Set.new
    # FEATURES = Set.new
    # FOCUS    = Set.new

    def call(specs_to_run)
      specs_to_run.each { |path| load(path) if File.exist?(path) }
    end

    def specs_to_run(specs: nil, root: Dir.pwd, glob: PATTERN)
      specs ||= safe_const_get(__callee__.upcase)
      specs ||= ::Dir[format(glob, __callee__), base: root]

      call(specs)
    end

    %i(
      features
      focus
      assets
      controllers
      models
      policies
      routing
    ).each { |type| alias_method type, :specs_to_run }

  end

end
