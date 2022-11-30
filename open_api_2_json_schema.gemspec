# frozen_string_literal: true

require_relative "lib/open_api_2_json_schema/version"

Gem::Specification.new do |spec|
  spec.name = "open_api_2_json_schema"
  spec.version = OpenApi2JsonSchema::VERSION
  spec.authors = ["hieuk09"]
  spec.email = ["hieuk09@gmail.com"]

  spec.summary = "OpenAPI v3.0 schema to JSON Schema draft 4 converter"
  spec.description = "Due to the OpenAPI v3.0 and JSON Schema discrepancy, you can use this JS library to convert OpenAPI Schema objects to proper JSON Schema. "
  spec.homepage = "https://github.com/hieuk09/open_api_2_json_schema"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hieuk09/open_api_2_json_schema"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "addressable", ">= 2.4"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
