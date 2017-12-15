class SebElink::Gateway
  include SebElink::MessageSpecs

  attr_reader :privkey, :defaults

  def initialize(privkey, defaults={})
    @privkey = privkey
    @defaults = SebElink::DEFAULTS.merge(defaults)
  end

  def ibank_api_uri
    @ibank_api_uri ||= defaults[:IBANK_API_URI]
  end

  # options: {
  #   message_code: "000x",
  #   version: "00x"
  #   skip_validation: false, # true for from-SEB messages like 0003 and 0004
  #   data: {
  #     IB_SND_ID: "TESTACC",
  #     ...
  #   }
  # }
  def produce_footprint(options)
    data_hash = options[:data]
    spec_set = spec_for(version: options[:version], message_code: options[:message_code])

    footprint_string = spec_set.map do |field, spec|
      next unless spec[:in_signature]

      unless options[:skip_validation]
        # 1. validate each field's length in .bytesize and format
        raise_nil_error(field) if data_hash[field] == nil
        raise_length_error(field) if data_hash[field].to_s.bytesize > spec[:max_length]
        raise_format_error(field) if !data_hash[field].to_s[spec[:format]]
      end

      # 2. build the 'len(p1)||p1..' string
      "#{data_hash[field].to_s.bytesize.to_s.rjust(3, "0")}#{data_hash[field]}"
    end.join("")
  end

  # options: {
  #   version: "00x",
  #   message_code: "000x"
  # }
  def spec_for(options)
    send(:class).const_get("V#{options[:version]}_MESSAGE#{options[:message_code]}_SPEC")
  end

  def sign(message_footprint)
    digest = Digest::SHA1.hexdigest(message_footprint) #=> "a9993e36..."
    Base64.encode64(privkey_rsa.private_encrypt(digest))
  end

  # def verify(message_footprint, )

  # end

  private
    def privkey_rsa
      @privkey_rsa ||= OpenSSL::PKey::RSA.new(privkey)
    end

    def raise_length_error(field)
      raise ArgumentError.new("#{field} value is too long")
    end

    def raise_format_error(field)
      raise ArgumentError.new("#{field} value format does not match the spec")
    end

    def raise_nil_error(field)
      raise ArgumentError.new("#{field} key is absent")
    end
end
