# rspec spec/seb_elink/response_spec.rb
RSpec.describe SebElink::Response do
  include ResponseHelpers

  let(:gateway) { SebElink::Gateway.new(test_privkey) }
  let(:response) { described_class.new(gateway, body) }
  let(:body_params_0003) { valid_0003_response_body_params }
  let(:body_params_0004) { valid_0004_response_body_params }
  let(:body) { body_params_0004.map { |k, v| "#{k}=#{v}" }.join("&") }

  before do
    # binding.pry
  end

  describe "#valid?" do
    subject { response.valid? }

    let(:mocked_validity_status) { true }

    before do
      allow(gateway).to(
        receive(:verify).and_return(mocked_validity_status)
      )
    end

    context "when message_code is unsupported" do
      let(:body_params_0004) { super().merge(IB_SERVICE: "0000") }

      it "raises a RuntimeError" do
        expect{ subject }.to(
          raise_error(ArgumentError, %r"'0000' is not a supported message code")
        )
      end
    end

    context "when version is unsupported" do
      let(:body_params_0004) { super().merge(IB_VERSION: "000") }

      it "raises a RuntimeError" do
        expect{ subject }.to(
          raise_error(ArgumentError, %r"'000' is not")
        )
      end
    end

    context "when body looks like message '0003', aka P.MU.3 and P.MU.4 of v1" do
      let(:body) { body_params_0003.map { |k, v| "#{k}=#{v}" }.join("&") }

      it "returns the boolean gateway validity check returns" do
        expect(subject).to eq(mocked_validity_status)
      end
    end

    context "when body looks like message '0004', aka P.MU.2 and P.MU.5" do
      it "returns the boolean gateway validity check returns" do
        expect(subject).to eq(mocked_validity_status)
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

    context "when called without the argument on a valid response" do
      it "returns a hash representation of it" do
        expect(subject).to match(valid_0004_response_body_params)
      end
    end

    context "when called without the argument on an invalid response" do
      let(:validity_status) { false }

      it "raises a SebElink::InvalidResponseError" do
        expect{ subject }.to(
          raise_error(
            SebElink::InvalidResponseError,
            %r"The response with body '.*?' is invalid"m
          )
        )
      end
    end

    context "when called with a lenient arg on an invalid response" do
      subject { response.to_h(:insecure) }

      let(:validity_status) { false }

      it "returns a hash representation of it" do
        expect(subject).to match(valid_0004_response_body_params)
      end
    end

    context "when called leniently with uri-escaped values" do
      subject { response.to_h(:insecure) }

      let(:validity_status) { false }

      let(:body_params_0004) { valid_0004_response_body_params.merge(IB_PAYMENT_DESC: "Cookies+%3D+instawin") }

      xit "returns a un unescaped hash representation of it" do
        expect(subject).to match(hash_including(IB_PAYMENT_DESC: "Cookies = instawin"))
      end
    end
  end
end
