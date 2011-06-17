require 'spec_helper'

describe Channel do
  
  before(:each) do
      @channel = Factory(:channel)  # 
#      @user = Factory.stub(:user)
      @sub = Factory(:channel_location, :channel => @channel) 
  end 
   
  it "should get a list of all possible channels that are active" do
        channels = []
        channels << Factory(:channel, :status => 'active')
        channels << Factory(:channel, :status => 'active')
        channels.each { |e| e.status.should == 'active' }
  end
  
  it "should get a list of all possible channels that are unhidden" do
        channels = []
        channels << Factory(:channel, :hide => 'no')
        channels << Factory(:channel, :hide => 'no')
        channels.each { |e| e.hide.should == 'no' }
  end
  
  describe "location associations" do

    it "should have a locations attribute" do
      @channel.should respond_to(:channel_locations)
    end

  end
  
  
end
