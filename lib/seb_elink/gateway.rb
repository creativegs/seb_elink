class SebElink::Gateway
  attr_reader :privkey, :defaults

  def initialize(privkey, defaults={})
    @privkey = privkey
    @defaults = SebElink::DEFAULTS.merge(defaults)
  end

  def ibank_api_uri
    @ibank_api_uri ||= defaults[:IBANK_API_URI]
  end

  def sign(message_footprint)
    digest = Digest::SHA1.hexdigest(message_footprint) #=> "a9993e36..."
    Base64.encode64(privkey_rsa.private_encrypt(digest))
  end

  private
    def privkey_rsa
      @privkey_rsa ||= OpenSSL::PKey::RSA.new(privkey)
    end
end
