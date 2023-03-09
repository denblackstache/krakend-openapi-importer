# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/file_reader'

describe 'FileReader' do
  let(:file_path) { 'test/fixtures/pet-store.json' }
  let(:subject) { KrakendOpenAPI::FileReader.new(file_path) }

  describe 'having absolute path' do
    it 'reads'
  end

  describe 'having relative path' do
    it 'reads'
  end
end
