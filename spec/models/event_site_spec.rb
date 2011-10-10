require 'spec_helper'

describe EventSite do

  before(:each) do
    @event = Factory(:event)
    @attr = { :name => 'Site 1' }
    @event_site = @event.event_sites.create(@attr)
  end

  it "should create a new instance given valid attributes" do
    @event.event_sites.create!(@attr)
  end

  describe "event associations" do

    it "should be valid" do
      @event_site.should be_valid
    end

    it "should have a event attribute" do
      @event_site.should respond_to(:event)
    end

    it "should have the right associated event" do
      @event_site.event_id.should == @event.id
      @event_site.event.should == @event
    end
  end

  describe "validations" do

    it "should reject a description without a name" do
      @event_site.name = nil
      @event_site.description = 'Grand Ballroom'
      @event_site.should_not be_valid
    end

    it "should accept a description with a name" do
      @event_site.name = 'Ballroom'
      @event_site.description = 'Grand Ballroom'
      @event_site.should be_valid
    end
  end

end
