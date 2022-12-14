# frozen_string_literal: true

module KrakendOpenAPI
  # Transforms OpenAPI paths to KrakenD endpoints
  class JwtValidatorTransformer
    def transform_to_hash(roles:, config:)
      {
        name: 'auth/validator',
        value: {
          'alg': config['alg'],
          'jwk_url': config['jwk_url'],
          'cache': config['cache'],
          'operation_debug': config['operation_debug'],
          'roles_key_is_nested': config['roles_key_is_nested'],
          'roles_key': config['roles_key'],
          'roles': roles
        }
      }
    end
  end
end
