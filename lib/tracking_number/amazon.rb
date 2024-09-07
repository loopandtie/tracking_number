module TrackingNumber
  class Amazon < Base
    SEARCH_PATTERN = /(\bTBA\d{12}\b)/
    VERIFY_PATTERN = /^(TBA)\d{12}$/
    def carrier
      :amazon
    end

    def matches
      self.tracking_number.gsub(/\s+/, "").scan(VERIFY_PATTERN).flatten
    end

    # We don't know how to calculate a checksum for this type of tracking number ¯\_(ツ)_/¯
    def valid_checksum?
      true
    end
  end
end
