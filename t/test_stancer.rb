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

  it "should be able to read files" do
    subject.source_data(:issues).first['id'].must_equal 2
  end

end 

