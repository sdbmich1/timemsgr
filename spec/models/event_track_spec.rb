require 'spec_helper'

describe EventTrack do

  before(:each) do
    @event = Factory(:event)
    @attr = { :name => 'Track 1', :description => "value for content" }
    @event_track = @event.event_tracks.create(@attr)
  end

  it "should create a new instance given valid attributes" do
    @event.event_tracks.create!(@attr)
  end

  describe "event associations" do

    it "should be valid" do
      @event_track.should be_valid
    end

    it "should have a event attribute" do
      @event_track.should respond_to(:event)
    end

    it "should have the right associated event" do
      @event_track.event_id.should == @event.id
      @event_track.event.should == @event
    end
  end

  describe "validations" do

    it "should require a name" do
      @event_track.name = nil
      @event_track.should_not be_valid
    end
  end

  describe 'get_track' do

    it "should respond to an get_track method" do
      EventTrack.should respond_to(:get_track)
    end
  end
end
