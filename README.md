# KrakenD OpenAPI Importer

Import endpoints from OpenAPI spec to KrakenD endpoint configuration. Supports OpenAPI v3.0 and up.

[![Ruby](https://github.com/denblackstache/krakend-openapi-importer/actions/workflows/main.yml/badge.svg)](https://github.com/denblackstache/krakend-openapi-importer/actions/workflows/main.yml) [![Gem Version](https://badge.fury.io/rb/krakend-openapi-importer.svg)](https://badge.fury.io/rb/krakend-openapi-importer)

In case you have a different version of OpenAPI you can use <https://github.com/LucyBot-Inc/api-spec-converter> to convert to the v3.0.

## Installation

Execute

    gem install krakend-openapi-importer

## Usage

Import OpenAPI spec from SPEC file. Writes KrakenD config to output.json

```bash
krakend-openapi-importer import SPEC -c CONFIG
```

```bash
Options:
-c, [--config=CONFIG]  # Path to importer.yaml config
```

## Configuration

Example config

```yaml
---
all_roles: ["admin", "guest"] # all available roles for JWT validator
pretty: true
format: "json" # can be 'json' or 'yaml', defaults to `json`
output: "output.json"
defaults:
  base:
    name: Example application
  endpoint:
    output_encoding: "no-op" # act like a no-op proxy
    input_headers: ["*"]
    input_query_strings: ["*"]
  backend:
    - encoding: "no-op"
  plugins:
    auth_validator:
      alg: "RS256"
      jwk_url: "https://KEYCLOAK_URL/auth/realms/master/protocol/openid-connect/certs"
      cache: false
      operation_debug: true
      roles_key: "realm_access.roles"
      roles_key_is_nested: true
      scopes_key: scopes # only needed when defining scopes in openapi spec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/denblackstache/krakend-openapi-importer>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
