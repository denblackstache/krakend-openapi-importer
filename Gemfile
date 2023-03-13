# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in krakend-openapi-importer.gemspec
gemspec

gem 'rake', '~> 13.0'

group :test do
  gem 'fakefs', '~> 2.0'
  gem 'minitest', '~> 5.13'
end

group :development do
  gem 'bump', '~> 0.10.0'
  gem 'rubocop', require: false
end

group :test, :development do
  gem 'awesome_print'
end
