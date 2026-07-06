module TrackingNumber
  class Uniuni < Base
    SEARCH_PATTERN = [
      /(\bUUS\w+\b)/,
      /(\bUNI\d{11,14}\b)/,
      /(\bUNIA\d{9}YQ\b)/,
      /(\bJY\d{15}\b)/,
      /(\bAS\d{8}CN\b)/,
      /(\bAQ\d{8}CN\b)/
    ]

    VERIFY_PATTERN = /^(UUS\w+|UNI\d{11,14}|UNIA\d{9}YQ|JY\d{15}|AS\d{8}CN|AQ\d{8}CN)$/

    def carrier
      :uniuni
    end

    def matches
      self.tracking_number.gsub(/\s+/, "").scan(VERIFY_PATTERN).flatten
    end

    def valid_checksum?
      true
    end
  end
end
