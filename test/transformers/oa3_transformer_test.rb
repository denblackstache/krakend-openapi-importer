# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/oa3_reader'
require_relative '../../lib/transformers/oa3_transformer'

describe 'OpenAPI 3.0 Transformer' do
  let(:paths) { KrakendOpenAPI::OA3Reader.new('test/fixtures/pet-store.json').paths }
  let(:importer_config) { YAML.safe_load(File.read('test/fixtures/importer.yaml')) }
  let(:subject) { KrakendOpenAPI::OA3ToKrakendTransformer.new(paths, importer_config) }

  it 'transforms multiple OpenAPI paths to KrakenD endpoints' do
    result = subject.transform_paths
    assert(result)
    refute_empty(result)
  end

  it 'transforms path' do
    result = subject.transform_paths
    assert_equal({
                   endpoint: '/pet',
                   method: 'POST',
                   output_encoding: 'no-op',
                   input_headers: ['*'],
                   input_query_strings: ['*'],
                   backend: [{ url_pattern: '/pet', encoding: 'no-op' }],
                   extra_config: {
                     'auth/validator': { alg: 'RS256',
                                         jwk_url: 'https://keycloak.dev/auth/realms/dara/protocol/openid-connect/certs',
                                         cache: false,
                                         operation_debug: true,
                                         roles_key_is_nested: true,
                                         roles_key: 'realm_access.roles',
                                         roles: %w[admin guest] }
                   }
                 },
                 result[0])
  end

  describe 'having missing importer config properties' do
    let(:importer_config) { {} }

    it 'transforms' do
      result = subject.transform_paths
      assert_equal({
                     endpoint: '/pet',
                     method: 'POST',
                     backend: [{ url_pattern: '/pet' }]
                   },
                   result[0])
    end
  end
end
