require 'test_helper'

class APCTrackingNumberTest < Minitest::Test
  context "an APC tracking number" do
    {
      "1057329461823"    => "13 digits",
      "9284410250372"    => "13 digits",
      "1057329461823456" => "16 digits",
      "9284410250372681" => "16 digits",
      "PF1057329461823"  => "PF prefix + 13 digits",
      "PF9284410250372"  => "PF prefix + 13 digits",
      "17008P0518260001489557" => "22 characters",
      "17008P0715260001893201" => "22 characters",
      "16889P0720260001923956" => "22 characters",
      "17008A0518260001489557" => "22 characters, non-P alpha",
      "16889Z0720260001923956" => "22 characters, non-P alpha"
    }.each do |valid_number, description|
      should "return apc for #{valid_number} (#{description})" do
        should_be_valid_number(valid_number, TrackingNumber::APC, :apc)
      end

      should "find #{valid_number} in a block of text" do
        results = TrackingNumber::APC.search(search_string(valid_number))
        assert_equal 1, results.size
        assert_equal valid_number, results.first.tracking_number
      end

      should "ignore spacing in #{valid_number}" do
        spaced = valid_number.chars.to_a.join(" ")
        should_be_valid_number(spaced, TrackingNumber::APC, :apc)
      end
    end

    # 10 digit APC numbers exist, but every 10 digit number is already claimed by
    # DHL, so they are not supported. See lib/tracking_number/apc.rb
    ["1057329461", "10573294618", "105732946182", "10573294618234",
     "105732946182345", "10573294618234567", "PF105732946182",
     "PF10573294618234", "PF1057329461823456",
     # near misses on the 22 character format: the alpha in the wrong position,
     # wrong lengths either side of it, a digit or non-alphanumeric in the alpha
     # slot, and a trailing letter
     "1700P05182600014895571", "170081P0518260001489557", "17008P051826000148955",
     "17008P05182600014895577", "170080051826000148955", "17008-0518260001489557",
     "17008P051826000148955A", "17008PP518260001489557"].each do |invalid_number|
      should "not return apc for #{invalid_number}" do
        assert !TrackingNumber::APC.new(invalid_number).valid?
      end
    end
  end

  context "APC's overlap with other carriers" do
    # Numbers other carriers own, and must keep owning. APC is registered last in
    # TYPES, so a 13 digit number ending in 001 stays with DHLEcommerce.
    {
      "3318810014"             => TrackingNumber::DHLExpress,
      "8130857374"             => TrackingNumber::DHLEcommerce,
      "7560887424001"          => TrackingNumber::DHLEcommerce,
      "986578788855"           => TrackingNumber::FedExExpress,
      "568283610012000"        => TrackingNumber::FedExGround,
      "9611020987654312345672" => TrackingNumber::FedExGround96,
      "15976814979246S"        => TrackingNumber::DPD,
      "C11031500001879"        => TrackingNumber::OnTrac,
      "TBA314766516747"        => TrackingNumber::Amazon,
      "UUS0570455416253"       => TrackingNumber::Uniuni
    }.each do |number, type|
      should "still detect #{number} as #{type}" do
        assert_equal type, TrackingNumber.new(number).class
      end
    end

    # APC's formats are bare digit runs, so its search patterns must not allow
    # whitespace between digits — otherwise APC harvests 13 and 16 digit
    # subsequences out of other carriers' numbers, spaced or not.
    ["3318810014", "986578788855", "568283610012000", "9611020987654312345672",
     "15976814979246S", "C11031500001879", "TBA314766516747", "UUS0570455416253",
     "1Z879E930346834440", "9400111201080805483016", "CPS32608180000226071",
     "801716432500182727", "73891051146", "100175845662-PKG1"].each do |number|
      [number, number.chars.to_a.join(" "), number.chars.to_a.join("  ")].each do |variant|
        should "not pull an APC number out of #{variant}" do
          results = TrackingNumber::APC.search(search_string(variant))
          assert_equal 0, results.size, "APC found #{results.map(&:tracking_number).inspect} in #{variant}"
        end
      end
    end
  end
end
