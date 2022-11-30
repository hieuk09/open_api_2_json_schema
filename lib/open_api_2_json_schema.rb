# frozen_string_literal: true

require "json"
require "yaml"
require_relative "open_api_2_json_schema/version"
require_relative "attribute_handlers/all_of"
require_relative "attribute_handlers/discriminator"

module OpenApi2JsonSchema
  module_function

  STRUCTS = %w[allOf anyOf oneOf not items additionalProperties schema discriminator]
  NOT_SUPPORTED = %w[
    nullable readOnly
    writeOnly xml externalDocs
    example deprecated
  ]
  VALID_TYPES = %w[integer number string boolean object array null]
  VALID_FORMATS = %w[date-time email hostname ipv4 ipv6 uri uri-reference]

  MIN_INT_32 = 0 - 2**31
  MAX_INT_32 = 2**31 - 1
  MIN_INT_64 = 0 - 2**63
  MAX_INT_64 = 2**63 - 1
  MIN_FLOAT = 0 - 2**128
  MAX_FLOAT = 2**128 - 1
  MAX_DOUBLE = 1.7976931348623157e+308
  MIN_DOUBLE = 0 - MAX_DOUBLE
  BYTE_PATTERN = '^[\\w\\d+\\/=]*$'

  class Error < StandardError; end

  class InvalidTypeError < Error
    def self.build(type)
      new("Type #{type} is not a valid type")
    end
  end

  def convert_from_file(path)
    data = File.read(path)
    convert(YAML.load(data))
  end

  def convert(schema)
    convert_schema(schema).tap do |json_schema|
      json_schema["$schema"] = "http://json-schema.org/draft-04/schema#"
    end.to_json
  end

  def convert_schema(schema)
    json_schema = schema.except(*NOT_SUPPORTED)

    schema.slice(*STRUCTS).each do |struct, data|
      case data
      when Array
        json_schema[struct] = if struct == "allOf"
                                AttributeHandlers::AllOf.new.call(data)
                              else
                                data.map do |item|
                                  convert_schema(item)
                                end
                              end
      when Hash
        json_schema[struct] = if struct == "discriminator"
                                AttributeHandlers::Discriminator.new.call(data)
                              else
                                convert_schema(data)
                              end
      else
        # ignore
      end
    end

    if schema.key?("properties")
      new_properties = convert_properties(schema["properties"])

      if schema["required"].is_a?(Array)
        new_required = clean_required(schema["required"], schema["properties"])
        json_schema["required"] = new_required if new_required.any?
      end

      json_schema["properties"] = new_properties if new_properties.any?
    end

    validate_type(schema["type"])

    json_schema.merge!(convert_types(schema))
    json_schema.merge!(convert_format(schema))

    json_schema
  end

  def validate_type(type)
    raise InvalidTypeError.build(type) unless type.nil? || VALID_TYPES.include?(type)
  end

  def convert_properties(properties)
    return {} unless properties.is_a?(Hash)

    properties.reduce({}) do |result, (key, property)|
      next result unless property.is_a?(Hash)

      result.merge(key => convert_schema(property))
    end
  end

  def convert_types(schema)
    if schema["type"] && schema["nullable"] == true
      type = [schema["type"], "null"]

      if schema["enum"].is_a?(Array)
        {
          "type" => type,
          "enum" => schema["enum"].append(nil)
        }
      else
        { "type" => type }
      end
    else
      {}
    end
  end

  def convert_format(schema)
    case schema["format"]
    when "int32"
      {
        "minimum" => [MIN_INT_32, schema["minimum"] || MIN_INT_32].max,
        "maximum" => [MAX_INT_32, schema["maximum"] || MAX_INT_32].min
      }
    when "int64"
      {
        "minimum" => [MIN_INT_64, schema["minimum"] || MIN_INT_64].max,
        "maximum" => [MAX_INT_64, schema["maximum"] || MAX_INT_64].min
      }
    when "float"
      {
        "minimum" => [MIN_FLOAT, schema["minimum"] || MIN_FLOAT].max,
        "maximum" => [MAX_FLOAT, schema["maximum"] || MAX_FLOAT].min
      }
    when "double"
      {
        "minimum" => [MIN_DOUBLE, schema["minimum"] || MIN_DOUBLE].max,
        "maximum" => [MAX_DOUBLE, schema["maximum"] || MAX_DOUBLE].min
      }
    when "byte"
      { "pattern" => BYTE_PATTERN }
    else
      {}
    end
  end

  def clean_required(required, properties)
    required ||= []
    properties ||= {}

    properties.slice(*required).keys
  end
end
