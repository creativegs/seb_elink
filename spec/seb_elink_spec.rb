# rspec spec/seb_elink_spec.rb
RSpec.describe SebElink do
  it "has a version number" do
    expect(SebElink::VERSION).not_to be nil
  end

  describe ".root" do
    it "returns a Pathname to root of gem" do
      # this spec may fail if you cloned the gem to a custom dir
      expect(SebElink.root.to_s).to match(%r".*/seb_elink\z")
    end
  end
end
