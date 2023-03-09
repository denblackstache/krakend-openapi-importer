# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/oa3_reader'

describe 'OpenAPI 3.0 Reader' do
  let(:subject) { KrakendOpenAPI::OA3Reader.new(path) }

  describe 'having the OpenAPI spec in json' do
    let(:path) { 'test/fixtures/pet-store.json' }

    it 'reads the spec' do
      assert(subject.paths['/pet']['post']['operationId'] == 'addPet')
    end
  end

  describe 'having the OpenAPI spec in yaml' do
    let(:path) { 'test/fixtures/pet-store.yaml' }

    it 'reads the spec' do
      assert(subject.paths['/pet']['post']['operationId'] == 'addPet')
    end
  end

  describe 'having the OpenAPI spec in yml' do
    let(:path) { 'test/fixtures/pet-store.yml' }

    it 'reads the spec' do
      assert(subject.paths['/pet']['post']['operationId'] == 'addPet')
    end
  end

  describe 'having the OpenAPI spec in other formats' do
    let(:path) { 'test/fixtures/pet-store.toml' }

    it 'doesn\'t read the spec' do
      assert_raises(StandardError, 'OA3Reader does not support this format') do
        subject.paths
      end
    end
  end
end
