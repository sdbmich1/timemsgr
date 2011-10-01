require File.dirname(__FILE__) + '/../spec_helper'

describe ObservanceEvent do
  it "should be valid" do
    ObservanceEvent.new.should be_valid
  end
end
