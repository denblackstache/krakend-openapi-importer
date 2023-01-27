# frozen_string_literal: true

require_relative '../readers/json_reader'
require_relative '../readers/yaml_reader'

module KrakendOpenAPI
  # Reads OpenAPI spec files
  class OA3Reader
    def initialize(path)
      @path = path
    end

    def paths
      read unless @data
      @data['paths']
    end

    private

    def read
      if ['.json'].include?(File.extname(@path))
        @data = JsonReader.new(@path).read
      elsif %w[.yaml .yml].include?(File.extname(@path))
        @data = YamlReader.new(@path).read
      else
        raise StandardError, 'OA3Reader does not support this format'
      end

      self
    end
  end
end
