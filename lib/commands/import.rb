# frozen_string_literal: true

require 'yaml'
require_relative '../readers/oa3_reader'
require_relative '../transformers/oa3_transformer'
require_relative '../writers/krakend_writer'

module KrakendOpenAPI
  # Import Command
  class ImportCommand
    def initialize(spec:, syntax:, config:)
      @spec = spec
      @syntax = syntax
      @config = config

      @importer_config = YAML.safe_load(File.read("#{Dir.pwd}/#{@config}"))
    end

    def execute
      paths = OA3Reader.new.read(@spec).paths
      endpoints = OA3ToKrakendTransformer.new(@importer_config).transform_paths(paths)
      KrakendWriter.new.write(endpoints)
    end
  end
end
