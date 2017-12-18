module SebElink::Communications
  private

  def validate_message_code
    message_codes = send(:class)::SUPPORTED_MESSAGES

    raise ArgumentError.new(
      "'#{message_code}' is not a supported message code. Supported ones are: #{message_codes}"
    ) unless message_codes.include?(message_code)
  end

  def validate_version
    versions = send(:class)::SUPPORTED_VERSIONS

    raise ArgumentError.new(
      "'#{version}' is not a supported version. Supported ones are: #{versions}"
    ) unless versions.include?(version)
  end
end
