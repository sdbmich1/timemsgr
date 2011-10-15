require 'login_user_spec'

describe EventsController do 
#  render_views
  include LoginTestUser

  def mock_event(stubs={})
    (@mock_event ||= mock_model(Event, stubs).as_null_object).tap do |event|
          event.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    log_in_test_user
    @event = stub_model(Event, :id=>1, :subscriptionsourceID=>"ABC123")
  end

  describe 'GET index' do

    before(:each) do
      @events = mock("events")
      Event.stub!(:find_events).and_return(@events)
    end

    def do_get
      get :index, :end_date => Date.today+21.days
    end

    it "should load events" do
      do_get 
      response.code.should eq ("200")
    end

    it "should assign @events" do
      Event.should_receive(:find_events).and_return(@events)
      do_get 
      assigns(:events).should_not be_nil
    end

    it "index action should render index template" do
      do_get
      response.should render_template(:index)
    end
  end

  describe 'GET show/:id' do

    before :each do
      Event.stub!(:find_event).and_return( @event )
    end

    def do_get
      get :show, :id => @event
    end

    it "should load the requested event" do
      do_get
      response.should be_success
    end

    it "should load the requested event" do
      Event.stub(:find_event).with(@event.id).and_return(@event)
      do_get
    end

    it "should assign @event" do
      do_get
      assigns(:event).should_not be_nil
    end

    it "show action should render show template" do
      do_get
      response.should render_template(:show)
    end
  end
end  
