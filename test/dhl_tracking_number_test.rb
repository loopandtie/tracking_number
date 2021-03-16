require 'test_helper'

class DHLTrackingNumberTest < Minitest::Test
  context "DHLExpressAir tracking number" do
    ["73891051146"].each do |valid_number|
      should "return dhl for #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::DHLExpressAir, :dhl)
      end

      # Can no longer use this test because an 11 digit number that fails mod7 checksum will
      # now be DHLEcommerce
      #should "fail on check digit changes on #{valid_number}" do
      #  should_fail_on_check_digit_changes(valid_number)
      #end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::DHLExpressAir)
      end
    end
  end

  context "DHLEcommerce tracking number" do
    ["46127012031", "57127019688"].each do |valid_number|
      should "return dhl for #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::DHLEcommerce, :dhl)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::DHLEcommerce)
      end
    end

    ["8130857374", "9131015119"].each do |valid_number|
      should "return dhl for #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::DHLEcommerce, :dhl)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::DHLEcommerce)
      end
    end

    ["100175845662-PKG1", "55160065671-PKG1"].each do |valid_number|
      should "return dhl for #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::DHLEcommerce, :dhl)
      end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::DHLEcommerce)
      end
    end
  end

  context "DHLExpress tracking numbers" do
    ["3318810025", "8487135506", "3318810036", "3318810014"].each do |valid_number|
      should "return dhl for #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::DHLExpress, :dhl)
      end

      #should "fail on check digit changes on #{valid_number}" do
      #  should_fail_on_check_digit_changes(valid_number)
      #end

      should "detect #{valid_number} regardless of spacing" do
        should_detect_number_variants(valid_number, TrackingNumber::DHLExpress)
      end
    end
  end
end
