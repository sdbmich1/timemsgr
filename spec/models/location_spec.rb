require 'spec_helper'

describe Location do


  before(:each) do
    @location = Factory.build :location, :country_id => 1
  end

  it "should be valid" do
    @location.should be_valid
  end

  describe 'country' do
    
    it "should have an country method" do
      @location.should respond_to(:country)
    end
  end

  describe 'channels' do
    it "should have an channel_locations method" do
      @location.should respond_to(:channel_locations)
    end
    
    it "should have an channels method" do
      @location.should respond_to(:channels)
    end
  end

  describe 'events' do
    
    it "should have an events method" do
      @location.should respond_to(:events)
    end
  end

end
