# frozen_string_literal: true

module KrakendOpenAPI
  module Plugins
    # Transforms Auth Validator plugin definition
    class AuthValidatorTransformer
      def transform_to_hash(config:, roles: [], scopes: [])
        value = {
          alg: config['alg'],
          jwk_url: config['jwk_url'],
          cache: config['cache'],
          operation_debug: config['operation_debug'],
          roles_key_is_nested: config['roles_key_is_nested'],
          roles_key: config['roles_key'],
          scopes_key: config['scopes_key']
        }.compact

        value[:roles] = roles unless roles.nil? || roles.empty?
        value[:scopes] = scopes unless scopes.nil? || scopes.empty?

        {
          name: 'auth/validator',
          value: value
        }
      end
    end
  end
end
