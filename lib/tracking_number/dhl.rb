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
  class DHLEcommerce < DHL
    SEARCH_PATTERN = /(\b([0-9]\s*){11,11}\b)/
    VERIFY_PATTERN = /^([0-9]{10,10})([0-9])$/

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
