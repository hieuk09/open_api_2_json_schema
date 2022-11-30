require "yaml"
require_relative "./utils/uri_normalizer"

module OpenApi2JsonSchema
  class RefSchemaParser
    def call(ref_path, base_path = nil)
      file_path, fragments = normalize_path(ref_path, base_path)
      ref_schema = load_file(file_path)
      fragment_schema = ref_schema

      if fragments
        fragments.split("/").each do |fragment|
          fragment_schema = fragment_schema[fragment] if fragment && fragment != "" && fragment_schema[fragment]
        end
      end

      fragment_schema
    end

    private

    def normalize_path(path, base_path)
      normalized_ref_path = if base_path && base_path != ""
                              Utils::URINormalizer.normalize_ref(path, base_path).to_s
                            else
                              path
                            end
      temp_path = normalized_ref_path.split("#")
      raise "Invalid reference path" if temp_path.size > 2

      temp_path
    end

    def load_file(path)
      data = File.read(path)
      YAML.safe_load(data)
    end
  end
end
