RSpec.describe OpenApi2JsonSchema::AttributeHandlers::Discriminator do
  subject { described_class.new.call(discriminator_schema) }

  context "when schema is valid" do
    let(:discriminator_schema) do
      {
        "propertyName" => "key",
        "mapping" =>
          {
            "value" => "/path-to-file#/schema"
          }

      }
    end
    let(:expected_result) do
      {
        "propertyName" => "key",
        "mapping" => {
          "value" => {
            'type' => "object"
          }
        }
      }
    end

    before do
      expect(OpenApi2JsonSchema::RefSchemaParser).to receive_message_chain(:new, :call)
        .with("/path-to-file#/schema")
        .and_return({ "type" => "object" })
    end

    it { expect(subject).to eq(expected_result) }
  end
end