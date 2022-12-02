# frozen_string_literal: true

require 'json'

module KrakendOpenAPI
  # Writes KrakenD configuration to a file
  class KrakendWriter
    def initialize
      @file_path = "#{Dir.pwd}/output.json"
    end

    def write(endpoints)
      File.write(@file_path, JSON.dump({
                                         '$schema': 'https://www.krakend.io/schema/v3.json',
                                         version: 3,
                                         endpoints: endpoints
                                       }))
    end
  end
end
