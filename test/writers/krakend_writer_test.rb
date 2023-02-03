# frozen_string_literal: true

require 'test_helper'
require 'yaml'
require_relative '../../lib/writers/krakend_writer'

describe 'Krakend Writer' do
  let(:endpoints) { [] }
  let(:importer_config) { YAML.safe_load('test/fixtures/importer.yaml') }

  it 'writes to the output file'
  # TODO: Add FakeFS assertions https://github.com/fakefs/fakefs
  # assert(KrakendOpenAPI::KrakendWriter.new(endpoints, importer_config).write)
end
