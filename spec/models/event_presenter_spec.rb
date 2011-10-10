require File.dirname(__FILE__) + '/../spec_helper'

describe EventPresenter do
  before(:each) do
    @event = Factory(:event)
#    @presenter = Factory(:presenter)
    @event_presenter = @event.event_presenters.build(:presenter_id => 1)
  end

  it "should be valid" do
    @event_presenter.should be_valid
  end

  it "should create a new instance given valid attributes" do
    @event_presenter.save!
  end

  describe "relationship methods" do

    before(:each) do
      @event_presenter.save
    end

    it "should have a event attribute" do
      @event_presenter.should respond_to(:event)
    end

    it "should have the right event" do
      @event_presenter.event.should == @event
    end

    it "should have a presenter attribute" do
      @event_presenter.should respond_to(:presenter)
    end

    it "should have the right presenter" do
      @event_presenter.presenter.should == @presenter
    end
  end

  describe "validations" do

    it "should require a event_id" do
      @event_presenter.event_id = nil
      @event_presenter.should_not be_valid
    end

    it "should require a presenter_id" do
      @event_presenter.presenter_id = nil
      @event_presenter.should_not be_valid
    end

    context "unique presenters per event" do

      before(:each) do
        @event_presenter.save
      end

      it "should reject duplicate event presenter" do
        @next_event_presenter = @event.event_presenters.build(:presenter_id => 1)
	@next_event_presenter.should_not be_valid
      end

      it "should accept unique event presenter" do
        @new_event = Factory(:event, :event_name => Factory.next(:event_name))
        @next_event_presenter = @new_event.event_presenters.build(:presenter_id => 2)
	@next_event_presenter.should be_valid
      end

      it "should reject duplicate presenters for the same event" do
        @new_event_presenter = @event.event_presenters.build(:presenter_id => 1)
        @event_presenter.event_id = 1
        @event_presenter.presenter_id = 1
        @event_presenter.save
        @new_event_presenter.event_id = 1
        @new_event_presenter.presenter_id = 1
	@new_event_presenter.should_not be_valid
      end
    end
  end
end
