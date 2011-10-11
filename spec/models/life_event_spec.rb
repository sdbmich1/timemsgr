require File.dirname(__FILE__) + '/../spec_helper'

describe LifeEvent do

  before(:each) do
    @event = Factory.build(:life_event, :event_name => Factory.next(:event_name))
    @newevent = Factory.create :life_event
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

    it "should accept an event name on a unique day" do
      @next_event = Factory.build(:life_event)
      @next_event = @event
      @next_event.eventstartdate = Date.today+1.day
      @next_event.should be_valid
    end

    it "should reject same event name on a same day by same person" do
      event = Factory.build(:life_event)
      next_event = event
      next_event.should_not be_valid
    end

    it "should accept an event name on a unique time" do
      @next_event = Factory.build(:life_event)
      @next_event = @event
      @event.eventstarttime = Time.now
      @next_event.should be_valid
    end

    it "should accept an event with same name by a unique person" do
      @next_event = Factory.build(:life_event)
      @next_event = @event
      @event.contentsourceID = 'BCD345'
      @next_event.should be_valid
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
      @event.event_type = 'birthday'
      @event.should be_valid
    end

    it "should not allow an empty event type" do
      @event.event_type = nil
      @event.should_not be_valid
    end
  end

  describe "date validations" do

    context 'start date' do

      it "should reject a bad start date" do
        @event.eventstartdate = ''
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
        @event.eventenddate = @event.eventstartdate-2.days
        @event.should_not be_valid
      end

      it "should not be valid without a end date" do
        @event.eventenddate = nil
        @event.should_not be_valid
      end
    end

    context 'start time' do

      it "should reject a bad start time" do
        @event.eventstarttime = 'x'
        @event.should_not be_valid
      end

      it "should not be valid without a start time" do
        @event.eventstarttime = nil
        @event.should_not be_valid
      end
    end

    context 'end time' do

      it "should reject a bad end time" do
        @event.eventendtime = 'x'
        @event.should_not be_valid
      end

      it "should reject end time < start time" do
        @event.eventenddate = @event.eventstartdate
        @event.eventstarttime = Time.now
        @event.eventendtime = Time.now.advance(:hours => -2)
        @event.should_not be_valid
      end

      it "should not be valid without a end time" do
        @event.eventendtime = nil
        @event.should_not be_valid
      end
    end
  end

  context 'channel' do

    it "should respond to channel method" do
      @event.should respond_to(:channel)
    end
  end

  context '.active' do

    it "should respond to active method" do
      LifeEvent.should respond_to(:active)
    end

    it "should include active events" do
      event = Factory(:life_event, :event_name => Factory.next(:event_name), :status => 'active')
      LifeEvent.active.should include(event)
    end

    it "should not list of inactive events" do
      event = Factory(:life_event, :event_name => Factory.next(:event_name), :status => 'inactive')
      LifeEvent.active.should_not include(event)
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

  context '.unhidden' do

    it "should respond to unhidden method" do
      LifeEvent.should respond_to(:unhidden)
    end

    it "should include unhidden events" do
      event = Factory.build(:life_event, :event_name => Factory.next(:event_name))
      event.hide = 'no'
      LifeEvent.unhidden.should_not be_blank
    end

    it "should not list of unhidden events" do
      event = Factory.build(:life_event, :event_name => Factory.next(:event_name))
      event.hide = 'yes'
      LifeEvent.unhidden.should_not include(event)
    end
  end

  context '.set_flds' do

    it "should respond to set_flds method" do
      @event.should_receive(:set_flds) 
      @event.save!
    end

  end

  describe 'add_rewards' do

    it "should have a add_rewards method" do
      @event.should respond_to(:add_rewards)
    end

  end

  describe 'save_rewards' do

    it "should have a save_rewards method" do
      @event.should respond_to(:save_rewards)
    end

  end

end
