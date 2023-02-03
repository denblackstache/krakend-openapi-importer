# frozen_string_literal: true

require 'test_helper'
require_relative '../lib/importer/version'

describe 'Importer' do
  it 'has a version number' do
    assert(!KrakendOpenAPI::VERSION.nil?)
  end
end
