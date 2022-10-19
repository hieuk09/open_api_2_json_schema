require_relative "../ref_schema_parser"

module OpenApi2JsonSchema
  module AttributeHandlers
    class Discriminator
      def call(discriminator_schema)
        raise "discriminator schema must be a Hash" unless discriminator_schema.is_a?(Hash)

        mapping = discriminator_schema.fetch("mapping")
        mapping.each do |key, file_path|
          mapping[key] = OpenApi2JsonSchema::RefSchemaParser.new.call(file_path)
        end

        discriminator_schema
      end
    end
  end
end
