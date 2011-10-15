require 'login_user_spec'

describe LifeEventsController do 
#  render_views
  include LoginTestUser

  def mock_event(stubs={})
    (@mock_event ||= mock_model(LifeEvent, stubs).as_null_object).tap do |event|
          event.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    log_in_test_user
    @event = stub_model(LifeEvent, :id=>1, :subscriptionsourceID=>"ABC123")
  end

  describe 'GET show/:id' do

    before :each do
      LifeEvent.stub!(:find).and_return( @event )
    end

    def do_get
      get :show, :id => @event
    end

    it "should load the requested event" do
      do_get
      response.should be_success
    end

    it "should load the requested event" do
      LifeEvent.stub(:find).with(@event.id).and_return(@event)
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
      LifeEvent.stub!(:new).and_return( @event )
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

      before :each do
        @event.stub!(:save).and_return(true)
      end

      it "assigns a newly created event as @event" do
        LifeEvent.stub_chain(:new, :save, :get_msg).with({'these' => 'params'}) { mock_event(:save => true) }
        post :create, :event => {'these' => 'params'}
        assigns(:event).should_not be_nil 
      end

      it "redirects to the created event" do
        LifeEvent.stub_chain(:new, :save, :get_msg) { mock_event(:save => true) }
        post :create, :event => {}
        response.should redirect_to(events_url)
      end

      it "should change event count" do
        lambda do
          post :create, :event => {} 
          should change(LifeEvent, :count).by(1)
        end
      end
    end
  end

  describe "GET 'edit/:id'" do

    before :each do
      LifeEvent.stub!(:find).and_return( @event )
    end

    def do_get
      get :edit, :id => @event
    end

    it "should load the requested event" do
      LifeEvent.stub(:find).with(@event.id).and_return(@event)
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
        LifeEvent.stub(:find).with("12") { @mock_event }
      end

      it "should load the requested event" do
        LifeEvent.stub(:find).with("12").and_return(@event)
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
        LifeEvent.stub(:find).with("12") { @mock_event }
      end

      it "should load the requested event" do
        LifeEvent.stub(:find).with("12").and_return(@event)
      end

      it "should assign @event" do
	put :update, :id => "12"
        assigns(:event).should_not be_nil 
      end

      it "renders the edit form" do 
        LifeEvent.stub(:find).with("12") { mock_event(:update_attributes => false) }
	put :update, :id => "12"
	response.should render_template(:edit)
      end
    end
  end

  describe "DELETE 'destroy'" do

    context 'success' do

      it "should load the requested event" do
        LifeEvent.stub(:find).with("37").and_return(@event)
      end

      it "destroys the requested event" do
        LifeEvent.stub(:find).with("37") { mock_event }
        mock_event.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the events list" do
        LifeEvent.stub(:find) { mock_event }
        delete :destroy, :id => "1"
        response.should redirect_to(events_url)
      end
    end

  end

  describe "GET 'clone'" do

    before :each do
      @event = stub_model(LifeEvent, :id => 1)
      LifeEvent.stub_chain(:find, :clone_event).and_return(@event)
    end

    def do_get
      get :clone, :id => @event
    end

    context "when success" do

      it "should be successful" do
        LifeEvent.stub_chain(:find, :clone_event).with(@event.id).and_return(true)
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
        LifeEvent.stub_chain(:find, :clone_event).and_return(false)
      end

      it "should not create an event" do
        lambda do
          do_get
          should_not change(LifeEvent, :count)
        end
      end
    end

  end
end

