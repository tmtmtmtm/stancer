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

  let(:plain) { subject.all_stances(group_by: 'voter').find { |s| s['id'] == 2 }['stances'] }
  let(:keyed) { subject.all_stances(group_by: 'voter', format: 'hash').find { |s| s['id'] == 2 }['stances'] }

  it "should return individual records by default" do
    plain.must_be_instance_of Array
    plain.first.must_be_instance_of Hash
  end

  it "should have correct scores in individual records" do
    barnes  = plain.find { |s| s[:voter] == 'barry_barnes' }
    barnes[:weight].must_equal 10.fdiv(15)
  end

  it "should be possible to get a keyed hash" do
    keyed.must_be_instance_of Hash
    keyed.first.must_be_instance_of Array # Pair
  end

  it "should have correct scores in keyed records" do
    barnes  = keyed['barry_barnes']
    barnes[:weight].must_equal 10.fdiv(15)
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
    farming = subject.all_stances(group_by: 'group', format: 'hash').find { |s| s['id'] == 2 }['stances']
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

