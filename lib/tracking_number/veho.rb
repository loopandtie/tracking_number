module TrackingNumber
  class Veho < Base
    SEARCH_PATTERN = /(\bVH\w{12}\b)/
    VERIFY_PATTERN = /^(VH)\w{12}$/
    def carrier
      :veho
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
