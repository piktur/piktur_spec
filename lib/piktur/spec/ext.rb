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
    #       'RSpec.required_shared_examples('piktur_core', 'models/asset')'
    #         should load 'support/models/asset/shared_examples.rb'
    # @example
    #   # Requires support file under support directory corresponding to current spec directory and
    #   # files that contain 'sharp_processor' and 'metadata' within their path.
    #   RSpec.require_shared_examples __dir__, 'sharp_processor', 'metadata'
    #
    # @example Define method to extract relative path from spec directory under app path
    #   def self.relative_path_from_spec_dir(path, app: self.app)
    #     Pathname(path).relative_path_from(spec_dirs[app])
    #   end
    #
    #   paths = paths.collect! { |path| relative_path_from_spec_dir(path, app: app) }
    module Ext

      # @param [String] paths relative path of support file(s) to require
      # @param [String] app limit search to current `app` directory
      # @return [Boolean]
      def require_support(*paths, app: ::Rails.application.railtie_name)
        regex = ::Regexp.union(paths)
        ::Piktur::Spec::Config.support[app]
          .each { |f| require_relative(f) if f.match?(regex) }
      end
      alias require_shared_examples require_support

    end

  end

end