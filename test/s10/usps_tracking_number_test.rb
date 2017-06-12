require 'test_helper'

class USPSTrackingNumberTest < Minitest::Test
  context "a USPS tracking number" do
    ["RB123456785US"].each do |valid_number|
      should "return usps with valid 13 character number #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::S10::USPS, :usps)
      end

      should "fail on check digit changes on #{valid_number}" do
        should_fail_on_check_digit_changes(valid_number)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::S10::USPS)
      end
    end
  end
end
