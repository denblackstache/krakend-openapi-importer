# frozen_string_literal: true

require_relative './plugins/auth_validator_transformer'

module KrakendOpenAPI
  # Transforms OpenAPI paths to KrakenD endpoints
  class OA3ToKrakendTransformer
    def initialize(paths, importer_config)
      @paths = paths
      @importer_config = importer_config
    end

    def transform_paths
      @paths.map { |path, methods| transform_path(path, methods) }.flatten
    end

    private

    def transform_path(path, methods)
      methods.map { |method, operation| transform_method(path, method, operation) }
    end

    def transform_method(path, method, operation)
      roles = operation['x-jwt-roles']&.length ? operation['x-jwt-roles'] : @importer_config['all_roles']

      plugins = []
      plugins << Plugins::AuthValidatorTransformer
                 .new
                 .transform_to_hash(roles: roles,
                                    config: @importer_config['defaults']['plugins']['auth_validator'])

      endpoint = {
        endpoint: path,
        method: method.upcase,
        output_encoding: @importer_config['defaults']['endpoint']['output_encoding'],
        input_headers: @importer_config['defaults']['endpoint']['input_headers'],
        input_query_strings: @importer_config['defaults']['endpoint']['input_query_strings'],
        backend: [{ url_pattern: path, encoding: @importer_config['defaults']['backend'][0]['encoding'] }]
      }

      extra_config = plugins.each_with_object({}) do |plugin, memo|
        memo[plugin[:name].to_sym] = plugin[:value]
      end

      endpoint[:extra_config] = extra_config
      endpoint
    end
  end
end
