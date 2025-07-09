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
                   backend: [{ url_pattern: '/pet', encoding: 'no-op', host: ['https://example.org'] }],
                   extra_config: {
                     'auth/validator': { 'alg' => 'RS256',
                                         'jwk_url' => 'https://keycloak.dev/auth/realms/dara/protocol/openid-connect/certs',
                                         'cache' => false,
                                         'operation_debug' => true,
                                         'roles_key' => 'realm_access.roles',
                                         'roles_key_is_nested' => true,
                                         'roles' => %w[admin guest],
                                         'scopes' => %w[write:pets read:pets] }
                   }
                 },
                 result[0])
  end

  describe 'having extra path items that are not methods' do
    it 'ignores non-method path items' do
      spec_with_extra = KrakendOpenAPI::OA3Reader.new('test/fixtures/pet-store.json')
      spec_with_extra.paths['/pet']['x-extra'] = { 'foo' => 'bar' }
      spec_with_extra.paths['/pet']['parameters'] = { 'foo' => 'bar' }
      subject_with_extra = KrakendOpenAPI::OA3ToKrakendTransformer.new(spec_with_extra, importer_config)

      result = subject_with_extra.transform_paths
      expected = subject.transform_paths
      assert_equal(expected, result)
    end
  end

  describe 'having empty security scopes' do
    it 'is public' do
      result = subject.transform_paths
      scopes = result[1][:extra_config][:'auth/validator']['scopes']
      assert_nil(scopes)
    end
  end

  describe 'having default security scopes' do
    it 'has the default scopes' do
      result = subject.transform_paths
      scopes = result.find { |operation| operation[:method] == 'PATCH' }[:extra_config][:'auth/validator']['scopes']
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

  describe 'when path_items contains no HTTP methods' do
    it 'returns an empty array for that path' do
      spec_with_no_methods = KrakendOpenAPI::OA3Reader.new('test/fixtures/pet-store.json')
      spec_with_no_methods.paths['/no-methods'] = { 'parameters' => [{ 'name' => 'foo', 'in' => 'query' }] }
      subject_with_no_methods = KrakendOpenAPI::OA3ToKrakendTransformer.new(spec_with_no_methods, importer_config)

      result = subject_with_no_methods.transform_paths
      refute_includes(result.map { |ep| ep[:endpoint] }, '/no-methods')
    end
  end
end
