# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/yaml_reader'

describe 'YamlReader' do
  let(:file_path) { 'test/fixtures/pet-store.yaml' }

  it 'reads yaml' do
    assert(KrakendOpenAPI::YamlReader.new(file_path).read['info']['title'] == 'Swagger Petstore')
  end
end
