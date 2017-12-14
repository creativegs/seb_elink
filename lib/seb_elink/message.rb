class SebElink::Message
  SUPPORTED_MESSAGES = ["0002"].freeze

  MESSAGE_0002_SPEC = {
    IB_SND_ID: {no: 1, in_signature: true, max_length: 10, format: %r'\A.{1,}\z'},
    IB_SERVICE: {no: 2, in_signature: true, max_length: 4, format: %r'\A\d{4}\z'},
    IB_VERSION: {no: 3, in_signature: true, max_length: 3, format: %r'\A001\z'},
    IB_AMOUNT: {no: 4, in_signature: true, max_length: 17, format: %r'\A\d+([.,]\d{,2})?\z'},
    IB_CURR: {no: 5, in_signature: true, max_length: 3, format: %r'\A[A-Z]{3}\z'},
    IB_NAME: {no: 6, in_signature: true, max_length: 30, format: %r'\A.{1,}\z'},
    IB_PAYMENT_ID: {no: 7, in_signature: true, max_length: 20, format: %r'\A[0-9a-zA-Z]{1,20}\z'},
    IB_PAYMENT_DESC: {no: 8, in_signature: true, max_length: 100, format: %r'\A.{1,}\z'},
    # IB_CRC: {no: 9, in_signature: false, max_length: 500, format: %r'\A.*\z'},
    IB_FEEDBACK: {no: 10, in_signature: false, max_length: 150, format: %r'\A.*\z'},
    IB_LANG: {no: 11, in_signature: false, max_length: 3, format: %r'\A(?:LAT)|(?:ENG)|(?:RUS)\z'},
  }.freeze

  attr_reader :gateway_instance, :message_code, :data_hash

  def initialize(gateway_instance, message_code, data_hash)
    @gateway_instance = gateway_instance

    raise ArgumentError.new(
      "'#{message_code}' is not a supported message code. Supported ones are: #{SUPPORTED_MESSAGES}"
    ) unless SUPPORTED_MESSAGES.include?(message_code)

    @message_code = message_code

    @data_hash = gateway_instance.defaults.
      merge(IB_SERVICE: @message_code).merge(data_hash)
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
    footprint_string = MESSAGE_0002_SPEC.map do |field, spec|
      next unless spec[:in_signature]

      # 1. validate each field's length in .bytesize and format
      raise_nil_error(field) if data_hash[field] == nil.to_s.bytesize > spec[:max_length]
      raise_length_error(field) if data_hash[field].to_s.bytesize > spec[:max_length]
      raise_format_error(field) if !data_hash[field].to_s[spec[:format]]

      # 2. build the 'len(p1)||p1..' string
      "#{data_hash[field].to_s.bytesize.to_s.rjust(3, "0")}#{data_hash[field]}"
    end.join("")

    # 3. Hash-sign the footprint string => obtain "digital signature" of the message
    digital_signature = gateway_instance.sign(footprint_string)

    # 4. Append IB_CRC key with the "digital signature" and return the hash
    MESSAGE_0002_SPEC.keys.each_with_object({}) do |k, hash|
      hash[k] = data_hash[k] if data_hash.has_key?(k)
    end.merge(IB_CRC: digital_signature)
  end

  def raise_length_error(field)
    raise ArgumentError.new("#{field} value is too long")
  end

  def raise_format_error(field)
    raise ArgumentError.new("#{field} value format does not match the spec")
  end

end
