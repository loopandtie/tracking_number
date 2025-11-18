require 'test_helper'

class VehoTrackingNumberTest < Minitest::Test
  context "a Veho tracking number" do
    ["VHM5JYM1V7B809", "VHEMMR2FAZZQP4", "VHC0EHCVFRSM57"].each do |valid_number|
      should "return veho for #{valid_number}" do
        should_include_valid_number(valid_number, TrackingNumber::Veho, :veho)
      end
    end

    should "not detect an invalid number" do
      results = TrackingNumber::Veho.search("VH12345")
      assert_equal 0, results.size
    end
  end
end
