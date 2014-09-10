#!/usr/bin/ruby

require 'stancer'
require 'minitest/autorun'

describe 'MP grouping' do

  subject { 
    Stancer.new({
      sources: {
        votes:      't/data/votes.json',
        issues:     't/data/issues.json',
        indicators: 't/data/indicators.json',
        motions:    't/data/motions.json',
      },
      options: { 
        grouping:   'voter',
      }
    })
  }

  it "should score Issue 2 correctly" do
    farming = subject.all_stances.find { |s| s['id'] == 2 }['stances']
    farming['barry_barnes'][:weight].must_equal 10.fdiv(15)
    farming['pb'].must_be_nil 
  end

end 

describe 'Party grouping' do

  subject { 
    Stancer.new({
      sources: {
        votes:      't/data/votes.json',
        issues:     't/data/issues.json',
        indicators: 't/data/indicators.json',
        motions:    't/data/motions.json',
      },
      options: { 
        grouping:   'group',
      }
    })
  }

  it "should score Issue 2 correctly" do
    farming = subject.all_stances.find { |s| s['id'] == 2 }['stances']
    farming['barry_barnes'].must_be_nil 
    farming['pb'][:weight].must_equal 10.fdiv(15)
  end

end 

