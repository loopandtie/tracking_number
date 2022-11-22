module TrackingNumber
  class GLS < Base
    SEARCH_PATTERN = /(\bCPS\d{17}\b)/
    VERIFY_PATTERN = /^CPS\d{17}$/
    def carrier
      :gls
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
