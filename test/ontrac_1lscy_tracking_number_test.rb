require 'test_helper'

class OnTrac1LSCYTrackingNumberTest < Minitest::Test
  context "an OnTrac 1LSCY tracking number" do
    {
      "1LSCY1234567890"   => "typical",
      "1lscy1234567890"   => "lower case",
      "1LsCy1234567890"   => "mixed case",
      "1LSCYABC123"       => "shortest, 6 after the prefix",
      "1LSCY#{"A" * 20}"  => "longest, 20 after the prefix"
    }.each do |valid_number, description|
      should "return ontrac for #{valid_number} (#{description})" do
        should_be_valid_number(valid_number, TrackingNumber::OnTrac1LSCY, :ontrac)
      end

      should "find #{valid_number} in a block of text" do
        results = TrackingNumber.search(search_string(valid_number))
        assert_equal [:ontrac], results.map(&:carrier)
      end
    end

    should "ignore surrounding whitespace" do
      should_be_valid_number("  1LSCY1234567890  ", TrackingNumber::OnTrac1LSCY, :ontrac)
    end

    ["1LSCY", "", "   ", "1LSCY12345", "1LSCY#{"A" * 21}", "1LSCY1234-5678", "X1LSCY1234567890", "1LSC1234567890"].each do |invalid_number|
      should "not return ontrac 1LSCY for #{invalid_number.inspect}" do
        assert !TrackingNumber::OnTrac1LSCY.new(invalid_number).valid?
      end
    end

    should "not pull a bare 1LSCY prefix out of text" do
      assert_equal 0, TrackingNumber::OnTrac1LSCY.search(search_string("1LSCY")).size
    end
  end

  context "OnTrac 1LSCY's overlap with other carriers" do
    {
      "D11031500001878"        => TrackingNumber::OnTrac,
      "C11031500001879"        => TrackingNumber::OnTrac,
      "UUS0570455416253"       => TrackingNumber::Uniuni,
      "1Z879E930346834440"     => TrackingNumber::UPS,
      "GFUS1234567890"         => TrackingNumber::Gofo,
      "SPX0GE056700099351"     => TrackingNumber::Speedx,
      "17008P0518260001489557" => TrackingNumber::APC
    }.each do |number, type|
      should "still detect #{number} as #{type}" do
        assert_equal type, TrackingNumber.new(number).class
      end
    end
  end
end
