require File.dirname(__FILE__) + '/../spec_helper'

describe SessionRelationship do
  before(:each) do
    @event = Factory(:event)
    @session = Factory(:event, :event_name => "Session Event")
    @session_relationship = @event.session_relationships.build(:session_id => @session.id)
  end

  it "should be valid" do
    @session_relationship.should be_valid
  end

  it "should create a new instance given valid attributes" do
    @session_relationship.save!
  end

  describe "relationship methods" do

    before(:each) do
      @session_relationship.save
    end

    it "should have a event attribute" do
      @session_relationship.should respond_to(:event)
    end

    it "should have the right event" do
      @session_relationship.event.should == @event
    end

    it "should have a session attribute" do
      @session_relationship.should respond_to(:session)
    end

    it "should have the right session" do
      @session_relationship.session.should == @session
    end
  end

  describe "validations" do

    it "should require a event_id" do
      @session_relationship.event_id = nil
      @session_relationship.should_not be_valid
    end

    it "should require a session_id" do
      @session_relationship.session_id = nil
      @session_relationship.should_not be_valid
    end

    it "show have unique sessions per event" do
      @new_session_relationship = @event.session_relationships.build(:session_id => @session.id)
      @session_relationship.event_id = 1
      @session_relationship.session_id = 1
      @session_relationship.save
      @new_session_relationship.event_id = 1
      @new_session_relationship.session_id = 1
      @new_session_relationship.should_not be_valid
    end
  end
end
