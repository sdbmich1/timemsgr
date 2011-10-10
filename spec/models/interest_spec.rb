require 'spec_helper'

describe Interest do

  before(:each) do
    @interest = Factory.build(:interest)
    @newinterest = Factory.create :interest
  end

  it "should be valid" do
    @interest.should be_valid
  end

    it "should have an events method" do
      @interest.should respond_to(:events)
    end

    it "should have an channel_interests method" do
      @interest.should respond_to(:channel_interests)
    end

    it "should have an channels method" do
      @interest.should respond_to(:channels)
    end

    it "should have an category method" do
      @interest.should respond_to(:category)
    end
  context '.get_active_list' do

    it "should respond to get_active_list method" do
      Interest.should respond_to(:get_active_list)
    end

    it "should include active interests" do
      interest = Factory(:interest, :status => 'active')
      Interest.get_active_list.should be_empty
    end

    it "should not list of unactive interests" do
      interest = Factory(:interest, :status => 'inactive')
      Interest.get_active_list.should_not include(interest)
    end
  end

  context '.unhidden' do

    it "should respond to unhidden method" do
      Interest.should respond_to(:unhidden)
    end

    it "should include unhidden interests" do
      interest = Factory(:interest, :hide => 'no')
      Interest.unhidden.should include(interest)
    end

    it "should not list of unhidden interests" do
      interest = Factory(:interest, :hide => 'yes')
      Interest.unhidden.should_not include(interest)
    end
  end
end
