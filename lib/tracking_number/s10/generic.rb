module TrackingNumber
  module S10
    class Generic < Base
      include Checksum::Mod11With8642357Weighting

      VERIFY_PATTERN = /^([A-Z]{2}[0-9]{9}[A-Z]{2})$/
      SEARCH_PATTERN = [/(\b([A-Z]\s*){2}([0-9]\s*){9}([A-Z]\s*)([A-Z]\s*)\b)/]

      def carrier
        results = TrackingNumber::S10_DATA[self.decode[:origin_country]]

        if results && results["carrier_key"]
          results["carrier_key"].to_sym
        else
          :unknown
        end
      end

      def decode
        {:service_code => self.tracking_number.to_s.slice(0...2),
         :package_identifier =>  self.tracking_number.to_s.slice(3...10),
         :serial_number =>  self.tracking_number.to_s.slice(3...10),
         :check_digit => self.tracking_number.slice(11...11),
         :origin_country => self.tracking_number.slice(11...13)
        }
      end
    end
  end
end
