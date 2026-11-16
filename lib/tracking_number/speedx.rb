module TrackingNumber
  class Speedx < Base
    # search runs against raw text, before Base upcases
    SEARCH_PATTERN = /(\bSPX[A-Z0-9]{5,15}\b)/i
    VERIFY_PATTERN = /^SPX[A-Z0-9]{5,15}$/

    def carrier
      :speedx
    end

    def matches
      self.tracking_number.gsub(/\s+/, "").scan(VERIFY_PATTERN).flatten
    end

    def valid_checksum?
      true
    end
  end
end
