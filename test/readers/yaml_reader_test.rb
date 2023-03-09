# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/yaml_reader'

describe 'YamlReader' do
  let(:file_path) { 'test/fixtures/pet-store.yaml' }
  let(:subject) { KrakendOpenAPI::YamlReader.new(file_path) }

  it 'reads yaml' do
    assert(subject.read['info']['title'] == 'Swagger Petstore')
  end
end
