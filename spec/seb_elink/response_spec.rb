# rspec spec/seb_elink/response_spec.rb
RSpec.describe SebElink::Response do
  include ResponseHelpers

  let(:gateway) { SebElink::Gateway.new(test_privkey) }
  let(:response) { described_class.new(gateway, body) }
  let(:body_params_0003) { valid_0003_response_body_params }
  let(:body_params_0004) { valid_0004_response_body_params }
  let(:body) { to_query(body_params_0004) }

  describe "#valid?" do
    subject(:validity) { response.valid? }

    let(:mocked_validity_status) { true }

    before do
      allow(gateway).to(
        receive(:verify).and_return(mocked_validity_status)
      )
    end

    context "when message_code is unsupported" do
      let(:body_params_0004) { super().merge(IB_SERVICE: "0000") }

      it "raises a RuntimeError" do
        expect{ validity }.to(
          raise_error(ArgumentError, %r"'0000' is not a supported message code")
        )
      end
    end

    context "when version is unsupported" do
      let(:body_params_0004) { super().merge(IB_VERSION: "000") }

      it "raises a RuntimeError" do
        expect{ validity }.to(
          raise_error(ArgumentError, %r"'000' is not")
        )
      end
    end

    context "when body looks like message '0003', aka P.MU.3 and P.MU.4 of v1" do
      let(:body) { to_query(body_params_0003) }

      it "returns what the boolean gateway validity check returns" do
        expect(validity).to eq(mocked_validity_status)
      end

      # edge
      context "when the bank message contains non-ASCII symbols" do
        let!(:message) do
          {
            "IB_SND_ID"=>"SEBUB", "IB_SERVICE"=>"0003", "IB_VERSION"=>"001",
            "IB_PAYMENT_ID"=>"1192579", "IB_AMOUNT"=>"6.95", "IB_CURR"=>"EUR",
            "IB_REC_ID"=>"DIET", "IB_REC_ACC"=>"LV74UNLA0055000378910",
            "IB_REC_NAME"=>"SCIENCE22 SIA",
            "IB_PAYER_ACC"=>"LV37UNLA0050004858444",
            "IB_PAYER_NAME"=>"REINIS LIMONCIKS",
            "IB_PAYMENT_DESC"=>"desc",
            "IB_PAYMENT_DATE"=>"18.06.2018",
            "IB_PAYMENT_TIME"=>"09:07:45"
          }
        end

        let!(:fakeseb_gateway) { SebElink::Gateway.new(test_ibank_privkey) }

        let!(:fakseseb_crc) do
          footprint = fakeseb_gateway.produce_footprint({
            message_code: "0003",
            version: "001",
            skip_validation: true,
            data: message
          })

          options = {
            version: "001",
            message_footprint: footprint
          }

          fakeseb_gateway.sign(options)
        end

        let(:body) { to_query(message.merge("IB_CRC" => fakseseb_crc)) }

        let(:gateway) { SebElink::Gateway.new(test_privkey, {IBANK_CERT: test_ibank_crt}) }

        before do
          allow(gateway).to receive(:verify).and_call_original
        end

        context "when the message is valid" do
          xit { is_expected.to eq(true) }
        end

        context "when the message is invalid" do
          xit { is_expected.to eq(false) }
        end
      end
    end

    context "when body looks like message '0004', aka P.MU.2 and P.MU.5 of v1" do
      it "returns what the boolean gateway validity check returns" do
        expect(validity).to eq(mocked_validity_status)
      end
    end
  end

  describe "#to_h(mode=:secure)" do
    subject(:hash) { response.to_h }

    let(:gateway) { SebElink::Gateway.new(test_privkey, {IBANK_CERT: test_ibank_crt}) }

    context "when called without explicit arguments" do
      context "when the response is valid" do
        before { mock_response_to_be(true) }

        it "returns a hash representation of it" do
          expect(hash).to match(valid_0004_response_body_params)
        end
      end

      context "when the response is innvalid" do
        before { mock_response_to_be(false) }

        it "raises a SebElink::InvalidResponseError" do
          expect{ hash }.to(
            raise_error(
              SebElink::InvalidResponseError,
              %r"The response with body '.*?' is invalid"m
            )
          )
        end
      end
    end

    context "when called with a lenient arg on an invalid response" do
      subject(:hash) { response.to_h(:insecure) }

      before { mock_response_to_be(false) }

      it "returns a hash representation of it" do
        expect(hash).to match(valid_0004_response_body_params)
      end
    end

    def mock_response_to_be(status)
      allow(gateway).to receive(:verify).and_return(status)
    end
  end
end
