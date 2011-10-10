require File.dirname(__FILE__) + '/../spec_helper'

describe Channel do

  before(:each) do
    @channel = Factory.build(:channel)
    @newchannel = Factory.create :channel
  end

  it "should be valid" do
    @channel.should be_valid
  end

    it "should have an events method" do
      @channel.should respond_to(:events)
    end

    it "should have an channel_interests method" do
      @channel.should respond_to(:channel_interests)
    end

    it "should have an interests method" do
      @channel.should respond_to(:interests)
    end

    it "should have an categories method" do
      @channel.should respond_to(:categories)
    end

    it "should have an locations method" do
      @channel.should respond_to(:locations)
    end

    it "should have an channel_locations method" do
      @channel.should respond_to(:channel_locations)
    end

    it "should have an host_profile method" do
      @channel.should respond_to(:host_profile)
    end

    it "should have an subscriptions method" do
      @channel.should respond_to(:subscriptions)
    end

    it "should have an users method" do
      @channel.should respond_to(:users)
    end

  context '.active' do

    it "should respond to active method" do
      Channel.should respond_to(:active)
    end

    it "should include active channels" do
      channel = Factory(:channel, :status => 'active')
      Channel.active.should_not be_empty
    end

    it "should not list of unactive channels" do
      channel = Factory(:channel, :status => 'inactive')
      Channel.active.should_not include(channel)
    end
  end

  context '.unhidden' do

    it "should respond to unhidden method" do
      Channel.should respond_to(:unhidden)
    end

    it "should include unhidden channels" do
      channel = Factory(:channel, :hide => 'no')
      Channel.unhidden.should include(channel)
    end

    it "should not list of unhidden channels" do
      channel = Factory(:channel, :hide => 'yes')
      Channel.unhidden.should_not include(channel)
    end
  end

  context '.local' do

    before(:each) do
      @channel = Factory(:channel)
    end

    it "should respond to local method" do
      Channel.should respond_to(:local)
    end

    it "should include local channels" do
      @channel_location = @channel.channel_locations.build(:location_id => '1')
      Channel.local('1').should be_empty
    end

    it "should not list non-local channels" do
      @channel_location = @channel.channel_locations.build(:location_id => '2')
      Channel.local('1').should_not include(@channel)
    end
  end

  describe 'pictures' do
    
    before(:each) do
      @sr = @newchannel.pictures.create Factory.attributes_for(:picture)
    end

    it "should have a pictures method" do
      @channel.should respond_to(:pictures)
    end

    it "has many pictures" do
      @newchannel.pictures.should include(@sr)
    end
  end

end
