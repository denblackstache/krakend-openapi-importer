# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/oa3_reader'

describe 'OpenAPI 3.0 Reader' do
  it 'reads OpenAPI spec in json' do
    assert(KrakendOpenAPI::OA3Reader.new('test/fixtures/pet-store.json')
                                    .paths['/pet']['post']['operationId'] == 'addPet')
  end

  it 'reads OpenAPI spec in yaml' do
    assert(KrakendOpenAPI::OA3Reader.new('test/fixtures/pet-store.yaml')
                                    .paths['/pet']['post']['operationId'] == 'addPet')
  end

  it 'reads OpenAPI spec in yml' do
    assert(KrakendOpenAPI::OA3Reader.new('test/fixtures/pet-store.yml')
                                    .paths['/pet']['post']['operationId'] == 'addPet')
  end

  it 'doesn\'t read spec in other formats' do
    assert_raises(StandardError, 'OA3Reader does not support this format') do
      KrakendOpenAPI::OA3Reader.new('test/fixtures/pet-store.toml').paths
    end
  end
end
