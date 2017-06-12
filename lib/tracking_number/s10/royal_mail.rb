module TrackingNumber
  module S10
    class RoyalMail < Generic
      def carrier
        :royal_mail
      end

      def valid_additional_checks?
        identifier = self.tracking_number.to_s.slice(0...1)
        valid_starting_letters = %w(R A B J S V A F K Z T)

        return false unless valid_starting_letters.include?(identifier)
        return false unless self.tracking_number.end_with?("GB")
        return true
      end
    end
  end
end
