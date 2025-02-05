# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/readers/oa3_reader'
require_relative '../../lib/transformers/oa3_transformer'

describe 'OpenAPI 3.0 Transformer' do
  let(:spec) { KrakendOpenAPI::OA3Reader.new('test/fixtures/pet-store.json') }
  let(:importer_config) { YAML.safe_load(File.read('test/fixtures/importer.yaml')) }
  let(:subject) { KrakendOpenAPI::OA3ToKrakendTransformer.new(spec, importer_config) }

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
                                         roles: %w[admin guest],
                                         scopes: %w[write:pets read:pets] }
                   }
                 },
                 result[0])
  end

  describe 'having empty security scopes' do
    it 'is public' do
      result = subject.transform_paths
      scopes = result[1][:extra_config][:'auth/validator'][:scopes]
      assert_nil(scopes)
    end
  end

  describe 'having default security scopes' do
    it 'has the default scopes' do
      result = subject.transform_paths
      scopes = result[2][:extra_config][:'auth/validator'][:scopes]
      assert_equal(['read:pets'], scopes)
    end
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
