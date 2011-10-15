require 'login_user_spec'

describe MajorEventsController do 
#  render_views
  include LoginTestUser

  def mock_event(stubs={})
    (@mock_event ||= mock_model(Event, stubs).as_null_object).tap do |event|
          event.stub(stubs) unless stubs.empty?
    end
  end

  def mock_presenter(stubs={})
    (@mock_presenter ||= mock_model(Presenter, stubs).as_null_object).tap do |presenter|
       presenter.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    log_in_test_user
    @event = stub_model(Event, :id=>1, :subscriptionsourceID=>"ABC123")
    @presenters = mock("presenters")
    @event.stub!(:presenters).and_return(@presenters)
  end

  describe 'GET show/:id' do

    before :each do
      Event.stub!(:find).and_return( @event )
    end

    def do_get
      get :show, :id => @event
    end

    it "should load the requested event" do
      do_get
      response.should be_success
    end

    it "should load the requested event" do
      Event.stub(:find).with(@event.id).and_return(@event)
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

  describe 'GET about/:id' do

    before :each do
      Event.stub!(:find).and_return( @event )
    end

    def do_get
      get :about, :id => @event
    end

    it "should load the requested event" do
      do_get
      response.should be_success
    end

    it "should load the requested event" do
      Event.stub(:find).with(@event.id).and_return(@event)
      do_get
    end

    it "should assign @event" do
      do_get
      assigns(:event).should_not be_nil
    end

    it "about action should render about template" do
      do_get
      response.should render_template(:about)
    end
  end
end  
