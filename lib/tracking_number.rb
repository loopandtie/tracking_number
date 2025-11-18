# Identify if tracking numbers are valid, and which service they belong to

# Information on validating tracking numbers found here:
# http://answers.google.com/answers/threadview/id/207899.html

require 'tracking_number/base'
require 'tracking_number/usps'
require 'tracking_number/fedex'
require 'tracking_number/ups'
require 'tracking_number/dhl'
require 'tracking_number/ontrac'
require 'tracking_number/dpd'
require 'tracking_number/gls'
require 'tracking_number/amazon'
require 'tracking_number/veho'

if defined?(ActiveModel::EachValidator)
  require 'tracking_number/active_model_validator'
end

module TrackingNumber
  TYPES = [
    UPS,
    UPSMailInnovationsInternational,
    UPSTest,
    USPS91,
    USPS20,
    USPS13,
    USPSTest,
    FedExExpress,
    FedExSmartPost,
    FedExGround,
    FedExGround18,
    FedExGround96,
    DHLExpress,
    DHLExpressAir,
    DHLEcommerce,
    OnTrac,
    GLS,
    DPD,
    Amazon,
    Veho
  ]

  def self.search(body)
    TYPES.collect { |type| type.search(body) }.flatten
  end

  def self.detect(tracking_number)
    tn = nil
    for test_klass in (TYPES+[Unknown])
      tn = test_klass.new(tracking_number)
      break if tn.valid?
    end
    return tn
  end

  def self.detect_all(tracking_number)
    tn = nil
    results = []
    for test_klass in (TYPES+[Unknown])
      tn = test_klass.new(tracking_number)
      results << tn if tn.valid?
    end
    return results.empty? ? results << tn : results
  end

  def self.new(tracking_number, all: false)
    if all
      self.detect_all(tracking_number)
    else
      self.detect(tracking_number)
    end
  end
end
