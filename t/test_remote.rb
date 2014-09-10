#!/usr/bin/ruby

require 'stancer'
require 'minitest/autorun'

describe Stancer do

  # Doing this via minitest/mock seems much uglier...
  def OpenURI.open_uri(uri, *rest)
    raise "Unexpected URL" unless uri.to_s == 'http://example.com/data/issues.json'
    open('t/data/issues.json')
  end

  subject { 
    Stancer.new(
      sources: {
        issues:     'http://example.com/data/issues.json',
        votes:      't/data/votes.json',
        indicators: 't/data/indicators.json',
        motions:    't/data/motions.json',
      }
    )
  }

  # Person Stancing

  describe "All stances (MP)" do

    let(:allstances) { subject.all_stances('voter') }

    it "should score Issue 2 correctly" do
      farming = allstances.find { |s| s['id'] == 2 }['stances']
      farming['alfred_adams'][:weight].must_equal 0
      farming['barry_barnes'][:weight].must_equal 10.fdiv(15)
    end

  end


end 

