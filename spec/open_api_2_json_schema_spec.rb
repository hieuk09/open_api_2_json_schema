# frozen_string_literal: true

RSpec.describe OpenApi2JsonSchema do
  it "has a version number" do
    expect(OpenApi2JsonSchema::VERSION).not_to be nil
  end

  describe ".convert_from_file" do
    let(:path) { "spec/fixtures/child.yml" }
    subject { described_class.convert_from_file(path) }

    it "converts data correctly" do
      expected_data = JSON.parse(File.read("spec/fixtures/inherited_json_schema.json"))
      expect(JSON.parse(subject)).to eq expected_data
    end
  end

  describe ".convert" do
    let(:schema) do
      {
        "type" => "string",
        "format" => "date-time",
        "nullable" => true
      }
    end
    let(:expected_data) do
      {
        "type" => %w[string null],
        "format" => "date-time",
        "$schema" => "http://json-schema.org/draft-04/schema#"
      }.to_json
    end
    subject { described_class.convert(schema) }

    it { is_expected.to eq expected_data }
  end
end
