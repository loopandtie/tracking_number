module TrackingNumber
  class Gofo < Base
    # search runs against raw text, before Base upcases
    SEARCH_PATTERN = /(\bGFUS\w+\b)/i
    VERIFY_PATTERN = /^GFUS\w+$/

    def carrier
      :gofo
    end

    def matches
      self.tracking_number.gsub(/\s+/, "").scan(VERIFY_PATTERN).flatten
    end

    def valid_checksum?
      true
    end
  end
end
