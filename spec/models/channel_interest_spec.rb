require 'spec_helper'

describe ChannelInterest do

  before(:each) do
    @channel = Factory(:channel)
    @channel_interest = @channel.channel_interests.build(:interest_id => 1)
  end

  it "should be valid" do
    @channel_interest.should be_valid
  end

  it "should create a new instance given valid attributes" do
    @channel_interest.save!
  end

  describe "relationship methods" do

    before(:each) do
      @channel_interest.save
    end

    it "should have an interest method" do
      @channel_interest.should respond_to(:interest)
    end

    it "should have an channel method" do
      @channel_interest.should respond_to(:channel)
    end

    it "should have the right channel" do
      @channel_interest.channel.should == @channel
    end

    it "should have the right interest" do
      @channel_interest.interest.should == @interest
    end
  end

  describe "validations" do

    it "should require a channel_id" do
      @channel_interest.channel_id = nil
      @channel_interest.should_not be_valid
    end

    it "should require a interest_id" do
      @channel_interest.interest_id = nil
      @channel_interest.should_not be_valid
    end

    context "unique interests per channel" do

      before(:each) do
        @channel_interest.save
      end

      it "should reject duplicate channel presenter" do
        @next_channel_interest = @channel.channel_interests.build(:interest_id => 1)
	@next_channel_interest.should_not be_valid
      end

      it "should accept unique channel interest" do
        @new_channel = Factory(:channel, :channel_name => Factory.next(:channel_name))
        @next_channel_interest = @new_channel.channel_interests.build(:interest_id => 2)
	@next_channel_interest.should be_valid
      end

      it "should reject duplicate interests for the same channel" do
        @new_channel_interest = @channel.channel_interests.build(:interest_id => 1)
        @channel_interest.channel_id = 1
        @channel_interest.interest_id = 1
        @channel_interest.save

        @new_channel_interest.channel_id = 1
        @new_channel_interest.interest_id = 1
	@new_channel_interest.should_not be_valid
      end
    end
  end

end
