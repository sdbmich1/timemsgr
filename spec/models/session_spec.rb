require File.dirname(__FILE__) + '/../spec_helper'

describe Session do
  it "should be valid" do
    Session.new.should be_valid
  end
end
