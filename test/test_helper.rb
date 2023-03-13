# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'
require 'fakefs/safe'
require 'pathname'
require 'awesome_print'
require 'json'
require 'yaml'

# Raises an exception if source is not valid JSON
def assert_json(json)
  JSON.parse(json)
end
