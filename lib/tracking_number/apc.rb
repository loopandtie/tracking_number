module TrackingNumber
  # APC Postal Logistics numbers are mostly numeric, and come in 5 formats
  # (10, 13, 16, a "PF" prefixed 13 digit variant, and a 22 character variant).
  #
  # The 22 character variant is undocumented anywhere public, but the numbers we
  # have seen decode cleanly and consistently as:
  #
  #   17008 P 0518 26 0001489557
  #   [acct][?][MMDD][YY][serial]
  #
  # ...where the 5 digit lead falls in the same range as the account-looking
  # prefix on the shorter formats, and the serial increases with the date.
  #
  # A bare 10 digit format also exists, but it is deliberately not supported
  # here: every 10 digit number is already claimed by DHLEcommerce
  #
  # The search patterns intentionally do not allow whitespace between digits,
  # unlike most numeric carriers in this gem. Because these formats are bare
  # digit runs, a whitespace-tolerant pattern would pull 13 and 16 digit
  # subsequences out of nearly every other carrier's spaced number. Numbers
  # passed directly to TrackingNumber.new are still space-insensitive.
  class APC < Base
    SEARCH_PATTERN = [
      /(\bPF\d{13}\b)/,
      # search runs against raw text, before Base upcases, so accept either case
      # here. VERIFY_PATTERN only needs [A-Z] because it runs after.
      /(\b\d{5}[A-Za-z]\d{16}\b)/,
      /(\b\d{13}\b)/,
      /(\b\d{16}\b)/
    ]

    VERIFY_PATTERN = /^(PF\d{13}|\d{5}[A-Z]\d{16}|\d{13}|\d{16})$/

    def carrier
      :apc
    end

    def matches
      self.tracking_number.gsub(/\s+/, "").scan(VERIFY_PATTERN).flatten
    end

    def valid_checksum?
      true
    end
  end
end
