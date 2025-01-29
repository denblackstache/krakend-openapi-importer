# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/commands/import'

describe 'Import Command' do
  let(:spec) { 'test/fixtures/pet-store.json' }
  let(:importer_config) { 'test/fixtures/importer.yaml' }
  let(:config) { YAML.safe_load(File.read(importer_config)) }
  let(:subject) { KrakendOpenAPI::ImportCommand.new(spec: spec, config: importer_config) }

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

    content = JSON.parse(File.read(config['output']))

    expected_content = JSON.parse(File.read('test/fixtures/krakend-endpoints-output.json'))
    assert_equal(expected_content, content)
  end

  describe 'having absolute path for spec/config' do
    let(:spec) { File.expand_path('test/fixtures/pet-store.json') }
    let(:importer_config) { File.expand_path('test/fixtures/importer.yaml') }

    it 'imports OpenAPI spec' do
      result = subject.execute
      assert(result.positive?)
      assert(File.exist?(config['output']))

      content = JSON.parse(File.read(config['output']))
      expected_content = JSON.parse(File.read('test/fixtures/krakend-endpoints-output.json'))
      assert_equal(expected_content, content)
    end
  end

  describe 'having missing importer config' do
    let(:importer_config) { nil }
    let(:config) { { 'output' => 'output.json' } }

    it 'imports OpenAPI spec' do
      subject.execute

      content = File.read(config['output'])
      expected_content = File.read('test/fixtures/krakend-endpoints-output-no-config.json')
      assert(content == expected_content)
    end
  end
end
