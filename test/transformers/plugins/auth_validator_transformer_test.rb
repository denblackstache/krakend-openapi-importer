# frozen_string_literal: true

require 'test_helper'
require_relative '../../../lib/transformers/plugins/auth_validator_transformer'

describe 'Auth Validator Transformer' do
  let(:roles) { ['admin'] }
  let(:importer_config) { YAML.safe_load(File.read('test/fixtures/importer.yaml')) }
  let(:subject) { KrakendOpenAPI::Plugins::AuthValidatorTransformer.new }

  it 'transforms' do
    result = subject.transform_to_hash(roles: roles, config: importer_config['defaults']['plugins']['auth_validator'])
    assert(result)
    assert_equal('auth/validator', result[:name])
    assert_equal({
                   alg: 'RS256',
                   jwk_url: 'https://keycloak.dev/auth/realms/dara/protocol/openid-connect/certs',
                   cache: false,
                   operation_debug: true,
                   roles_key_is_nested: true,
                   roles_key: 'realm_access.roles',
                   roles: ['admin']
                 }, result[:value])
  end

  describe 'having empty roles' do
    let(:roles) { [] }
    it 'returns no roles' do
      result = subject.transform_to_hash(roles: roles, config: {})
      assert_nil(result[:value][:roles])
    end
  end

  describe 'having missing plugin config properties' do
    it 'transforms' do
      result = subject.transform_to_hash(roles: roles, config: {})
      assert_equal({ name: 'auth/validator', value: { roles: ['admin'] } }, result)
    end
  end
end
