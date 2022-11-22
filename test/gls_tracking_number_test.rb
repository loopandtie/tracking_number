require 'test_helper'

class GLSTrackingNumberTest < Minitest::Test
  context "a GLS tracking number" do
    ["CPS32608180000226071", "CPS32604290000226052", "CPS32458300000225699"].each do |valid_number|
      should "return gls for #{valid_number}" do
        should_include_valid_number(valid_number, TrackingNumber::GLS, :gls)
      end
    end

    should "not detect an invalid number" do
      results = TrackingNumber::GLS.search("CPS324583000002256990")
      assert_equal 0, results.size
    end
  end
end
