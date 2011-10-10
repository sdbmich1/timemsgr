require File.dirname(__FILE__) + '/../spec_helper'

describe Event do

  before(:each) do
    @event = Factory.build(:event)
    @newevent = Factory.create :event
  end

  it "should be valid" do
    @event.should be_valid
  end

  describe "name validations" do

    it "should have an event name" do
      @event.event_name = 'Test'
      @event.should be_valid
    end

    it "should not be valid without event name" do
      @event.event_name = nil
      @event.should_not be_valid
    end

    it "should reject names that are too long" do
      @event.event_name = "a" * 101
      @event.should_not be_valid
    end
  end

  describe "bbody validations" do
    it "should reject summaries that are too long" do
      @event.bbody = "a" * 256
      @event.should_not be_valid
    end

    it "should accept summaries that are of correct length" do
      @event.bbody = "a" * 200
      @event.should be_valid
    end
  end

  describe "event type validations" do
    it "should have an event type" do
      @event.event_type = 'mtg'
      @event.should be_valid
    end

    it "should not allow an empty event type" do
      @event.event_type = nil
      @event.should_not be_valid
    end
  end

  describe "location validations" do
    it "should have a session location if a non-break session" do
      @event.event_type = 'es'
      @event.session_type = 'panel'
      @event.location = 'Room 1'
      @event.should be_valid
    end

    it "should allow empty location if a break " do
      @event.event_type = 'es'
      @event.session_type = 'brk'
      @event.location = nil
      @event.should be_valid
    end

    it "should reject empty location if a non-break " do
      @event.event_type = 'es'
      @event.session_type = 'panel'
      @event.location = nil
      @event.should_not be_valid
    end

    it "should allow empty location for non-sessions" do
      @event.event_type = 'mtg'
      @event.location = nil
      @event.should be_valid
    end

    it "should not allow empty session location" do
      @event.event_type = 'es'
      @event.location = nil
      @event.should_not be_valid
    end
  end

  describe "date validations" do

    context 'start date' do

      it "should reject a bad start date" do
        @event.eventstartdate = Date.today-2.days
        @event.should_not be_valid
      end

      it "should not be valid without a start date" do
        @event.eventstartdate = nil
        @event.should_not be_valid
      end
    end

    context 'end date' do

      it "should reject a bad end date" do
        @event.eventenddate = ''
        @event.should_not be_valid
      end

      it "should reject end date < start date" do
        @event.eventenddate = Date.today-2.days
        @event.should_not be_valid
      end

      it "should not be valid without a end date" do
        @event.eventenddate = nil
        @event.should_not be_valid
      end
    end

    context 'start time' do

      it "should reject a bad start time" do
        @event.eventstarttime = ''
        @event.should_not be_valid
      end

      it "should not be valid without a start time" do
        @event.eventstarttime = nil
        @event.should_not be_valid
      end
    end

    context 'end time' do

      it "should reject a bad end time" do
        @event.eventendtime = ''
        @event.should_not be_valid
      end

      it "should reject end time < start time" do
        @event.eventenddate = @event.eventstartdate
        @event.eventendtime = Time.now.advance(:hours => -2)
        @event.should_not be_valid
      end

      it "should not be valid without a end time" do
        @event.eventendtime = nil
        @event.should_not be_valid
      end
    end
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

  context '.active' do

    it "should respond to active method" do
      Event.should respond_to(:active)
    end

    it "should include active events" do
      event = Factory(:event, :status => 'active')
      Event.active.should include(event)
    end

    it "should not list of unactive events" do
      event = Factory(:event, :status => 'inactive')
      Event.active.should_not include(event)
    end
  end

  context '.is_session?' do

    it "should respond to is_session? method" do
      @event.should respond_to(:is_session?)
    end

    it "should include session events" do
      event = Factory(:event, :event_type => 'es', :session_type => 'key', :location => 'here')
      event.is_session?.should be_true
    end

    it "should reject non session events" do
      event = Factory(:event, :event_type => 'mtg')
      event.is_session?.should be_false 
    end
  end

  context '.is_clone?' do

    it "should respond to is_clone? method" do
      @event.should respond_to(:is_clone?)
    end

    it "should include clone events" do
      @event.etype = 'Clone'
      @event.is_clone?.should be_true
    end

    it "should reject non clone events" do
      @event.etype = 'Session'
      @event.is_clone?.should be_false 
    end
  end

  context '.same_day?' do

    it "should respond to same_day? method" do
      @event.should respond_to(:same_day?)
    end

    it "should be the same day" do
      @event.eventstartdate = Date.today
      @event.eventenddate = Date.today
      @event.same_day?.should be_true
    end

    it "should not be the same day" do
      @event.eventstartdate = Date.today
      @event.eventenddate = Date.today+1.day
      @event.same_day?.should be_false 
    end
  end

  context '.is_break?' do

    it "should respond to is_break? method" do
      @event.should respond_to(:is_break?)
    end

    it "should reject session events" do
      (%w(wkshp cls mtg key brkout panel)).each do |session_type|
        event = Factory(:event, :event_type => 'se', :session_type => session_type, :location => 'here')
	event.is_break?.should be_false
      end
    end

    it "should include session breaks" do
      (%w(brk meal)).each do |session_type|
        event = Factory(:event, :event_type => 'se', :session_type => session_type, :location => 'here')
	event.is_break?.should be_true
      end
    end
  end

  context '.unhidden' do

    it "should respond to unhidden method" do
      Event.should respond_to(:unhidden)
    end

    it "should include unhidden events" do
      event = Factory(:event, :hide => 'no')
      Event.unhidden.should include(event)
    end

    it "should not list of unhidden events" do
      event = Factory(:event, :hide => 'yes')
      Event.unhidden.should_not include(event)
    end
  end

  context '.get_events' do

    it "should respond to get_events method" do
      Event.should respond_to(:get_events)
    end

    it "should include conference events" do
      event = Factory(:event, :event_type => 'conf')
      Event.get_events(event.id).should_not be_nil
    end

    it "should not list of non conference events" do
      event = Factory(:event, :event_type => 'ue')
      Event.get_events("23").should_not include(event)
    end
  end

  context '.set_flds' do

    it "should respond to set_flds method" do
      @event.should_receive(:set_flds) 
      @event.save!
    end

    it "should reset data for cloned event" do
      event = Factory(:event, :etype => 'Clone')
      @event.should respond_to(:reset_session_data) 
    end

    it "should not reset data for event" do
      event = Factory(:event, :etype => 'Event')
      Event.should_not respond_to(:reset_session_data) 
    end
  end

  describe '.clone_event' do
    before(:each) do
      @pix = @newevent.pictures.create Factory.attributes_for(:picture)
      @trx = @newevent.event_tracks.create Factory.attributes_for(:event_track)
      @sx = @newevent.event_sites.create Factory.attributes_for(:event_site)
      @px = @newevent.event_presenters.create Factory.attributes_for(:event_presenter)
      @ssx = @newevent.session_relationships.create Factory.attributes_for(:session_relationship)
      @ps = @newevent.presenters.create Factory.attributes_for(:presenter)
      @ss = @newevent.sessions.create Factory.attributes_for(:event)
      @clone = @newevent.clone
    end

    it "should respond to clone_event method" do
      @event.should respond_to(:clone_event)
    end

    it "should clone event" do
      @clone.should be_valid
    end

    context '.pictures' do
      before(:each) do
        @clone.pictures = @newevent.pictures
      end

      it "should have a pictures method" do
        @clone.should respond_to(:pictures)
      end

      it "has many pictures" do
        @clone.pictures.should include(@pix)
      end
    end

    context '.event_tracks' do
      before(:each) do
        @clone.event_tracks = @newevent.event_tracks
      end

      it "should have a event_tracks method" do
        @clone.should respond_to(:event_tracks)
      end

      it "has many event_tracks" do
        @clone.event_tracks.should include(@trx)
      end
    end

    context '.event_sites' do
      before(:each) do
        @clone.event_sites = @newevent.event_sites
      end

      it "should have a event_sites method" do
        @clone.should respond_to(:event_sites)
      end

      it "has many event_sites" do
        @clone.event_sites.should include(@sx)
      end
    end

    context '.event_presenters' do
      before(:each) do
        @clone.event_presenters = @newevent.event_presenters
      end

      it "should have a event_presenters method" do
        @clone.should respond_to(:event_presenters)
      end

      it "has many event_presenters" do
        @clone.event_presenters.should include(@px)
      end
    end

    context '.session_relationships' do
      before(:each) do
        @clone.session_relationships = @newevent.session_relationships
      end

      it "should have a session_relationships method" do
        @clone.should respond_to(:session_relationships)
      end

      it "has many session_relationships" do
        @clone.session_relationships.should include(@ssx)
      end
    end

    context '.sessions' do
      before(:each) do
        @clone.sessions = @newevent.sessions
      end

      it "should have a sessions method" do
        @clone.should respond_to(:sessions)
      end

      it "has many sessions" do
        @clone.sessions.should include(@ss)
      end
    end

    context '.presenters' do
      before(:each) do
        @clone.presenters = @newevent.presenters
      end

      it "should have a presenters method" do
        @clone.should respond_to(:presenters)
      end

      it "has many presenters" do
        @clone.presenters.should include(@ps)
      end
    end

  end
end
