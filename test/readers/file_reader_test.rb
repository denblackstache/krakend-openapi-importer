# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/file_reader'

describe 'FileReader' do
  let(:file_path) { 'test/fixtures/pet-store.json' }
  let(:subject) { KrakendOpenAPI::FileReader.new(file_path) }

  describe 'having relative path' do
    it 'reads' do
      assert(JSON.parse(subject.read)['info']['title'] == 'Swagger Petstore')
    end
  end

  describe 'having absolute path' do
    let(:file_path) { File.expand_path('test/fixtures/pet-store.json') }

    it 'reads' do
      assert(JSON.parse(subject.read)['info']['title'] == 'Swagger Petstore')
    end
  end
end
