# frozen_string_literal: true

require 'test_helper'
require 'yaml'
require_relative '../../lib/writers/krakend_writer'

describe 'Krakend Writer' do
  let(:endpoints) { [] }
  let(:config) { YAML.safe_load(File.read('test/fixtures/importer.yaml')) }
  let(:subject) { KrakendOpenAPI::KrakendWriter.new(endpoints, config) }

  before do
    FakeFS.activate!
    fixtures = File.expand_path('../../fixtures', __FILE__)
    pwd = File.expand_path('../../..', __FILE__)
    FakeFS::FileSystem.clone(fixtures)
    Dir.chdir(pwd)
  end

  after do
    FakeFS.clear!
    FakeFS.deactivate!
  end

  it 'writes valid json to the output file' do
    result = subject.write
    assert(result.positive?)
    assert(File.exist?(config['output']))
    assert_json(File.read(config['output']))
  end

  it 'writes $schema, version and endpoints' do
    subject.write
    output = JSON.parse(File.read(config['output']))
    assert_equal(3, output['version'])
    assert_equal('https://www.krakend.io/schema/v3.json', output['$schema'])
    assert_empty(output['endpoints'])
  end

  describe 'having missing importer config properties' do
    it 'writes using defaults'
  end

  describe 'having absolute path' do
    it 'writes output'
  end

  describe 'having pretty option enabled' do
    it 'makes json pretty'
  end
end
