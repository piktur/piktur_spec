# frozen_string_literal: true

module Piktur::Spec

  # Use Manifest to document progress and test aspects of the code base
  #
  # @example
  #   # spec/manifest.rb
  #   require 'piktur/spec/manifest'
  #
  #   module Manifest
  #     MODELS = ['a_spec.rb', 'b_spec.rb']
  #     FOCUS  = ['component/a', 'feature/z']
  #     extend Piktur::Spec::Manifest
  #   end
  #
  #   Manifest.models # => ['a_spec.rb', 'b_spec.rb']
  #   Manifest.focus(pattern: '**/application_*') # => ['spec/unit/application_model_spec.rb']
  #
  module Manifest

    # @return [String]
    PATTERN  = 'spec/%s{,/*,/**/*}_spec.rb'

    def self.extended(base)
      base.constants.each { |group| alias_method group.downcase, :call }
    end

    def call(root: ::Dir.pwd, pattern: nil)
      safe_const_get(__callee__.upcase) ||
        ::Dir[format(PATTERN, (pattern || __callee__)), base: root]
    end

  end

end
