require 'spec_helper'

describe EventsController do 
  render_views
  include Devise::TestHelpers # to give your spec access to helpers

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end

  def mock_event(stubs={})
    (@mock_event ||= mock_model(Event, stubs).as_null_object).tap do |event|
          event.stub(stubs) unless stubs.empty?
    end
  end

  def log_in_test_user
    attr = { :username => "Foobar", :email => "doineedit@foobar.com" }
    #mock up an authentication in warden as per http://www.michaelharrison.ws/weblog/?p=349
    request.env['warden'] = mock(Warden, :authenticate => mock_user(attr),
                                         :authenticate! => mock_user(attr),
                                         :authenticate? => mock_user(attr))
  end
     
  before(:each) do
    log_in_test_user
  end

  describe "GET 'new'" do
    
    before :each do
      EventType.stub!(:all).and_return(@options)
      @event = stub_model(Event, :id=>1, :title=>"test")
      Event.stub!(:new).and_return( @event )
    end

    context "when creating new event" do
       
      it "should create a new event" do
        Event.should_receive(:new).and_return(@event)
        get :new
      end

      it "should assign @event" do
        get :new
        assigns[:event].should == @event
      end
  
      it "should render the new template" do
        get :new
        response.should render_template(:new)
      end
    
      it "should load vars" do
        get :new
        assigns[:form].should == "add_event"
      end   
    end
    
    context "when cloning event" do

      it "should be successful" do
        Event.stub_chain(:find, :clone).and_return(@event)
        get :new
     end      
    end
  end
    
  describe "GET 'clone'" do
    
    before(:each) do
       @event = Event.new
       @id = 15
       @params = {:p1 => 'clone', :p2 => @id}
    end
    
    it "should redirect to new event" do   
      get :clone, :id => @id
      response.should redirect_to(new_event_path(@event, @params))
    end
  end
  
  describe "GET 'get_drop_down_options'" do

    before :each do
      params = { :radio_val => "Activity" }
    end
    
    it "assign radio val" do   
      assigns[:radio_val].should == 'Activity'
    end
    
    it "should render typelist" do 
      get :get_drop_down_options, :params => {}
      controller.should_receive(:render).with(hash_including(:partial => "typelist"))  
    end
    
  end

  
  describe "GET 'manage'" do
    
    before :each do
      @user = [mock(User)]
      @event = mock(Event)
 #     @event = stub_model(Event, :id=>1, :title=>"test")
      @event.stub!(:owned).with(@user).and_return(@event)
    end
 
    it "should render manage template" do
      get :manage
      response.should render_template('manage')
    end
           
    it "should load a list of all owned events" do
      get :manage
    end

    it "should load owned events" do
      get :manage     
      response.code.should eq ("200")
    end    
    
    it "should assign @events" do
      Event.stub!(:owned).and_return( @events )
      get :manage 
      assigns[:events].should == @events
    end
    
    it "should assign the show form for view" do
      get :manage
      assigns[:form].should == "event_list"
    end
  end

  
  describe "GET 'show'" do
    
    before :each do
      Event.stub!(:find).and_return( @event = mock_event )
    end
    
    def do_get
      get :show, :id => @event.id
    end
    
    it "should load the requested event" do
      do_get
      response.should be_success
    end
    
    it "retrieve the google map" do
      Event.stub!(:to_gmaps4rails).and_return(true)
      do_get
      response.should be_success
    end 
    
    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should assign @event" do
      Event.stub!(:find).and_return(@event)
      do_get
      assigns(:event).should == @event
    end
    
    it "should assign @json" do
      @event.stub!(:to_gmaps4rails).and_return(@json)
      do_get
      assigns(:json).should == @json
    end 
   
    it "should assign the form type for view" do
      do_get
      assigns[:form].should == "show_event"
    end    
  end
  
  describe "GET 'index'" do

    before :each do
      @params = { :end_date => "12/05/2011" }
      @event = mock(Event)
      @event.stub_chain(:active, :is_visible?, :upcoming).and_return(true)
    end
          
    it "should load a list of all events" do
      get :index     
      response.code.should eq ("200")
    end

    it "should assign @events" do
      @event = []
      get :index 
      assigns[:events].should == @event
    end
    
    it "should assign the form for index view" do
      get :index
      assigns[:form].should == "event_slider"
    end
    
    it "should change list of events using Ajax" do
      xhr :get, :index, :end_date => @params[:end_date]
      response.should be_success
    end
    
    it "should render show template" do
      get :index
      response.should render_template('index')
    end
  end
  
  describe "GET 'edit'" do
 
    before :each do
      @event = stub_model(Event, :id=>1, :title=>"test")
      Event.stub!(:find).and_return( @event )
    end
    
    def do_get
      get :edit, :id => @event.id
    end
  
    it "should load the requested event" do
      Event.should_receive(:find).with(@event.id).and_return(@event)
      do_get
    end

    it "should assign @event" do
      do_get
      assigns[:event].should == @event
    end
          
    it "should get edit" do     
      do_get  
      response.should be_success
    end
        
    it "should render the edit template" do
      do_get
      response.should render_template(:edit)
    end        
  end

  describe "POST 'create'" do
    
    before :each do
      @event = stub_model(Event, :id=>1, :title=>"test")
      Event.stub!(:new).and_return(@event)
    end
    
    context "success" do

      before(:each) do
        @event.stub!(:save).and_return(true)
      end

      it "should create event and redirect to home path" do
        post :create, :event => {}
        response.should redirect_to(home_url)
      end

      it "should change event count" do
        lambda do
          post :create, :event => {} 
          should change(Event, :count).by(1)
        end
      end  
      
      it "should put a message in flash[:notice]" do
        post :create, :event => {} 
        flash[:notice].should =~ /created event/i
      end  
    end
    
    context "failure" do
      
      before :each do
        @event.stub!(:save).and_return(false)
      end
      
      it "should not create an event" do
        lambda do
          post :create, :event => @event
          should_not change(Event, :count)
        end
      end
      
      it "should render the 'new' page" do
        post :create
        response.should redirect_to(home_url) #render_template('new')
      end
      
      it "should assign form" do
        post :create, :event => {}
        assigns[:form] == "new_event"
      end
    end
 
  end
  
  describe "PUT /:id" do

    def do_put
       put :update, :id => @event.id, :params => {:event => @event}
    end

    context "with valid params" do
    
      before :each do
        Event.stub!(:find).and_return(@event = stub_model(Event, :id=>1, :title=>"test") )
        @event.stub! :update_attributes => true
      end
    
      it "should load the requested event" do
        Event.should_receive(:find).with(@event.id).and_return(@event)
        do_put
      end
           
      it "should update the event object's attributes" do
        do_put
        assigns[:event].should == @event 
      end
    
      it "should put a message in flash[:notice]" do
        put :update, :id => @event.id, :params => {} #do_put
        flash[:notice].should =~ /updated event/i
      end
    
      it "should redirect to the index action" do
        do_put
        response.should redirect_to(home_url)
      end
    end
   
    context "with invalid params" do
                     
      before :each do
        Event.stub!(:find).and_return(@event = stub_model(Event, :id=>1, :title=>"test") )
        @event.stub! :update_attribute => false
      end
      
      it "updates the requested event" do
        params = {}
        @event.should_receive(:update_attributes).with(params)
        put :update, :id => "37", :params => {}
      end

      it "should assign @event" do
        put :update, :id => @event.id
        assigns[:event].should == @event
      end
           
      it "should render the edit template" do
        put :update, :id => @event.id, :params => {:these => 'params'} #do_put
        response.should render_template(:edit)
      end      
    end

  end

  describe "DELETE 'destroy'" do
    
    before :each do
      Event.stub!(:find).and_return(@event = mock_event, 
            :errors => { :anything => "Delete failed." })
    end
    
    def do_delete
      delete :destroy, :id => @event.id
    end

    context "when successful" do
      before :each do
        @event.stub!(:destroy).and_return(true)
      end   
      
      it "should destroy an event using Ajax" do
        lambda do
          xhr :delete, :destroy, :id => @event.id
          response.should be_success
          should change(Event, :count).by(-1)
        end
      end
    
      it "destroys the requested event" do
        @event.should_receive(:destroy)
        do_delete 
      end
 
      it "redirects to the manage events list" do
        do_delete 
        response.should redirect_to(manage_events_url)
      end
      
      it "should put a message in flash[:notice]" do
        do_delete
        flash[:notice].should =~ /deleted event/i
      end
    end
    
    context "when unsuccessful" do
      before :each do
        @event.stub!(:destroy).and_return(false)
      end
    
      it "should assign @event" do
        do_delete
        assigns[:event].should == @event
      end
        
      it "should redirect to the managed event" do
        do_delete
        response.should redirect_to(manage_events_url)
      end      
    end
  end
end
