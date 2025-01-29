# frozen_string_literal: true

require_relative './plugins/auth_validator_transformer'

module KrakendOpenAPI
  # Transforms OpenAPI paths to KrakenD endpoints
  class OA3ToKrakendTransformer
    SCHEME_TYPES_WITH_ROLES = %w[openIdConnect oauth2]

    def initialize(spec, importer_config)
      @spec = spec
      @importer_config = importer_config
    end

    def transform_paths
      @spec.paths.map { |path, methods| transform_path(path, methods) }.flatten
    end

    private

    def oauth_scopes_for(securities)
      return nil if securities.nil?

      securities.map do |security|
        security.map do |name, scopes|
          next nil unless oauth_security_scheme_names.include?(name)

          scopes
        end.compact
      end.flatten.uniq
    end

    def oauth_security_scheme_names
      @spec.security_schemes.map do |name, scheme|
        next nil unless SCHEME_TYPES_WITH_ROLES.include?(scheme['type'])

        name
      end.compact
    end

    def transform_path(path, methods)
      methods.map { |method, operation| transform_method(path, method, operation) }
    end

    def transform_method(path, method, operation)
      roles = operation['x-jwt-roles']&.length ? operation['x-jwt-roles'] : @importer_config['all_roles']
      scopes = oauth_scopes_for(operation['security']) || oauth_scopes_for(@spec.security)

      plugins = []
      if @importer_config['defaults']&.dig('plugins', 'auth_validator')
        plugins << Plugins::AuthValidatorTransformer
                   .new
                   .transform_to_hash(roles: roles,
                                      scopes: scopes,
                                      config: @importer_config['defaults']['plugins']['auth_validator'])
      end

      endpoint = {
        endpoint: path,
        method: method.upcase,
        output_encoding: @importer_config['defaults']&.dig('endpoint', 'output_encoding'),
        input_headers: @importer_config['defaults']&.dig('endpoint', 'input_headers'),
        input_query_strings: @importer_config['defaults']&.dig('endpoint', 'input_query_strings'),
        backend: [{ url_pattern: path, encoding: @importer_config['defaults']&.dig('backend', 0, 'encoding') }.compact]
      }.compact

      if plugins&.length&.> 0
        extra_config = plugins.each_with_object({}) do |plugin, memo|
          memo[plugin[:name].to_sym] = plugin[:value]
        end

        endpoint[:extra_config] = extra_config
      end

      endpoint
    end
  end
end
