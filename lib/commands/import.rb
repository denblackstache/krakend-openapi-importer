# frozen_string_literal: true

require 'pathname'
require 'yaml'
require_relative '../readers/oa3_reader'
require_relative '../readers/yaml_reader'
require_relative '../transformers/oa3_transformer'
require_relative '../writers/krakend_writer'

module KrakendOpenAPI
  # Import Command
  class ImportCommand
    def initialize(spec:, config:)
      @spec = spec
      @importer_config = config ? YamlReader.new(config).read : {}
    end

    def execute
      paths = OA3Reader.new(@spec).paths
      endpoints = OA3ToKrakendTransformer.new(paths, @importer_config).transform_paths
      KrakendWriter.new(endpoints, @importer_config).write
    end
  end
end
