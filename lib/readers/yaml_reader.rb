# frozen_string_literal: true

require 'yaml'

module KrakendOpenAPI
  # Reads YAML files
  class YamlReader
    def initialize(file_path)
      @file_path = file_path
    end

    def read
      YAML.safe_load(File.read("#{Dir.pwd}/#{@file_path}"))
    end
  end
end
