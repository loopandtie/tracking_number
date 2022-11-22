require 'test_helper'

class DPDTrackingNumberTest < Minitest::Test
  context "a DPD tracking number" do
    ["1597 7998 838 312 X", "1597 7999 753 674 2", "15976814979246S", "159768149540367"].each do |valid_number|
      should "return dpd for #{valid_number}" do
        should_include_valid_number(valid_number, TrackingNumber::DPD, :dpd)
      end
    end

    should "not detect an invalid number" do
      results = TrackingNumber::DPD.search("1597 7999 753 674 2X")
      assert_equal 0, results.size
    end
  end
end
