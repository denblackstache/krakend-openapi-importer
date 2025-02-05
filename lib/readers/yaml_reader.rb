# frozen_string_literal: true

require 'yaml'
require_relative 'file_reader'

module KrakendOpenAPI
  # Reads YAML files
  class YamlReader
    def initialize(file_path)
      @file_path = file_path
    end

    def read
      YAML.safe_load(KrakendOpenAPI::FileReader.new(@file_path).read)
    end
  end
end
