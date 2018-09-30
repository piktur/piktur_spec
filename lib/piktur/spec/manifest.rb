# frozen_string_literal: true

module Piktur::Spec

  # Use Manifest to document progress and test aspects of the code base
  #
  # @example
  #   # spec/manifest.rb
  #   require 'piktur/spec/manifest'
  #
  #   module Manifest
  #     include Piktur::Spec::Manifest
  #
  #     MODELS = ['a_spec.rb', 'b_spec.rb']
  #     FOCUS  = ['component/a', 'feature/z']
  #   end
  #
  #   Manifest.models # => ['a_spec.rb', 'b_spec.rb']
  #   Manifest.focus(pattern: '**/application_*') # => ['spec/unit/application_model_spec.rb']
  module Manifest

    # @return [String]
    PATTERN  = 'spec/%s{,/*,/**/*}_spec.rb'

    def call(root: ::Dir.pwd, pattern: nil)
      safe_const_get(__callee__.upcase) ||
        ::Dir[format(PATTERN, (pattern || __callee__)), base: root]
    end

    %i(
      api
      assets
      cache
      concepts
      db
      features
      focus
      integration
      loader
      models
      pending
      policies
      security
      support
      system
    ).each { |type| alias_method type, :call }

  end

end
