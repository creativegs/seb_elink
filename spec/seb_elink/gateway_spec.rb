# rspec spec/seb_elink/gateway_spec.rb
RSpec.describe SebElink::Gateway do
  include ResponseHelpers

  let(:gateway) { described_class.new(test_privkey) }

  describe "#ibank_api_uri" do
    it "returns the api uri for POSTin users off to" do
      expect(gateway.ibank_api_uri).to(
        eq("https://ibanka.seb.lv/ipc/epakindex.jsp")
      )
    end
  end

  describe "#sign(options)" do
    let(:message_footprint) { "001a002bb" }
    let(:options) { {version: "001", message_footprint: message_footprint} }

    it "produces a base64 ditigal signature for a message from the pre-crunched footprint" do
      expect(gateway.sign(options)).to(
        eq(
          "aKwfiynsSmR6LbEqqvNKdSZf3ScrpJvZHVR3g78OTydqfaN6RNGC0IfvuQTm\n"\
          "yJ/Ld1eBtt0zbmgJ46pjEWlpOaggv99EwUb9FYlj0sRYLC5BOcmz7WEOEvQi\n"\
          "hlc3xoSwXWutJHi/dMfa7oXMBe+7PSTZW+TbL5YeXPfsunCyTWG8ZGixOkdh\n"\
          "yDrvK04KP6nSk69jpNmdrs0v33iigzHOxmJDTReRUahMF3/BfMNszjDXapAw\n"\
          "pkzOrMvmAI46F1Q+iRlT0iUprdE6sbuYN+L64BfGpveZeS+8HC06FgJ4ZTmq\n"\
          "A5/uI/1LTmYGlrPsY4zlmCG1MfZxRIFtPJLiudC+vw==\n"
        )
      )
    end
  end

  describe "#verify(options)" do
    subject { gateway.verify(options) }

    let(:gateway) { described_class.new(test_privkey, {IBANK_CERT: test_ibank_crt}) }
    let(:ibank_gateway) { described_class.new(test_ibank_privkey) }
    let(:ibank_message) { valid_0004_response_body_params }

    let(:ibank_message_footprint) do
      ibank_gateway.produce_footprint({
        message_code: ibank_message[:IB_SERVICE],
        version: ibank_message[:IB_VERSION],
        skip_validation: true,
        data: ibank_message
      })
    end

    let(:ibank_message_signature) do
      ibank_gateway.sign({
        message_footprint: ibank_message_footprint,
        version: ibank_message[:IB_VERSION],
      })
    end

    context "when asked to verify an OK message" do
      let(:options) do
        {
          version: "001",
          message: ibank_message_footprint,
          base64_signature: ibank_message_signature
        }
      end

      it { is_expected.to eq(true) }
    end

    context "when asked to verify a NOK message" do
      let(:options) do
        {
          version: "001",
          message: ibank_message_footprint + "evil tinkering",
          base64_signature: ibank_message_signature
        }
      end

      it { is_expected.to eq(false) }
    end
  end
end
