require "base64"
require "openssl"

require "seb_elink/message_specs"
require "seb_elink/communications"
require "seb_elink/gateway"
require "seb_elink/message"
require "seb_elink/response"
require "seb_elink/version"

module SebElink
  extend self

  def root
    @@root ||= Pathname.new(Gem::Specification.find_by_name("seb_elink").gem_dir)
  end

  DEFAULTS = {
    IB_VERSION: "001",
    IBANK_API_URI: "https://ibanka.seb.lv/ipc/epakindex.jsp",
    IBANK_CERT: <<-HEREDOC
-----BEGIN CERTIFICATE-----
MIIB9TCCAV4CCQC7RlKZ7y4JPTANBgkqhkiG9w0BAQUFADA/MQswCQYDVQQGEwJM
VjENMAsGA1UEBwwEUmlnYTERMA8GA1UECgwIU0VCIGJhbmsxDjAMBgNVBAMMBVNF
QlVCMB4XDTE2MDcxODA4NTQxM1oXDTIxMDYyMjA4NTQxM1owPzELMAkGA1UEBhMC
TFYxDTALBgNVBAcMBFJpZ2ExETAPBgNVBAoMCFNFQiBiYW5rMQ4wDAYDVQQDDAVT
RUJVQjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA3gfAFe64YIu21x2UOTby
stFPMo7TFRWd7oW1L1YQWLHQuNVOh1kjrQWehECyK8cyX1hdHXPoAY3B2Virgj8U
g70ZfO6QQx9zifhlN0gbxRdPjq5jM7Ni5RMWsIayErAhk8IjbPSINLe5l/CpVAhp
yGJWRW8CYH9c/HLsUeg0sKUCAwEAATANBgkqhkiG9w0BAQUFAAOBgQDY9hRVOZkK
957h2Ij8iwV7fIR3Nw8l+248D09xuknBrDOSYMXEDvEPKAW+CS0sQ64MOFybAFRx
YICfpu2DQkcmMM5APo79YzwMCjElRn5BsNyX7oDe4SZHbdUVqF4/mrFI3FU1KdN2
MJizE92BjvgQlJocLJePUi6jbO5YrmICkw==
-----END CERTIFICATE-----
    HEREDOC

  }
end
