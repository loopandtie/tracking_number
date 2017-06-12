require 'test_helper'

class GenericNumberTest < Minitest::Test
  context "a generic S10 tracking number" do
    ["XX123456785IN"].each do |valid_number|
      should "return generic 13 character number #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::S10::Generic, :generic_s10)
      end

      should "fail on check digit changes on #{valid_number}" do
        should_fail_on_check_digit_changes(valid_number)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::S10::Generic)
      end
    end
  end
end
