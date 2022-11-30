require_relative "../ref_schema_parser"

module OpenApi2JsonSchema
  module AttributeHandlers
    class AllOf
      def call(all_of_schemas, base_path = "")
        raise "allOf schema must be an Array" unless all_of_schemas.is_a?(Array)

        all_of_schemas.each_with_index.map do |schema, index|
          raise "Invalid schema: allOf[#{index}]" unless schema.is_a?(Hash)

          if schema["$ref"]
            OpenApi2JsonSchema::RefSchemaParser.new.call(schema["$ref"], base_path)
          else
            schema
          end
        end
      end
    end
  end
end
