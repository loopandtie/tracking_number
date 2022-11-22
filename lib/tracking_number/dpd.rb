module TrackingNumber
  class DPD < Base
    SEARCH_PATTERN = /(\b1597\s?\d{4}\s?\d{3}\s?\d{3}\s?[a-zA-Z0-9]$\b)/
    VERIFY_PATTERN = /^1597\s?\d{4}\s?\d{3}\s?\d{3}\s?[a-zA-Z0-9]$/
    def carrier
      :dpd
    end

    def matches
      self.tracking_number.gsub(/\s+/, "").scan(VERIFY_PATTERN).flatten
    end

    # We don't know anything about these tracking numbers ¯\_(ツ)_/¯
    def valid_checksum?
      true
    end
  end
end
