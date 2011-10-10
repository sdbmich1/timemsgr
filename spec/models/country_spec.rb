require 'spec_helper'

describe Country do
  before(:each) do
    @country = Factory.build(:country)
  end

  it "should be valid" do
    @country.should be_valid
  end

  describe "country methods" do

    it "should have a location attribute" do
      @country.should respond_to(:locations)
    end
  end

end
