# frozen_string_literal: true

require_relative '../lib/importer/version'

RSpec.describe KrakendOpenAPI::Importer do
  it 'has a version number' do
    expect(KrakendOpenAPI::VERSION).not_to be nil
  end
end
