#!/usr/bin/ruby

require 'stancer'
require 'minitest/autorun'

describe 'MP grouping' do

  subject { 
    Stancer.new({
      sources: {
        issues:     't/data/issues.json',
        indicators: 't/data/indicators.json',
        motions:    't/data/motions.json',
      }
    })
  }

  it "should score Issue 2 correctly" do
    farming = subject.all_stances(group_by: 'voter').find { |s| s['id'] == 2 }['stances']
    farming['barry_barnes'][:weight].must_equal 10.fdiv(15)
    farming['pb'].must_be_nil 
  end

end 

describe 'Party grouping' do

  subject { 
    Stancer.new({
      sources: {
        issues:     't/data/issues.json',
        indicators: 't/data/indicators.json',
        motions:    't/data/motions.json',
      }
    })
  }

  it "should score Issue 2 correctly" do
    farming = subject.all_stances(group_by: 'group').find { |s| s['id'] == 2 }['stances']
    farming['barry_barnes'].must_be_nil 
    farming['pb'][:weight].must_equal 10.fdiv(15)
  end

end 

describe 'exclusions' do

  subject { 
    Stancer.new({
      sources: {
        issues:     't/data/issues.json',
        indicators: 't/data/indicators.json',
        motions:    't/data/motions.json',
      }
    })
  }

  it "should score Issue 2 correctly" do
    farming = subject.all_stances({
      group_by:   'group',
      exclude:    'indicators',
    }).find { |s| s['id'] == 2 }
    farming['indicators'].must_be_nil 
  end

end 

