require File.dirname(__FILE__) + '/../spec_helper'

describe HostProfile do

  before(:each) do
    @host_profile = Factory.build(:host_profile)
    @newhost_profile = Factory.create :host_profile
  end

  it "should be valid" do
    @host_profile.should be_valid
  end

    it "should have an user method" do
      @host_profile.should respond_to(:user)
    end

    it "should have an channels method" do
      @host_profile.should respond_to(:channels)
    end

    it "should have an events method" do
      @host_profile.should respond_to(:events)
    end

    it "should have an subscriptions method" do
      @host_profile.should respond_to(:subscriptions)
    end

    it "should have an pictures method" do
      @host_profile.should respond_to(:pictures)
    end
end
