# rspec spec/seb_elink/gateway_spec.rb
RSpec.describe SebElink::Gateway do
  let(:gateway) { described_class.new(test_privkey) }

  describe "#ibank_api_uri" do
    it "returns the api uri for POSTin users off to" do
      expect(gateway.ibank_api_uri).to(
        eq("https://ibanka.seb.lv/ipc/epakindex.jsp")
      )
    end
  end

  describe "#sign(message_footprint)" do
    let(:message_footprint) { "001a002bb" }

    it "produces a base64 ditigal signature for a message from the pre-crunched footprint" do
      expect(gateway.sign(message_footprint)).to(
        eq(
          "FaZbf/ACcRQxjZHRyYJ5K7lmtrjdArvIo7LNWc6jKFcK9GLIwrQw4KDQn14E\n"\
          "JNL2xUnm+KS9Oy7Ji3pNDVYvhjCtCCOF+D0uwnfct70fr3xpGBB0JZKSYyxo\n"\
          "LrSGiCZI3YkcyhhWR8t3/+KfxhI17wVFy1n9SbtFrqCrQ+JwOGqT02Z8AxMl\n"\
          "V8oNLE9ZHqX0CZ6M2Ftv+gRLWnLbzwCKQwcerrWRmGWq05EoAf9Du8+X0OIf\n"\
          "2ghgdKJYiWbSO0XjZKmm6R7QtXgyj0wUq+mDBl7QI+2Rbcon4YUeMobq21iG\n"\
          "asMfT9YaXxlvsFNszvOhz64JtaMgN7auwQ8iHAx3rw==\n"
        )
      )
    end
  end
end
