# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/writers/krakend_writer'

describe 'Krakend Writer' do
  let(:endpoints) { [] }
  let(:config) { YAML.safe_load(File.read('test/fixtures/importer.yaml')) }
  let(:subject) { KrakendOpenAPI::KrakendWriter.new(endpoints, config) }

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

  it 'writes valid json to the output file' do
    result = subject.write
    assert(result.positive?)
    assert(File.exist?(config['output']))
    content = File.read(config['output'])
    assert_json(content)
    assert_equal(1, content.lines.length)
  end

  it 'writes $schema, version and endpoints' do
    subject.write
    output = JSON.parse(File.read(config['output']))
    assert_equal(3, output['version'])
    assert_equal('https://www.krakend.io/schema/v2.1/krakend.json', output['$schema'])
    assert_empty(output['endpoints'])
  end

  describe 'having missing importer config properties' do
    let(:config) { {} }

    it 'writes' do
      subject.write
      output = JSON.parse(File.read('output.json'))
      assert_equal(3, output['version'])
    end
  end

  describe 'having absolute path' do
    let(:config) { { 'output' => File.expand_path('output-absolute.json') } }

    it 'writes output' do
      subject.write
      output = JSON.parse(File.read('output-absolute.json'))
      assert_equal(3, output['version'])
    end
  end

  describe 'having relative path' do
    let(:config) { { 'output' => './output-relative.json' } }

    it 'writes output' do
      subject.write
      output = JSON.parse(File.read('output-relative.json'))
      assert_equal(3, output['version'])
    end
  end

  describe 'having pretty option enabled' do
    let(:config) { { 'pretty' => true, 'output' => 'output-pretty.json' } }

    it 'makes json pretty' do
      subject.write
      content = File.read(config['output'])
      assert(content.lines.length > 1)
    end
  end
end
