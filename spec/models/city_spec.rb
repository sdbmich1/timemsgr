require 'spec_helper'

describe City do

  before(:each) do
    @attr = {
      :city => "Anytown"
    }
  end

  it "should create a new city" do
    City.create!(@attr)
  end
end
