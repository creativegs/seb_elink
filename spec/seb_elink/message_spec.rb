# rspec spec/seb_elink/message_spec.rb
RSpec.describe SebElink::Message do
  let(:gateway) { SebElink::Gateway.new(test_privkey) }

  describe "#initialize(gateway_instance, message_code, data_hash)" do
    subject { described_class.new(gateway, code, {}) }

    context "when called with unsupported :message_code" do
      let(:code) { "0001" }

      it "raises a descriptive ArgumentError" do
        expect{ subject }.to(
          raise_error(ArgumentError, %r"'0001' is not a supported message code.")
        )
      end
    end

    context "when called with a supported :message_code" do
      let(:code) { "0002" }

      it "works OK and returns a Message instance" do
        expect(subject).to be_a(described_class)
      end
    end
  end

  describe "#digital_signature" do
    let(:digital_signature) { "mock_signature" }
    let(:message) { described_class.new(gateway, "0002", {}) }

    before do
      allow(message).to(
        receive(:to_h).and_return({IB_CRC: digital_signature})
      )
    end

    it "returns the digital signature of the message" do
      expect(message.digital_signature).to eq(digital_signature)
    end
  end

  describe "#to_h" do
    let(:message) { described_class.new(gateway, message_code, data) }

    before do
      allow(gateway).to receive(:sign).and_return("mock_signature")
    end

    context "when initialized with '0002' message code" do
      subject { message.to_h }

      let(:message_code) { "0002" }

      let(:incomplete_data) do
        {
          IB_AMOUNT: "9.95",
          IB_CURR: "EUR",
          IB_NAME: "Test Inc.",
          IB_PAYMENT_ID: "12345",
          IB_PAYMENT_DESC: "Purchase 12345 from Test Inc.",
          IB_FEEDBACK: "https://return.com/some/path",
          IB_LANG: "ENG",
        }
      end

      let(:data) { incomplete_data.merge(IB_SND_ID: "TESTACC") }

      let(:expected_ok_data) do
        {
          IB_SND_ID: "TESTACC",
          IB_SERVICE: "0002",
          IB_VERSION: "001",
          IB_AMOUNT: "9.95",
          IB_CURR: "EUR",
          IB_NAME: "Test Inc.",
          IB_PAYMENT_ID: "12345",
          IB_PAYMENT_DESC: "Purchase 12345 from Test Inc.",
          IB_CRC: "mock_signature",
          IB_FEEDBACK: "https://return.com/some/path",
          IB_LANG: "ENG",
        }
      end

      context "when called with an OK, full set of needed data" do
        it "works OK and returns the POSTable data hash" do
          expect(subject).to match(expected_ok_data)
        end
      end

      context "when called with a full, but invalid set of data" do
        let(:data) { super().merge(IB_SND_ID: "FAR TOO LONG") }

        it "raises a descriptive ArgumentError" do
          expect{ subject }.to(
            raise_error(ArgumentError, %r"IB_SND_ID value is too long")
          )
        end
      end

      context "when called with an incomplete set of data" do
        let(:data) { incomplete_data }

        it "raises a descriptive ArgumentError" do
          expect{ subject }.to(
            raise_error(ArgumentError, %r"IB_SND_ID value format does not match the spec")
          )
        end
      end

      context "when called with an incomplete set of data, but gateway that provides defaults" do
        let(:gateway) { SebElink::Gateway.new("placeholder_privkey", {IB_SND_ID: "TESTACC"}) }
        let(:data) { incomplete_data }

        it "works OK and returns the POSTable data hash" do
          expect(subject).to match(expected_ok_data)
        end
      end
    end
  end
end
