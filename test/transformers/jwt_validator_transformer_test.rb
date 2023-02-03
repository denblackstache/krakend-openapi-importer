# frozen_string_literal: true

require 'test_helper'
require 'yaml'
require_relative '../../lib/transformers/jwt_validator_transformer'

describe 'JWT Validator Transformer' do
  let(:roles) { [] }
  let(:importer_config) { YAML.safe_load('test/fixtures/importer.yaml') }

  it 'transforms' do
    assert(KrakendOpenAPI::JwtValidatorTransformer.new.transform_to_hash(roles: roles, config: importer_config))
  end
end
