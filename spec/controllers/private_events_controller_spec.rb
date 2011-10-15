require 'login_user_spec'

describe PrivateEventsController do 
#  render_views
  include LoginTestUser

  def mock_event(stubs={})
    (@mock_event ||= mock_model(PrivateEvent, stubs).as_null_object).tap do |event|
          event.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    log_in_test_user
    @event = stub_model(PrivateEvent, :id=>1, :subscriptionsourceID=>"ABC123")
  end

  describe 'GET index' do

    before(:each) do
      @events = mock("events")
      PrivateEvent.stub!(:get_events).and_return(@events)
    end

    def do_get
      get :index, :end_date => Date.today+21.days
    end

    it "should load events" do
      do_get 
      response.code.should eq ("200")
    end

    it "should assign @events" do
      PrivateEvent.should_receive(:get_events).and_return(@events)
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
      PrivateEvent.stub!(:find).and_return( @event )
    end

    def do_get
      get :show, :id => @event
    end

    it "should load the requested event" do
      do_get
      response.should be_success
    end

    it "should load the requested event" do
      PrivateEvent.stub(:find).with(@event.id).and_return(@event)
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

  describe "GET 'new'" do

    before :each do
      PrivateEvent.stub!(:new).and_return( @event )
    end

    it "should assign @event" do
      get :new
      assigns[:event].should == @event
    end

    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

  end

  describe "POST create" do
    
    context 'failure' do
      
      before :each do
        @event.stub!(:save).and_return(false)
      end

      it "should assign @event" do
        post :create
        assigns(:event).should_not be_nil 
      end

      it "should render the new template" do
        post :create
        response.should render_template(:new)
      end
    end

    context 'success' do

      it "assigns a newly created event as @event" do
        PrivateEvent.stub_chain(:new, :save, :get_msg).with({'these' => 'params'}) { mock_event(:save => true) }
        post :create, :event => {'these' => 'params'}
        assigns(:event).should_not be_nil 
      end

      it "redirects to the created event" do
        PrivateEvent.stub_chain(:new, :save, :get_msg) { mock_event(:save => true) }
        post :create, :event => {}
        response.should redirect_to(events_url)
      end

      it "should change event count" do
        lambda do
          post :create, :event => {} 
          should change(PrivateEvent, :count).by(1)
        end
      end
    end
  end

  describe "GET 'edit/:id'" do

    before :each do
      PrivateEvent.stub!(:find).and_return( @event )
    end

    def do_get
      get :edit, :id => @event
    end

    it "should load the requested event" do
      PrivateEvent.stub(:find).with(@event.id).and_return(@event)
      do_get
    end

    it "should assign @event" do
      do_get
      assigns(:event).should_not be_nil 
    end

    it "should load the requested event" do
      do_get
      response.should be_success
    end
  end

  describe "PUT /:id" do

    context "with valid params" do
    
      before (:each) do
        mock_event(:update_attributes => true)
        PrivateEvent.stub(:find).with("12") { @mock_event }
      end

      it "should load the requested event" do
        PrivateEvent.stub(:find).with("12").and_return(@event)
      end

      it "updates the event" do
	put :update, :id => "12"
      end

      it "should assign @event" do
	put :update, :id => "12"
        assigns(:event).should_not be_nil 
      end

      it "redirects to events" do
	put :update, :id => "12"
	response.should redirect_to(events_url)
      end
    end

    context "with invalid params" do
    
      before (:each) do
        mock_event(:update_attributes => false)
        PrivateEvent.stub(:find).with("12") { @mock_event }
      end

      it "should load the requested event" do
        PrivateEvent.stub(:find).with("12").and_return(@event)
      end

      it "should assign @event" do
	put :update, :id => "12"
        assigns(:event).should_not be_nil 
      end

      it "renders the edit form" do 
        PrivateEvent.stub(:find).with("12") { mock_event(:update_attributes => false) }
	put :update, :id => "12"
	response.should render_template(:edit)
      end
    end
  end

  describe "DELETE 'destroy'" do

    context 'success' do

      it "should load the requested event" do
        PrivateEvent.stub(:find).with("37").and_return(@event)
      end

      it "destroys the requested event" do
        PrivateEvent.stub(:find).with("37") { mock_event }
        mock_event.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the events list" do
        PrivateEvent.stub(:find) { mock_event }
        delete :destroy, :id => "1"
        response.should redirect_to(events_url)
      end
    end

  end

  describe "GET 'clone'" do

    before :each do
      @event = stub_model(PrivateEvent, :id => 1)
      PrivateEvent.stub_chain(:find, :clone_event).and_return(@event)
    end

    def do_get
      get :clone, :id => @event
    end

    context "when success" do

      it "should be successful" do
        PrivateEvent.stub_chain(:find, :clone_event).with(@event.id).and_return(true)
        do_get
      end    

      it "should assign @event" do
        do_get
        assigns[:event].should == @event
      end

      it "should render clone template" do
        do_get
        response.should render_template('clone')
      end  

    end

    context "when unsuccessful" do
      before :each do
        PrivateEvent.stub_chain(:find, :clone_event).and_return(false)
      end

      it "should not create an event" do
        lambda do
          do_get
          should_not change(PrivateEvent, :count)
        end
      end
    end

  end

  describe "POST 'move'" do

    before :each do
      @event = stub_model(PrivateEvent, :id => 1)
      PrivateEvent.stub(:move_event).and_return(@event)
    end

    def do_post
      post :move, :id => @event
    end

    context "when success" do

      before :each do
        @event.stub!(:save).and_return(true)
      end

      it "should be successful" do
        PrivateEvent.stub(:move_event).with(@event.id).and_return(true)
        do_post
      end    

      it "should assign @event" do
        do_post
        assigns[:event].should == @event
      end

      it "redirects to events" do
        do_post
	response.should redirect_to(events_url)
      end
    end

    context "when unsuccessful" do
      before :each do
        @event.stub!(:save).and_return(false)
        @request.env['HTTP_REFERER'] = "http://referer/"
      end

      it "should assign @event" do
        do_post
        assigns(:event).should_not be_nil 
      end

      it "should redirect" do
        do_post
        response.should be_redirect
      end

      it "should not create an event" do
        lambda do
          do_post
          should_not change(PrivateEvent, :count)
        end
      end
    end
  end

end  
