# frozen_string_literal: true

require 'json'
require 'yaml'

module KrakendOpenAPI
  # Writes KrakenD configuration to a file
  class KrakendWriter
    def initialize(endpoints, importer_config)
      @endpoints = endpoints
      @importer_config = importer_config
      @output_file_path = @importer_config['output'] || 'output.json'
    end

    def write
      config = {
        '$schema': 'https://www.krakend.io/schema/v2.1/krakend.json',
        version: 3
      }

      config.merge!(
        @importer_config.dig('defaults', 'base') || {}
      )

      config[:endpoints] = @endpoints

      File.write(file_path, format(config))
    end

    def file_path
      pwd = File.expand_path(Dir.pwd)
      if Pathname.new(@output_file_path).absolute?
        @output_file_path
      else
        File.expand_path(@output_file_path, pwd)
      end
    end

    def format(obj)
      format = @importer_config['format']
      pretty_output = !!@importer_config['pretty'] # rubocop:disable Style/DoubleNegation

      if format == 'yaml'
        YAML.dump(stringify(obj))
      elsif pretty_output
        JSON.pretty_generate(obj)
      else
        JSON.dump(obj)
      end
    end

    def stringify(obj)
      if obj.is_a?(Array)
        obj.map { |v| stringify(v) } if obj.is_a?(Array)
      elsif obj.is_a?(Hash)
        obj.to_h { |k, v| [k.to_s, stringify(v)] }
      else
        obj
      end
    end
  end
end
