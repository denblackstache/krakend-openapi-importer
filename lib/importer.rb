# frozen_string_literal: true

require 'thor'
require_relative 'commands/import'

module KrakendOpenAPI
  # Importer CLI
  class Importer < Thor
    desc 'import SPEC', 'Import OpenAPI spec from SPEC file. Writes KrakenD config to output.json'
    method_option :config, aliases: '-c', desc: 'Path to importer.yaml config'
    def import(spec)
      puts options[:config].class
      ImportCommand.new(spec: spec, config: options[:config]).execute
    end
  end
end
