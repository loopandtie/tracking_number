require 'test_helper'

class SpeedxTrackingNumberTest < Minitest::Test
  context "a SpeedX tracking number" do
    {
      "SPX0GE056700099351"  => "real number",
      "spx0ge056700099351"  => "lower case",
      "SPXABCDE"            => "shortest, 5 after the prefix",
      "SPX#{"A" * 15}"      => "longest, 15 after the prefix"
    }.each do |valid_number, description|
      should "return speedx for #{valid_number} (#{description})" do
        should_be_valid_number(valid_number, TrackingNumber::Speedx, :speedx)
      end

      should "find #{valid_number} in a block of text" do
        results = TrackingNumber.search(search_string(valid_number))
        assert_equal [:speedx], results.map(&:carrier)
      end
    end

    should "ignore spacing" do
      should_be_valid_number("  SPX0GE056 70009 9351  ", TrackingNumber::Speedx, :speedx)
    end

    ["SPX", "", "SPXABCD", "SPX#{"A" * 16}", "SPX1234-5678", "XSPX0GE056700099351", "SP0GE056700099351"].each do |invalid_number|
      should "not return speedx for #{invalid_number.inspect}" do
        assert !TrackingNumber::Speedx.new(invalid_number).valid?
      end
    end

    should "not pull a number out of text that has no SPX prefix" do
      assert_equal 0, TrackingNumber::Speedx.search(search_string("GFUS1234567890")).size
    end
  end

  context "SpeedX's overlap with other carriers" do
    {
      "GFUS1234567890"         => TrackingNumber::Gofo,
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
