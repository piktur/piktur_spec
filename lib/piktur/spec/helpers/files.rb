# frozen_string_literal: true

module Piktur::Spec::Helpers

  module Files

    COMPONENT_TYPES = %i(
      models
      policies
      repositories
      schemas
      transactions
    )

    def one; Inflector.singularize(type) + '.rb'; end

    def many; Inflector.pluralize(type); end

    def build_service(name, **opts)
      Piktur::Services::Service.new(name, position: 0, **opts)
    end

    def build_file_index(*services)
      Piktur::Services::FileIndex.new(services)
    end

    def build_loader(strategy)
      Piktur::Loader.call(strategy)
    end

    def tempfile(path)
      require 'tempfile'
      ::Tempfile.new(path, binmode: true)
    end

  end

end
