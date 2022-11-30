RSpec.describe OpenApi2JsonSchema::RefSchemaParser do
  subject { described_class.new.call(ref_path) }

  context "when reference path is invalid" do
    let(:ref_path) { "long#kute.yml#/schema1/schema2" }

    it { expect { subject }.to raise_error("Invalid reference path") }
  end

  context "when reference path is valid" do
    context "when a base path is provided" do
      let(:ref_path) { "long/kute.yml#/schema1/schema2" }
      let(:base_path) { "/path/to/file" }
      let(:expected_result) { { "type" => "object" } }

      subject { described_class.new.call(ref_path, base_path) }

      before do
        expect(Utils::URINormalizer).to receive(:normalize_ref)
          .with(ref_path, base_path)
          .and_return("long/kute.yml")
        expect(File).to receive(:read).with("long/kute.yml").and_return("type: object")
        expect(YAML).to receive(:safe_load).with("type: object").and_return(expected_result)
      end

      it { expect(subject).to eq(expected_result) }
    end

    context "when a base path is not provided" do
      let(:ref_path) { "long/kute.yml#/schema1/schema2" }
      let(:ref_schema) do
        {
          "schema1" => {
            "schema2" => {
              "data" => "data"
            }
          }
        }
      end

      before do
        expect(File).to receive(:read)
          .with("long/kute.yml")
          .and_return("data")

        expect(YAML).to receive(:safe_load)
          .with("data")
          .and_return(ref_schema)
      end

      it { expect(subject).to eq({ "data" => "data" }) }
    end
  end
end
