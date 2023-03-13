# frozen_string_literal: true

module KrakendOpenAPI
  # Reads absolute/relative files
  class FileReader
    def initialize(file_path)
      @file_path = file_path
    end

    def read
      pwd = File.expand_path(Dir.pwd)
      if Pathname.new(@file_path).absolute?
        File.read(@file_path)
      else
        File.read(File.expand_path(@file_path, pwd))
      end
    end
  end
end
