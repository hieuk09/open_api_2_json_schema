RSpec.describe OpenApi2JsonSchema::AttributeHandlers::Discriminator do
  subject { described_class.new.call(discriminator_schema) }

  context 'when there is invalid sub-schema' do

    context 'when schema is not a Hash' do
      let(:discriminator_schema) { [1] }

      it { expect { subject }.to raise_error('discriminator schema must be a Hash') }
    end

    context 'when schema is not a Hash' do
      let(:discriminator_schema) { {} }

      it { expect { subject }.to raise_error('discriminator schema must contain mapping') }
    end

  end

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
