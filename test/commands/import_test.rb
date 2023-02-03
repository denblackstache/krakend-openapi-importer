# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/commands/import'

describe 'Import Command' do
  let(:spec) { 'test/fixtures/pet-store.json' }
  let(:syntax) { 'json' }
  let(:config) { 'test/fixtures/importer.yaml' }

  it 'imports OpenAPI spec'
  # TODO: Add FakeFS assertions https://github.com/fakefs/fakefs
  # assert(KrakendOpenAPI::ImportCommand.new(spec: spec, syntax: syntax, config: config).execute)
end
