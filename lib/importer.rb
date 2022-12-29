# frozen_string_literal: true

require 'thor'
require_relative 'commands/import'

module KrakendOpenAPI
  # Importer CLI
  class Importer < Thor
    desc 'import SPEC', 'Import OpenAPI spec from SPEC file. Writes KrakenD config to output.json'
    method_option :config, aliases: '-c', desc: 'Path to importer.yaml config', required: true
    method_option :syntax, aliases: '-s', default: 'json',
                           desc: 'Specifies input data syntax: json or yaml. Defaults to json'
    def import(spec)
      ImportCommand.new(spec: spec, syntax: options[:syntax], config: options[:config]).execute
    end
  end
end
