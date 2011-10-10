require 'spec_helper'

describe ChannelLocation do

  before(:each) do
    @channel = Factory(:channel)
    @channel_location = @channel.channel_locations.build(:location_id => 1)
  end

  it "should be valid" do
    @channel_location.should be_valid
  end

  it "should create a new instance given valid attributes" do
    @channel_location.save!
  end

  describe "relationship methods" do

    before(:each) do
      @channel_location.save
    end

    it "should have an location method" do
      @channel_location.should respond_to(:location)
    end

    it "should have an channel method" do
      @channel_location.should respond_to(:channel)
    end

    it "should have the right channel" do
      @channel_location.channel.should == @channel
    end

    it "should have the right location" do
      @channel_location.location.should == @location
    end
  end

  describe "validations" do

    it "should require a channel_id" do
      @channel_location.channel_id = nil
      @channel_location.should_not be_valid
    end

    it "should require a location_id" do
      @channel_location.location_id = nil
      @channel_location.should_not be_valid
    end

    context "unique locations per channel" do

      before(:each) do
        @channel_location.save
      end

      it "should reject duplicate channel presenter" do
        @next_channel_location = @channel.channel_locations.build(:location_id => 1)
	@next_channel_location.should_not be_valid
      end

      it "should accept unique channel location" do
        @new_channel = Factory(:channel, :channel_name => Factory.next(:channel_name))
        @next_channel_location = @new_channel.channel_locations.build(:location_id => 2)
	@next_channel_location.should be_valid
      end

      it "should reject duplicate locations for the same channel" do
        @new_channel_location = @channel.channel_locations.build(:location_id => 1)
        @channel_location.channel_id = 1
        @channel_location.location_id = 1
        @channel_location.save

        @new_channel_location.channel_id = 1
        @new_channel_location.location_id = 1
	@new_channel_location.should_not be_valid
      end
    end
  end

end
