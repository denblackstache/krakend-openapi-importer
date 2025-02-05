# frozen_string_literal: true

require 'json'
require_relative 'file_reader'

module KrakendOpenAPI
  # Reads JSON files
  class JsonReader
    def initialize(file_path)
      @file_path = file_path
    end

    def read
      JSON.parse(KrakendOpenAPI::FileReader.new(@file_path).read)
    end
  end
end
