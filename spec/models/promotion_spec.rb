require File.dirname(__FILE__) + '/../spec_helper'

describe Promotion do
  it "should be valid" do
    Promotion.new.should be_valid
  end
end
