RSpec.describe OpenApi2JsonSchema::AttributeHandlers::AllOf do
  subject { described_class.new.call(all_of_schemas) }

  context "when the all_of_schemas is invalid" do
    let(:all_of_schemas) { {} }

    it { expect { subject }.to raise_error("allOf schema must be an Array") }
  end

  context "when there is invalid sub-schema" do
    let(:all_of_schemas) { [1] }

    it { expect { subject }.to raise_error("Invalid schema: allOf[0]") }
  end

  context "when the everything is valid" do
    let(:all_of_schemas) do
      [
        {
          "$ref" => "/path-to-file#/schema"
        },
        {
          "type" => "object",
          "properties" => {
            "attr_1" => {
              "type" => "string"
            },
            "attr_2" => {
              "type" => "string"
            }
          }
        }
      ]
    end
    let(:expected_result) do
      [
        { "type" => "object" },
        {
          "type" => "object",
          "properties" => {
            "attr_1" => {
              "type" => "string"
            },
            "attr_2" => {
              "type" => "string"
            }
          }
        }
      ]
    end

    context "when base path is provided" do
      let(:base_path) { "/open_api/path-to-file" }

      subject { described_class.new.call(all_of_schemas, base_path) }

      before do
        expect(OpenApi2JsonSchema::RefSchemaParser).to receive_message_chain(:new, :call)
          .with("/path-to-file#/schema", base_path)
          .and_return({ "type" => "object" })
      end

      it { expect(subject).to eq(expected_result) }
    end

    context "when base path is not provided" do
      before do
        expect(OpenApi2JsonSchema::RefSchemaParser).to receive_message_chain(:new, :call)
          .with("/path-to-file#/schema", "")
          .and_return({ "type" => "object" })
      end

      it { expect(subject).to eq(expected_result) }
    end
  end
end
