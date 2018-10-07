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
  #
  module Manifest

    def self.extended(base)
      base.constants.each { |group| alias_method group.downcase, :call }
    end

    def call; safe_const_get(__callee__.upcase); end

  end

end
