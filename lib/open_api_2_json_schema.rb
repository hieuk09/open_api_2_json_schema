# frozen_string_literal: true

require 'json'
require 'yaml'
require 'oas_parser'
require_relative "open_api_2_json_schema/converter"
require_relative "open_api_2_json_schema/version"

module OpenApi2JsonSchema
  module_function

  class Error < StandardError; end
  class InvalidTypeError < Error
    def self.build(type)
      new("Type #{type} is not a valid type")
    end
  end

  def convert_from_file(path)
    convert(OasParser::Definition.resolve(path).raw)
  end

  def convert(schema)
    Converter.new.convert(schema)
  end
end
