# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/commands/import'

describe 'Import Command' do
  let(:spec) { 'test/fixtures/pet-store.json' }
  let(:syntax) { 'json' }
  let(:importer_config) { 'test/fixtures/importer.yaml' }
  let(:config) { YAML.safe_load(File.read(importer_config)) }
  let(:subject) { KrakendOpenAPI::ImportCommand.new(spec: spec, syntax: syntax, config: importer_config) }

  before do
    FakeFS.activate!
    fixtures = File.expand_path('../fixtures', __dir__)
    pwd = File.expand_path('../..', __dir__)
    FakeFS::FileSystem.clone(fixtures)
    Dir.chdir(pwd)
  end

  after do
    FakeFS.clear!
    FakeFS.deactivate!
  end

  it 'imports OpenAPI spec' do
    result = subject.execute
    assert(result.positive?)
    assert(File.exist?(config['output']))

    content = File.read(config['output'])
    expected_content = File.read('test/fixtures/krakend-endpoints-output.json')
    assert(content == expected_content)
  end

  describe 'having absolute path for spec/condifg' do
    let(:spec) { File.expand_path('test/fixtures/pet-store.json') }
    let(:importer_config) { File.expand_path('test/fixtures/importer.yaml') }

    it 'imports OpenAPI spec' do
      result = subject.execute
      assert(result.positive?)
      assert(File.exist?(config['output']))

      content = File.read(config['output'])
      expected_content = File.read('test/fixtures/krakend-endpoints-output.json')
      assert(content == expected_content)
    end
  end
end
