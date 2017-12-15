# rspec spec/seb_elink/response_spec.rb
RSpec.describe SebElink::Response do
  let(:gateway) { SebElink::Gateway.new(test_privkey) }
  let(:response) { described_class.new(gateway, body) }

  # params for message 0004
  let(:body_params) do
    {
      IB_SND_ID: "TESTACC",
      IB_SERVICE: "0004",
      IB_VERSION: "001",
      IB_REC_ID: "AAA",
      IB_PAYMENT_ID: "12345",
      IB_PAYMENT_DESC: "Test Inc. payment 12345",
      IB_FROM_SERVER: "Y",
      IB_STATUS: "ACCOMPLISHED",
      IB_CRC: "digital_signature_here"
    }
  end

  let(:body) { body_params.to_query }

  describe "#valid?" do
    subject { response.valid? }

    context "when message_code is unsupported" do
      let(:body_params) { super().merge(IB_SERVICE: "0000") }

      it "raises a RuntimeError" do
        expect{ subject }.to(
          raise_error(ArgumentError, %r'Fff')
        )
      end
    end

    context "when version is unsupported" do
      let(:body_params) { super().merge(IB_VERSION: "000") }

      it "raises a RuntimeError" do
        expect{ subject }.to(
          raise_error(ArgumentError, %r'Fff')
        )
      end
    end

    context "when body looks like message '0003', aka P.MU.3 and P.MU.4" do
      let(:body_params) do
        {
          IB_SND_ID: "TESTACC",
          IB_SERVICE: "0004",
          IB_VERSION: "001",
          IB_PAYMENT_ID: "12345",
          IB_AMOUNT: "9.95",
          IB_CURR: "EUR",
          IB_REC_ID: "AAA",
          IB_REC_ACC: "123456789",
          IB_REC_NAME: "Test Inc.",
          IB_PAYER_ACC: "987654321",
          IB_PAYER_NAME: "John Smith",
          IB_PAYMENT_DESC: "Test Inc. payment 12345",
          IB_PAYMENT_DATE: "25.12.2017", # DD:MM:YYYY
          IB_PAYMENT_TIME: "23:59:58", # HH:mm:SS
          IB_CRC: "digital_signature_here"
          IB_LANG: "ENG",
          IB_FROM_SERVER: "Y"
        }
      end

      context "when " do
        let(:) {}

        it " " do
          expect(0).to(
            eq(1)
          )
        end
      end
    end

    context "when body looks like message '0004', aka P.MU.2 and P.MU.5" do

      context "when " do
        let(:) {}

        it " " do
          expect(0).to(
            eq(1)
          )
        end
      end
    end
  end

  describe "#to_h(mode=:secure)" do
    subject { response.to_h }

    let(:validity_status) { true }

    before do
      allow(response).to(
        receive(:valid?).and_return(validity_status)
      )
    end

    context "when called without arg on a valid response" do
      it "returns a hash representation of it" do
        expect(0).to(
          eq(1)
        )
      end
    end

    context "when called without arg on an invalid response" do
      let(:validity_status) { false }

      it "raises a SebElink::InvalidResponseError" do
        expect{ subject }.to(
          raise_error(SebElink::InvalidResponseError, %r"The response with body '.*?' is invalid")
        )
      end
    end

    context "when called with a lenient arg on an invalid response" do
      subject { response.to_h(:insecure) }

      let(:validity_status) { false }

      it "returns a hash representation of it" do
        expect(0).to(
          eq(1)
        )
      end
    end
  end
end
