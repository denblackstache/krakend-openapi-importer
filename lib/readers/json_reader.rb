# frozen_string_literal: true

module KrakendOpenAPI
  # Reads JSON files
  class JsonReader
    def initialize(file_path)
      @file_path = file_path
    end

    def read
      JSON.parse(File.read("#{Dir.pwd}/#{@file_path}"))
    end
  end
end
