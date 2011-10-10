require File.dirname(__FILE__) + '/../spec_helper'

describe Event do

  before(:each) do
    @event = Factory.build(:event)
    @newevent = Factory.create :event
  end

  it "should be valid" do
    @event.should be_valid
  end

  describe 'session relationships' do
    
    before(:each) do
      @sr = @newevent.session_relationships.create Factory.attributes_for(:session_relationship)
    end

    it "should have a session_relationships method" do
      @event.should respond_to(:session_relationships)
    end

    it "has many session_relationships" do
      @newevent.session_relationships.should include(@sr)
    end

    it "should destroy associated session relationships" do
      @newevent.destroy
      [@sr].each do |s|
        SessionRelationship.find_by_id(s.id).should be_nil
      end
    end
  end

  describe 'channel' do

    it "should have a channel method" do
      @event.should respond_to(:channel)
    end

  end

  describe 'event_presenters' do

    before(:each) do
      @sr = @newevent.event_presenters.create Factory.attributes_for(:event_presenter)
    end

    it "should have a event_presenters method" do
      @event.should respond_to(:event_presenters)
    end

    it "has many event_presenters" do
      @newevent.event_presenters.should include(@sr)
    end

    it "should destroy associated event_presenters" do
      @newevent.destroy
      [@sr].each do |s|
        EventPresenter.find_by_event_id(s.id).should be_nil
      end
    end
  end

  describe 'event_tracks' do
    
    before(:each) do
      @sr = @newevent.event_tracks.create Factory.attributes_for(:event_track)
    end

    it "should have a event_tracks method" do
      @event.should respond_to(:event_tracks)
    end

    it "has many tracks" do
      @newevent.event_tracks.should include(@sr)
    end

    it "should destroy associated event tracks" do
      @newevent.destroy
      [@sr].each do |s|
        EventTrack.find_by_id(s.id).should be_nil
      end
    end
  end

  describe 'event_sites' do
    
    before(:each) do
      @sr = @newevent.event_sites.create Factory.attributes_for(:event_site)
    end

    it "should have a event_sites method" do
      @event.should respond_to(:event_sites)
    end

    it "has many sites" do
      @newevent.event_sites.should include(@sr)
    end

    it "should destroy associated event sites" do
      @newevent.destroy
      [@sr].each do |s|
        EventSite.find_by_id(s.id).should be_nil
      end
    end
  end

  describe 'pictures' do
    
    before(:each) do
      @sr = @newevent.pictures.create Factory.attributes_for(:picture)
    end

    it "should have a pictures method" do
      @event.should respond_to(:pictures)
    end

    it "has many pictures" do
      @newevent.pictures.should include(@sr)
    end

    it "should destroy associated pictures" do
      @newevent.destroy
      [@sr].each do |s|
        Picture.find_by_id(s.id).should be_nil
      end
    end
  end

  context '.get_event' do

    it "should respond to get_event method" do
      Event.should respond_to(:get_event)
    end

    it "should include correct event" do
      event = Factory(:event, :event_type => 'conf')
      Event.get_event(event.id).should_not be_empty
    end

    it "should reject events with incorrect ID " do
      event = Factory(:event, :event_type => 'ue')
      Event.get_event("23").should_not include(event)
    end
  end

  context '.find_event' do

    it "should respond to find_event method" do
      Event.should respond_to(:find_event)
    end

    it "should include correct event" do
      event = Factory(:event, :event_type => 'conf')
      Event.find_event(event.id).should be_valid
    end

    it "should reject events with incorrect ID " do
      Event.find_event('0').should be_nil
    end
  end

  context '.find_events' do
   
    it "should respond to find_events method" do
      Event.should respond_to(:find_events)
    end

    it "should include correct end date and host profile" do
      @event.save
      edate = Date.today+14.days
      hprofile = Factory(:host_profile, :subscriptionsourceID => "123")
      Event.find_events(edate, hprofile).should_not be_empty
    end

  end

  context '.current' do
   
    it "should respond to current method" do
      Event.should respond_to(:current)
    end

    it "should include correct end date and host profile" do
      @event.save
      edate = Date.today+14.days
      hprofile = Factory(:host_profile, :subscriptionsourceID => "123")
      Event.current(edate, hprofile).should_not be_empty
    end

    it "should reject incorrect end date" do
      @event.save
      edate = nil
      hprofile = Factory(:host_profile, :subscriptionsourceID => "123")
      Event.current(edate, hprofile).should_not include(@event)
    end
  end

  context '.current_events' do
   
    it "should respond to current_events method" do
      Event.should respond_to(:current_events)
    end

    it "should include correct end date and host profile" do
      @event.save
      edate = Date.today+14.days
      Event.current_events(edate).should include(@event)
    end

    it "should reject incorrect end date" do
      @event.save
      edate = nil
      Event.current_events(edate).should_not include(@event)
    end
  end

  describe 'getSQL' do

    it "should have a getSQL method" do
      Event.should respond_to(:getSQL)
    end

  end

  describe 'getSQLe' do

    it "should have a getSQLe method" do
      Event.should respond_to(:getSQLe)
    end

  end

  describe 'where_subscriber_id' do

    it "should have a where_subscriber_id method" do
      Event.should respond_to(:where_subscriber_id)
    end

  end

  describe 'where_dte' do

    it "should have a where_dte method" do
      Event.should respond_to(:where_dte)
    end

  end

  describe 'where_dt' do

    it "should have a where_dt method" do
      Event.should respond_to(:where_dt)
    end

  end

  describe 'get_event_details' do

    it "should have a get_event_details method" do
      Event.should respond_to(:get_event_details)
    end

  end
end
