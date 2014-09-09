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

  # Stancing

  describe Stancer::Stance do

    let(:issue) { subject.all_issues.find { |i| i['id'] == 2 } }
    let(:stance) { subject.issue_stance(issue) }

    it "should have a Stance" do
      stance.class.must_equal Stancer::Stance
    end

    it "should have one entry per MP" do
      h = stance.to_h
      h.keys.sort.must_equal ['alfred_adams', 'barry_barnes']
    end

    it "should have underlying vote data correct" do
      aa = stance.to_h['alfred_adams'] 
      aa[:num_votes].must_equal 2
      aa[:num_motions].must_equal 2
      aa[:counts].find { |c| c[:option] == 'no' }[:value].must_equal 1
      aa[:counts].find { |c| c[:option] == 'yes' }[:value].must_equal 1
    end

    it "should score Adams correctly" do
      v = stance.to_h['alfred_adams'] 
      v[:score].must_equal 0
      v[:max].must_equal 15
      v[:weight].must_equal 0.fdiv(15)
    end

    it "should score Barnes correctly" do
      v = stance.to_h['barry_barnes'] 
      v[:score].must_equal 10
      v[:max].must_equal 15
      v[:weight].must_equal 10.fdiv(15)
    end

  end

  # Tests for underlying data structures 
  
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

    it "should embed votes into motions" do
      issue['indicators'][0]['motion']['id'].must_equal "2012-76/a"
      issue['indicators'][0]['motion']['vote_events'][0]['votes'].find { |v| v['voter_id'] == 'alfred_adams' }['option'].must_equal "yes"
    end

  end


end 

