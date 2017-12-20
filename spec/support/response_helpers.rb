module ResponseHelpers
  def valid_0002_request_body_params
    {
      IB_SND_ID: "TESTACC",
      IB_SERVICE: "0002",
      IB_VERSION: "001",
      IB_AMOUNT: "9.95",
      IB_CURR: "EUR",
      IB_NAME: "Test Inc.",
      IB_PAYMENT_ID: "12345",
      IB_PAYMENT_DESC: "Purchase 12345 from Test Inc.",
      IB_FEEDBACK: "https://return.com/some/path",
      IB_LANG: "ENG",
    }
  end

  def valid_0003_response_body_params
    {
      IB_SND_ID: "TESTACC",
      IB_SERVICE: "0003",
      IB_VERSION: "001",
      IB_PAYMENT_ID: "12345",
      IB_AMOUNT: "9.95",
      IB_CURR: "EUR",
      IB_REC_ID: "AAA",
      IB_REC_ACC: "123456789",
      IB_REC_NAME: "Test Inc.",
      IB_PAYER_ACC: "987654321",
      IB_PAYER_NAME: "John Smith",
      IB_PAYMENT_DESC: "Test Inc. payment 12345",
      IB_PAYMENT_DATE: "25.12.2017", # DD:MM:YYYY
      IB_PAYMENT_TIME: "23:59:58", # HH:mm:SS
      IB_CRC:
        "UhbWGOM900VqjBv3idVWtw4aoW5q8FWjLZjak6iVzlmbSPTrnBVuA4ZEyOpW\n"\
        "HhOzhjHFymKOvr1i3Ntx8450vUJln8BSc+yByGS+CslbJEFrHa4mg0Otq4rM\n"\
        "uyQOlFYmF9Ib8ylTHRh3k33CZMoeIH85fbIyaHCGf/BUI7IXU/85qKmJ+rYW\n"\
        "dm3bv4/ZOt6nOKzXD8SMre30X2JGTx38V2hr3upUf36WgUnDmWEzdyN3eRDB\n"\
        "hrveSAOc2BarvgPenR7GRBqsENOhLSCX60X/ryvxoRXGKdMb5knBaqb8EUa8\n"\
        "DB0jZBj33uPr6V07kT8WK7agc3clz/PCtVVb0KdJ2w==\n",
      IB_LANG: "ENG",
      IB_FROM_SERVER: "Y",
    }
  end

  def valid_0003_response
    to_query(valid_0003_response_body_params)
  end

  def valid_0004_response_body_params
    {
      IB_SND_ID: "TESTACC",
      IB_SERVICE: "0004",
      IB_VERSION: "001",
      IB_REC_ID: "AAA",
      IB_PAYMENT_ID: "12345",
      IB_PAYMENT_DESC: "Test Inc. payment 12345",
      IB_FROM_SERVER: "Y",
      IB_STATUS: "ACCOMPLISHED",
      IB_CRC:
        "amXWCuUQ0oHoa1IEyKvhB4/6Z3jRD27MWHofFs9dFJ1eAMM8CzSU05sglKWL\n"\
        "LbfbHou/qPuo3r6GrGI5Pw6gmz/8xHMlNJInrmE/8psOLmgiIYXdisto5lsL\n"\
        "bRjJVf++sLO8C04seLOK8T3IiF7MYhx2ShpBJvbFajSTbwXsRZLz4Rwi9jC+\n"\
        "NGp+zPfNHh8ZAca9XmnPKgCsR6eJC0lot/uJa79dOYM/opiYW1i3PkUYzNZB\n"\
        "Y3OdGqWItVLwMMlpRY+9rkLxYpRDf/6boYVGIijeMGWHSoVsEYu4g762iwKy\n"\
        "C8rwuPxywtuZXEVlqK4c3x4QOrt266aV6qkbPgGf9w==\n",
      IB_LANG: "ENG",
    }
  end

  def valid_0004_response
    to_query(valid_0004_response_body_params)
  end

  def to_query(hash)
    hash.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join("&")
  end

end
