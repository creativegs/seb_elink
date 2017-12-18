class SebElink::Message
  include SebElink::Communications

  SUPPORTED_VERSIONS = ["001"].freeze
  SUPPORTED_MESSAGES = ["0002"].freeze

  attr_reader :gateway_instance, :message_code, :data_hash

  def initialize(gateway_instance, message_code, data_hash)
    @gateway_instance = gateway_instance

    @message_code = message_code

    validate_message_code

    @data_hash = gateway_instance.defaults.
      merge(IB_SERVICE: @message_code).merge(data_hash)

    validate_version
  end

  def digital_signature
    @digital_signature ||= to_h[:IB_CRC]
  end

  def to_h
    @to_h ||= send("message_#{message_code}")
  end

  private

  def message_0002
    footprint_string = gateway_instance.produce_footprint({
      message_code: message_code,
      version: version,
      skip_validation: false,
      data: data_hash
    })

    # 3. Hash-sign the footprint string => obtain "digital signature" of the message
    digital_signature = gateway_instance.sign(footprint_string)

    # 4. Append IB_CRC key with the "digital signature" and return the hash
    spec_set = gateway_instance.spec_for(version: version, message_code: message_code)
    spec_set.keys.each_with_object({}) do |k, hash|
      hash[k] = data_hash[k] if data_hash.has_key?(k)
    end.merge(IB_CRC: digital_signature)
  end

  def version
    return @version if defined?(@version)

    @version = data_hash[:IB_VERSION]
  end

end
