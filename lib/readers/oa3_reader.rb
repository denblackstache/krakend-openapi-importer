# frozen_string_literal: true

require_relative '../readers/json_reader'
require_relative '../readers/yaml_reader'

module KrakendOpenAPI
  # Reads OpenAPI spec files
  class OA3Reader
    attr_reader :data

    def read(path)
      if ['.json'].include?(File.extname(path))
        @data = JsonReader.new(path).read
      elsif %w[.yaml .yml].include?(File.extname(path))
        @data = YamlReader.new(path).read
      else
        raise StandardError, 'OA3Reader does not support this format'
      end

      self
    end

    def paths
      data['paths']
    end
  end
end
