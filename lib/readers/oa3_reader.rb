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
      data['paths']
    end

    def security
      data['security']
    end

    def security_schemes
      data.dig('components', 'securitySchemes')
    end

    private

    def data
      @data ||= if ['.json'].include?(File.extname(@path))
                  JsonReader.new(@path).read
                elsif %w[.yaml .yml].include?(File.extname(@path))
                  YamlReader.new(@path).read
                else
                  raise StandardError, 'OA3Reader does not support this format'
                end
    end
  end
end
