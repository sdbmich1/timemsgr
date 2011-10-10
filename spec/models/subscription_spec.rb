require File.dirname(__FILE__) + '/../spec_helper'

describe Subscription do
  before(:each) do
    @channel = Factory(:channel)
    @subscription = Factory.build(:subscription, :user_id => 1, :channelID => Factory.next(:channelID), :contentsourceID => 'ABC345')
  end

  it "should be valid" do
    @subscription.should be_valid
  end

  it "should create a new instance given valid attributes" do
    @subscription.save!
  end

  describe "relationship methods" do

    before(:each) do
      @subscription.save
    end

    it "should have a user attribute" do
      @subscription.should respond_to(:user)
    end

    it "should have the right user" do
      @subscription.user.should == @user
    end

    it "should have a channel attribute" do
      @subscription.should respond_to(:channel)
    end

    it "should have the right channel" do
      @subscription.channel.should be_empty
    end
  end

  describe "validations" do

    it "should require a user_id" do
      @subscription.user_id = nil
      @subscription.should_not be_valid
    end

    it "should require a channelID" do
      @subscription.channelID = nil
      @subscription.should_not be_valid
    end

    it "should require a contentsourceID" do
      @subscription.contentsourceID = nil
      @subscription.should_not be_valid
    end

    context "unique channels per user" do

      before(:each) do
        @subscription.save
      end

      it "should reject duplicate user channel" do
        @next_subscription = Factory.build(:subscription, :user_id => 1, :channelID => '1', :contentsourceID => 'ABC123')
	@next_subscription.should_not be_valid
      end

      it "should accept unique user channel" do
        @next_subscription = Factory.build(:subscription, :user_id => 1, :channelID => '2', :contentsourceID => 'ABC234')
	@next_subscription.should be_valid
      end

      it "should reject duplicate channels for the same user" do
        @new_subscription = Factory.build(:subscription, :user_id => 1, :channelID => '1', :contentsourceID => 'ABC123')
        @subscription.user_id = 1
        @subscription.channelID = '1'
        @subscription.save
        @new_subscription.user_id = 1
        @new_subscription.channelID = '1'
	@new_subscription.should_not be_valid
      end
    end
  end
end
