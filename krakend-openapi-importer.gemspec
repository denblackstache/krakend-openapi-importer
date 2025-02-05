# frozen_string_literal: true

require_relative 'lib/importer/version'

Gem::Specification.new do |spec|
  spec.name          = 'krakend-openapi-importer'
  spec.version       = KrakendOpenAPI::VERSION
  spec.authors       = ['Denis Semenenko']
  spec.email         = ['hypercoderx@gmail.com']

  spec.summary       = 'Import OpenAPI spec to KrakenD configuration'
  spec.description   = 'Import endpoints from OpenAPI spec to KrakenD endpoint configuration. Supports OpenAPI v3.0'
  spec.homepage      = 'https://hypercoder.net'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/denblackstache/krakend-openapi-importer'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 1.2'
end
