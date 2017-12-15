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

  # AKA P.MU.1
  # Sequence, Parameter title, Max length, Example of value, Description
  # 1, IB_SND_ID, 10, SOMENAME, AAA Request sender (E-system)
  # 2, IB_SERVICE, 4, 0002, Code of the Internet bank request type. Constant 0002
  # 3, IB_VERSION, 3, 001, ID of used digital signature algorithm. Constant 001.
  # 4, IB_AMOUNT, 17, 1234.56, Payment amount
  # 5, IB_CURR, 3, EUR, Payment currency (EUR)
  # 6, IB_NAME, 30, Company Beneficiary’s name, (in this case: Company)
  # 7, IB_PAYMENT_ID, 20, UB0000000000015, Payment order reference number
  # 8, IB_PAYMENT_DESC, 100, Your invoice No. 1234 is paid, Payment order description
  # 9, IB_CRC, 500, abs51ajksa..., Request digital signature
  # 10, IB_FEEDBACK, 150, URL to which the Bank will send the message of acceptance
  #   of the payment order for processing, execution, cancellation.
  # 11, IB_LANG, 3, LAT, Preferable language (LAT, ENG, RUS)
  def message_0002
    # footprint_string = MESSAGE_0002_SPEC.map do |field, spec|
    #   next unless spec[:in_signature]

    #   # 1. validate each field's length in .bytesize and format
    #   raise_nil_error(field) if data_hash[field] == nil.to_s.bytesize > spec[:max_length]
    #   raise_length_error(field) if data_hash[field].to_s.bytesize > spec[:max_length]
    #   raise_format_error(field) if !data_hash[field].to_s[spec[:format]]

    #   # 2. build the 'len(p1)||p1..' string
    #   "#{data_hash[field].to_s.bytesize.to_s.rjust(3, "0")}#{data_hash[field]}"
    # end.join("")

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
