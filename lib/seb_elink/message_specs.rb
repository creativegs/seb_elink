module SebElink::MessageSpecs
  # Storing SEB-defined specs for messages here

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

  # # 4.2 Message 0003 - Payment order acceptance for processing (P.MU.3 and P.MU.4 parameters):
  # Sequence Parameter title Max length Example of value Description
  # 1. IB_SND_ID 10 B1 Request sender (Banks ID)
  # 2. IB_SERVICE 4 0003 Code of the Internet bank request type
  # 3. IB_VERSION 3 001 ID of used digital signature algorithm
  # 4. IB_PAYMENT_ID 20 UB0000000000015 Payment order reference number
  # 5. IB_AMOUNT 17 1234.56 Payment amount
  # 6. IB_CURR 3 EUR Payment currency (EUR)
  # 7. IB_REC_ID 10 AAA Beneficiary’s identifier (in this case: AAA)
  # 8. IB_REC_ACC 21 Beneficiary’s account (IBAN).
  # 9. IB_REC_NAME 30 Company Beneficiary’s name (in this case: Company)
  # 10. IB_PAYER_ACC 21 Payer’s account (IBAN)
  # 11. IB_PAYER_NAME 110 Jānis Ozols Payer’s name
  # 12. IB_PAYMENT_DESC 100 Your invoice No.1234 is paid Payment order description
  # 13. IB_PAYMENT_DATE 10 12.12.2005 Payment confirmation date (DD.MM.YYYY)
  # 14. IB_PAYMENT_TIME 8 21:12:34 Payment confirmation time (HH:MM:SS)
  # 15. IB_CRC 500 Request digital signature
  # 16. IB_LANG 3 LAT Language (possible values: LAT, ENG, RUS)
  # 17. IB_FROM_SERVER 1 Y / N In case of P.MU.2: Y, P.MU.3: N
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

  # # 4.3 Message 0004 - Payment order execution or cancellation (P.MU.2 and P.MU.5 parameters):
  # Sequence, Parameter title, Max length, Example of value, Description
  # 1. IB_SND_ID 10 B1 Request sender (Banks ID)
  # 2. IB_SERVICE 4 0004 Code of the Internet bank request type
  # 3. IB_VERSION 3 001 ID of used digital signature algorithm
  # 4. IB_REC_ID 10 AAA Beneficiary’s identifier (in this case: “AAA”)
  # 5. IB_PAYMENT_ID 20 UB0000000000015 Payment order reference number
  # 6. IB_PAYMENT_DESC 100 Your invoice No. 1234 is paid Payment order description
  # 7. IB_FROM_SERVER 1 Y/ N In case of P.MU.4: “Y”, P.MU.5: “N”
  # 8. IB_STATUS 12 ACCOMPLISHED Payment order status
  # 9. IB_CRC 300 Message digital signature
  # 10. IB_LANG 3 LAT Language (possible values: “LAT”, “ENG”, “RUS”)
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
