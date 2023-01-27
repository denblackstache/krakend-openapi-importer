# frozen_string_literal: true

require 'json'

module KrakendOpenAPI
  # Writes KrakenD configuration to a file
  class KrakendWriter
    def initialize(endpoints, importer_config)
      @endpoints = endpoints
      @importer_config = importer_config
      @output = @importer_config['output'] || 'output.json'
      @file_path = "#{Dir.pwd}/#{@output}"
    end

    def write
      pretty_output = !!@importer_config['pretty'] # rubocop:disable Style/DoubleNegation
      json_generate = pretty_output ? ->(obj) { JSON.pretty_generate(obj) } : ->(obj) { JSON.dump(obj) }
      File.write(@file_path, json_generate.call({
                                                  '$schema': 'https://www.krakend.io/schema/v3.json',
                                                  version: 3,
                                                  endpoints: @endpoints
                                                }))
    end
  end
end
