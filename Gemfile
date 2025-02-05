# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in krakend-openapi-importer.gemspec
gemspec

gem 'rake', '~> 13.0', '>= 13.2.1'

group :test do
  gem 'fakefs', '~> 2.8', '>= 2.8.0'
  gem 'minitest', '~> 5.25', '>= 5.25.4'
end

group :development do
  gem 'bump', '~> 0.10.0'
  gem 'rubocop', '~> 1.71', require: false
  gem 'rubocop-performance', require: false
end

group :test, :development do
  gem 'awesome_print'
end
