#!/usr/bin/ruby

require 'stancer'
require 'minitest/autorun'

describe Stancer do

  subject { 
    Stancer.new(
      sources: {
        votes:      't/data/votes.json',
        issues:     't/data/issues.json',
        indicators: 't/data/indicators.json',
        motions:    't/data/motions.json',
      }
    )
  }

  it "should instantiate" do
    subject.class.must_equal Stancer
  end

  it "should know where to find files" do
    subject.source(:votes).must_equal 't/data/votes.json'
  end

end 

