require File.dirname(__FILE__) + '/../spec_helper'

describe Affiliation do
  it "should be valid" do
    Affiliation.new.should be_valid
  end
end
