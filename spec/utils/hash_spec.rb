RSpec.describe Utils::Hash do
  describe '.deep_merge' do
    context 'when hash_1 and hash_2 has overlap' do
      let(:hash_1) { { foo: 'bar', hello: { world: 'nice' } } }
      let(:hash_2) { { test: 'test_message', hello: { world: 'nice', earth: 'nice' } } }
      let(:expected) { { foo: 'bar', test: 'test_message', hello: { world: 'nice', earth: 'nice' } } }

      subject { described_class.deep_merge(hash_1, hash_2) }

      it { is_expected.to eq(expected) }
    end

    context 'when hash_1 and hash_2 has no overlap' do
      let(:hash_1) { { foo: 'bar', hello: { world: 'nice' } } }
      let(:hash_2) { { test: 'test_message', hello: { world: 'again' } } }
      let(:expected) { { foo: 'bar', test: 'test_message', hello: { world: 'again' } } }

      subject { described_class.deep_merge(hash_1, hash_2) }

      it { is_expected.to eq(expected) }
    end
  end
end
