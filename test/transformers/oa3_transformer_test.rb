# frozen_string_literal: true

require 'test_helper'
require 'yaml'
require_relative '../../lib/transformers/oa3_transformer'

describe 'OpenAPI 3.0 Transformer' do
  let(:paths) { [] }
  let(:importer_config) { YAML.safe_load('test/fixtures/importer.yaml') }

  it 'transforms OpenAPI paths to KrakenD endpoints' do
    assert(KrakendOpenAPI::OA3ToKrakendTransformer.new(paths, importer_config).transform_paths)
  end
end
