require 'test_helper'

class UniuniTrackingNumberTest < Minitest::Test
  context "a Uniuni tracking number" do
    {
      "UUS0570455416253" => "UUS prefix",
      "UUS0460452985903" => "UUS prefix",
      "UNI12345678901"   => "UNI prefix",
      "UNI123456789012"  => "UNI prefix",
      "UNIA302278352YQ"  => "UNIA prefix",
      "JY123456776787898" => "JY prefix",
      "AS302245752CN"    => "AS prefix",
      "AQ302234432CN"    => "AQ prefix"
    }.each do |valid_number, description|
      should "return uniuni for #{valid_number} (#{description})" do
        should_include_valid_number(valid_number, TrackingNumber::Uniuni, :uniuni)
      end
    end

    should "not detect a number without a Uniuni prefix" do
      results = TrackingNumber::Uniuni.search("ABC123456789")
      assert_equal 0, results.size
    end
  end
end
