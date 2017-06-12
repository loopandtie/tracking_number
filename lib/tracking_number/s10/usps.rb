# Priority Mail Express International®
# => EC 000 000 000 US

# Priority Mail International®
# => CP 000 000 000 US

# Priority Mail Express
# => EA 000 000 000 US

module TrackingNumber
  module S10
    class USPS < Generic
      def carrier
        :usps
      end

      def service_type
        case decode[:service_code]
        when "EC"
          "Priority Mail Express International"
        when "CP"
          "Priority Mail International"
        when "EA"
          "Priority Mail Express"
        end
      end

      def valid_additional_checks?
        identifier = self.tracking_number.to_s.slice(0...1)
        valid_starting_letters = %w(R A E D T V C L G M)

        return false unless valid_starting_letters.include?(identifier)

        return false unless self.tracking_number.end_with?("US")
        return true
      end
    end
  end
end
