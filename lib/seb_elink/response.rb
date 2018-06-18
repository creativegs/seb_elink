class SebElink::Response
  include SebElink::Communications

  SUPPORTED_VERSIONS = ["001"].freeze
  SUPPORTED_MESSAGES = ["0003", "0004"].freeze

  attr_reader :gateway_instance, :body

  def initialize(gateway_instance, body)
    @gateway_instance = gateway_instance
    @body = body
  end

  def valid?
    return @valid if defined?(@valid)

    validate_message_code
    validate_version

    footprint = gateway_instance.produce_footprint({
      message_code: message_code,
      version: version,
      skip_validation: true,
      data: body_hash
    })

    @valid = gateway_instance.verify({
      version: version,
      message: footprint,
      base64_signature: body_hash[:IB_CRC]
    })
  end

  def to_h(mode=:secure)
    raise SebElink::InvalidResponseError.new(
      "The response with body '#{body}' is invalid"
    ) if mode != :insecure && !valid?

    @to_h ||= body_hash
  end

  private
    def body_hash
      @body_hash ||= CGI.unescape(body).split("&").each_with_object({}) do |pair, hash|
        split_index = pair.index("=")
        key, value = pair[0..(split_index - 1)], pair[split_index.next..-1]
        hash[key.to_sym] = value.to_s
      end
    end

    def message_code
      return @message_code if defined?(@message_code)

      @message_code = body_hash[:IB_SERVICE]
    end

    def version
      return @version if defined?(@version)

      @version = body_hash[:IB_VERSION]
    end

end

class SebElink::InvalidResponseError < RuntimeError
end
