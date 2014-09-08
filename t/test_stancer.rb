#!/usr/bin/ruby

require 'stancer'
require 'minitest/autorun'

describe "when starting out" do

  it "should instantiate" do
    stancer = Stancer.new()
    stancer.class.must_equal Stancer
  end

end 

