require_relative "../ref_schema_parser"

module OpenApi2JsonSchema
  module AttributeHandlers
    class Discriminator
      def call(discriminator_schema)
        raise "discriminator schema must be a Hash" unless discriminator_schema.is_a?(Hash)
        raise "discriminator schema must contain mapping" unless discriminator_schema['mapping']

        mapping = discriminator_schema["mapping"]
        mapping.map do |key, file_path|
          mapping[key] = OpenApi2JsonSchema::RefSchemaParser.new.call(file_path)
        end

        discriminator_schema
      end
    end
  end
end
