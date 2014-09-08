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


  describe "separate indicators" do

    let(:issue) { subject.all_issues.find { |i| i['id'] == 2 } }

    it "should instantiate" do
      subject.class.must_equal Stancer
    end

    it "should be able to read files" do
      issue['title'].must_equal 'Farming Subsidies'
    end

    it "should embed indicators into issues" do
      issue['indicators'].wont_be_nil
      issue['indicators'].count.must_equal 2
    end

    it "should embed motions into issues" do
      issue['indicators'][0]['motion']['id'].must_equal "2014-139/b"
      issue['indicators'][0]['motion']['text'].must_equal "Abolish all farming subsidies"
      issue['indicators'][0]['motion']['vote_events'][0]['votes'].find { |v| v['voter']['id'] == 'alfred_adams' }['option'].must_equal "no"
    end

  end

  describe "embedded indicators" do

    let(:issue) { subject.all_issues.find { |i| i['id'] == 3 } }

    it "should handle pre-embedded indicators" do
      issue['indicators'].wont_be_nil
      issue['indicators'].count.must_equal 2
      issue['indicators'][1]['motion_id'].must_equal "2009-f10/b3"
    end

  end

end 

