module SebElink::MessageSpecs
  # Storing SEB-defined specs for messages here

  V001_MESSAGE0002_SPEC = {
    IB_SND_ID: {no: 1, in_signature: true, max_length: 10, format: %r'\A.{1,}\z'},
    IB_SERVICE: {no: 2, in_signature: true, max_length: 4, format: %r'\A0002\z'},
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

  V001_MESSAGE0003_SPEC = {
    IB_SND_ID: {no: 1, in_signature: true},
    IB_SERVICE: {no: 2, in_signature: true},
    IB_VERSION: {no: 3, in_signature: true},
    IB_PAYMENT_ID: {no: 4, in_signature: true},
    IB_AMOUNT: {no: 5, in_signature: true},
    IB_CURR: {no: 6, in_signature: true},
    IB_REC_ID: {no: 7, in_signature: true},
    IB_REC_ACC: {no: 8, in_signature: true},
    IB_REC_NAME: {no: 9, in_signature: true},
    IB_PAYER_ACC: {no: 10, in_signature: true},
    IB_PAYER_NAME: {no: 11, in_signature: true},
    IB_PAYMENT_DESC: {no: 12, in_signature: true},
    IB_PAYMENT_DATE: {no: 13, in_signature: true},
    IB_PAYMENT_TIME: {no: 14, in_signature: true},
    IB_PAYMENT_TIME: {no: 15, in_signature: true}
  }.freeze

  V001_MESSAGE0004_SPEC = {
    IB_SND_ID: {no: 1, in_signature: true},
    IB_SERVICE: {no: 2, in_signature: true},
    IB_VERSION: {no: 3, in_signature: true},
    IB_REC_ID: {no: 4, in_signature: true},
    IB_PAYMENT_ID: {no: 5, in_signature: true},
    IB_PAYMENT_DESC: {no: 6, in_signature: true},
    # -- IB_FROM_SERVER {no: 7, in_signature: true},
    IB_STATUS: {no: 7, in_signature: true},
  }.freeze

end
