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

  let(:issue) { subject.all_issues.find { |i| i['id'] == 2 } }

  it "should instantiate" do
    subject.class.must_equal Stancer
  end

  it "should be able to read files" do
    issue['text'].must_equal 'Farming Subsidies'
  end

  it "should embed indicators into issues" do
    issue['indicators'].wont_be_nil
    issue['indicators'].count.must_equal 2
    issue['indicators'][0]['motion_id'].must_equal "2014-139/b"
  end

end 

