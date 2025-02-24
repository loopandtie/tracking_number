module TrackingNumber
  class DHL < Base
    def carrier
      :dhl
    end

    def valid_checksum?
      # standard mod 7 check
      sequence, check_digit = matches
      return true if sequence.to_i % 7 == check_digit.to_i
    end
  end

  #DHL Air (a division of DHL Express) have 11 digit numbers
  class DHLExpressAir < DHL
    SEARCH_PATTERN = /(\b([0-9]\s*){11,11}\b)/
    VERIFY_PATTERN = /^([0-9]{10,10})([0-9])$/

    def matches
      self.tracking_number.scan(VERIFY_PATTERN).flatten
    end
  end

  # Cannot find any definitive documentation on this tracking number type
  # But according to all the examples we've seen they are 11 digits,
  # and don't pass the mod7 checksum
  # This is only partially correct, as there are definitely more possibilities for this
  # tracking number type
  # ******************
  # The above no longer seems to be true. We have now encountered 12-digit
  # numbers with an added component that looks like "-PKG1". Apparently, it is
  # still a valid DHLEcommerce number. So far we haven't seen anything other
  # than "-PKG1", but we'll support "-PKG[#]" just in case
  # ******************
  # Lies again. We found some numbers that look like 931569448305001, 658559946587001,
  # 41560887378001, and 7560887424001. 13-15 digits, all ending in 001, and appear to be segmented:
  # [931] [569448305] [001]
  # [658] [559946587] [001]
  # [ 41] [560887378] [001]
  # [  7] [560887424] [001]
  class DHLEcommerce < DHL
    SEARCH_PATTERN = /(\b([0-9]\s*){10}([0-9]\s*)?([0-9]\s*)?(-PKG\d)?((\d){10,12}|(001))?\b)/
    VERIFY_PATTERN = /^([0-9]{10,10})([0-9]){0,2}(-PKG\d)?((\d){10,12}|(001))?\b$/

    def matches
      self.tracking_number.scan(VERIFY_PATTERN).flatten
    end

    def valid_checksum?
      true
    end
  end

  #DHL Express numbers are 10 digits long
  # http://www.dhl.co.uk/content/dam/downloads/uk/Express/PDFs/developer_centre/dhlis9_shipment_and_piece_ranges_v1.3.pdf
  class DHLExpress < DHL
    SEARCH_PATTERN = /(\b([0-9]\s*){10,10}\b)/
    VERIFY_PATTERN = /^([0-9]{9,9})([0-9])$/

    def matches
      self.tracking_number.scan(VERIFY_PATTERN).flatten
    end
  end
end
