# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/json_reader'

describe 'JsonReader' do
  let(:file_path) { 'test/fixtures/pet-store.json' }

  it 'reads json' do
    assert(KrakendOpenAPI::JsonReader.new(file_path).read['info']['title'] == 'Swagger Petstore')
  end
end
