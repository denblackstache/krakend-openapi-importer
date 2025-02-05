# frozen_string_literal: true

module KrakendOpenAPI
  module Plugins
    # Transforms Auth Validator plugin definition
    class AuthValidatorTransformer
      def transform_to_hash(config:, roles: [], scopes: [])
        value = config.dup

        value['roles'] = roles unless roles.nil? || roles.empty?
        value['scopes'] = scopes unless scopes.nil? || scopes.empty?

        {
          name: 'auth/validator',
          value: value
        }
      end
    end
  end
end
