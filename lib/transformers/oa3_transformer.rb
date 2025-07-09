# frozen_string_literal: true

require_relative 'plugins/auth_validator_transformer'

module KrakendOpenAPI
  # Transforms OpenAPI paths to KrakenD endpoints
  class OA3ToKrakendTransformer
    SCHEME_TYPES_WITH_ROLES = %w[openIdConnect oauth2].freeze
    PATH_METHODS = %w[get put post delete options head patch trace].freeze

    def initialize(spec, importer_config)
      @spec = spec
      @importer_config = importer_config
    end

    def transform_paths
      @spec.paths.map { |path, path_items| transform_path(path, path_items) }.flatten
    end

    private

    def oauth_scopes_for(securities)
      return nil if securities.nil?

      securities.map do |security|
        security.filter_map do |name, scopes|
          next nil unless oauth_security_scheme_names.include?(name)

          scopes
        end
      end.flatten.uniq
    end

    def oauth_security_scheme_names
      @spec.security_schemes.filter_map do |name, scheme|
        next nil unless SCHEME_TYPES_WITH_ROLES.include?(scheme['type'])

        name
      end
    end

    def transform_path(path, path_items)
      methods = path_items.filter { |k, _| PATH_METHODS.include?(k) }
      methods.map { |method, operation| transform_method(path, method, operation) }
    end

    def transform_method(path, method, operation)
      roles = if operation['x-jwt-roles']&.length
                operation['x-jwt-roles']
              else
                # TODO: @deprecated 'all_roles' legacy config should be removed in the next major release
                @importer_config['default_roles'] || @importer_config['all_roles']
              end
      scopes = oauth_scopes_for(operation['security']) || oauth_scopes_for(@spec.security)
      plugins = []
      plugins << auth_validator_plugin(roles, scopes) if auth_validator_plugin_enabled?(roles, scopes)
      endpoint = krakend_endpoint(path, method)
      endpoint[:extra_config] = endpoint_extra_config(plugins) unless plugins.empty?

      endpoint
    end

    def krakend_endpoint(path, method)
      {
        endpoint: path,
        method: method.upcase,
        output_encoding: @importer_config['defaults']&.dig('endpoint', 'output_encoding'),
        input_headers: @importer_config['defaults']&.dig('endpoint', 'input_headers'),
        input_query_strings: @importer_config['defaults']&.dig('endpoint', 'input_query_strings'),
        backend: [{
          url_pattern: path,
          encoding: @importer_config['defaults']&.dig('backend', 0, 'encoding'),
          host: @importer_config['defaults']&.dig('backend', 0, 'host')
        }.compact]
      }.compact
    end

    def auth_validator_plugin_enabled?(roles, scopes)
      @importer_config['defaults']&.dig('plugins', 'auth_validator') &&
        (roles&.any? || scopes&.any?)
    end

    def auth_validator_plugin(roles, scopes)
      Plugins::AuthValidatorTransformer
        .new
        .transform_to_hash(
          roles: roles,
          scopes: scopes,
          config: @importer_config['defaults']['plugins']['auth_validator']
        )
    end

    def endpoint_extra_config(plugins)
      plugins.each_with_object({}) do |plugin, memo|
        memo[plugin[:name].to_sym] = plugin[:value]
      end
    end
  end
end
