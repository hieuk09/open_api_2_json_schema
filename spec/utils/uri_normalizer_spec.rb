RSpec.describe Utils::URINormalizer do
  describe ".normalize_ref" do
    subject { described_class.normalize_ref(uri, base) }

    context "when URI has no path" do
      let(:uri) { "http://foo-bar.com" }
      let(:base) { "http://www.example.com/foo/#bar" }

      it { is_expected.to eq(Addressable::URI.parse("http://foo-bar.com/#")) }
    end

    context "when URI has a path" do
      let(:uri) { "http://foo-bar.com/some/thing" }
      let(:base) { "http://www.example.com/foo/#bar" }

      it { is_expected.to eq(Addressable::URI.parse("http://foo-bar.com/some/thing#")) }
    end

    context "when URI has a fragment" do
      let(:uri) { "http://foo-bar.com/some/thing#foo" }
      let(:base) { "http://www.example.com/foo/#bar" }

      it { is_expected.to eq(Addressable::URI.parse("http://foo-bar.com/some/thing#foo")) }
    end

    context "when URI has a fragment but base has no fragment" do
      let(:uri) { "http://foo-bar.com/some/thing#foo" }
      let(:base) { "http://www.example.com/hello" }

      it { is_expected.to eq(Addressable::URI.parse("http://foo-bar.com/some/thing#foo")) }
    end

    context "when URI is a relative path" do
      let(:uri) { "hello/world" }
      let(:base) { "http://www.example.com/foo/#bar" }

      it { is_expected.to eq(Addressable::URI.parse("http://www.example.com/foo/hello/world#")) }
    end
  end
end
