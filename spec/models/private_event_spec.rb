require File.dirname(__FILE__) + '/../spec_helper'

describe PrivateEvent do
  it "should be valid" do
    PrivateEvent.new.should be_valid
  end
end
