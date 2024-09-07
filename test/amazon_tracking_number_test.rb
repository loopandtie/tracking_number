require 'test_helper'

class AmazonTrackingNumberTest < Minitest::Test
  context "an Amazon tracking number" do
    ["TBA314711923623", "TBA314708961174", "TBA314766516747"].each do |valid_number|
      should "return amazon for #{valid_number}" do
        should_include_valid_number(valid_number, TrackingNumber::Amazon, :amazon)
      end
    end

    should "not detect an invalid number" do
      results = TrackingNumber::Amazon.search("TBA3147665167470")
      assert_equal 0, results.size
    end
  end
end
