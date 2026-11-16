require 'test_helper'

class GofoTrackingNumberTest < Minitest::Test
  context "a Gofo tracking number" do
    ["GFUS1234567890", "GFUS01ABC23DEF45", "gfus1234567890"].each do |valid_number|
      should "return gofo for #{valid_number}" do
        should_be_valid_number(valid_number, TrackingNumber::Gofo, :gofo)
      end

      should "find #{valid_number} in a block of text" do
        results = TrackingNumber.search(search_string(valid_number))
        assert_equal [:gofo], results.map(&:carrier)
      end
    end

    should "ignore spacing" do
      should_be_valid_number("GFUS 1234 5678 90", TrackingNumber::Gofo, :gofo)
    end

    ["GFUS", "", "GFU1234567890", "XGFUS1234567890", "US1234567890"].each do |invalid_number|
      should "not return gofo for #{invalid_number.inspect}" do
        assert !TrackingNumber::Gofo.new(invalid_number).valid?
      end
    end

    should "not pull a number out of text that has no GFUS prefix" do
      assert_equal 0, TrackingNumber::Gofo.search(search_string("UUS0570455416253")).size
    end
  end

  context "Gofo's overlap with other carriers" do
    {
      "UUS0570455416253"       => TrackingNumber::Uniuni,
      "VHM5JYM1V7B809"         => TrackingNumber::Veho,
      "1Z879E930346834440"     => TrackingNumber::UPS,
      "17008P0518260001489557" => TrackingNumber::APC
    }.each do |number, type|
      should "still detect #{number} as #{type}" do
        assert_equal type, TrackingNumber.new(number).class
      end
    end
  end
end
