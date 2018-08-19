# frozen_string_literal: true

module Piktur

  module Spec

    # ## Support files
    #
    # Load support and/or shared examples from support directory
    #
    # @example model Asset::Subclass requires shared example
    #   with 'spec defined at spec/models/asset/subclass'
    #     when 'a matching directory structure exists under spec/support'
    #       'RSpec.required_shared_examples('piktur_core', 'concepts/asset')'
    #         should load 'support/models/asset/shared_examples.rb'
    # @example
    #   # Requires support file under support directory corresponding to current spec directory and
    #   # files that contain 'sharp_processor' and 'metadata' within their path.
    #   RSpec.require_support __dir__, 'sharp_processor', 'metadata'
    #
    # @example Define method to extract relative path from spec directory under app path
    #   def self.relative_path_from_spec_dir(path, app: self.app)
    #     Pathname(path).relative_path_from(spec_dirs[app])
    #   end
    #
    #   paths = paths.collect! { |path| relative_path_from_spec_dir(path, app: app) }
    module Ext

      # @param [String] paths relative path of support file(s) to require
      # @param [String] app limit search to the given service or, if nil, the current `app`
      #   directory.
      #
      # @return [Boolean]
      def require_support(*paths, app: nil) # ::Rails.application.railtie_name
        app = Pathname.pwd.basename.to_s if app.nil? || app.index('spec')

        ::Piktur::Spec.config.support[app]
          .select { |f| f.match? ::Regexp.union(paths) }
          .each { |f| require_relative f }
      end
      alias require_shared_examples require_support

      # Set a debugger entry point if actual behaviour is other than expected.
      #
      # @example
      #   describe '#some_method_call' do
      #     it 'should equal one' do
      #       actual   = subject.some_method_call
      #       expected = 1
      #
      #       RSpec.debug(binding, actual != expected) # opens a pry session at this point
      #
      #       expect(actual).to eq(expected)
      #     end
      #   end
      #
      # @param [Object] object The object to debug, typically a `Binding`.
      # @param [Object] diff The condition
      # @param [Hash] options
      #
      # @option [String] options :warning
      # @option [Exception] options :error
      #
      # @see Piktur.debug
      #
      # @return [void]
      def debug(object, diff = true, **options)
        ::Piktur.debug(object, diff, options)
      end

    end

  end

end
