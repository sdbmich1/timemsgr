require File.dirname(__FILE__) + '/../spec_helper'

describe RSVP do
  it "should be valid" do
    RSVP.new.should be_valid
  end
end
