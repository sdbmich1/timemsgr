require 'spec_helper'

describe EventsController do 
  render_views
  include Devise::TestHelpers # to give your spec access to helpers

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end

  def mock_event(stubs={})
    @mock_event ||= mock_model(Event, stubs).as_null_object
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

    before(:each) do
      @event = Event.new
    end
    
    it "should be successful" do
      controller.stub!(:new).and_return(@event)
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Add Activity")
    end

    it "should have a title field" do
      get :new
      response.should have_selector("input[name='event[title]'][type='text']")
    end 
    
    context "when cloning event" do
      
    end
  end
    
  describe "GET 'clone/:id'" do
    
    before(:each) do
       @event = Event.new
       @id = 15
       @params = {:p1 => 'clone', :p2 => @id}
    end
    
    it "should be successful" do
    
      get :clone, :id => @id
      response.should redirect_to(new_event_path(@event, @params))
    end
  end

  
  describe "GET 'show'" do
    
    before :each do
      Event.stub!(:find).and_return(@event)
      @id = 15
    end
    
    it "should load the requested event" do
#      Event.should_receive(:find).with('15').and_return(@event)
      Event.stub_chain(:find, (:to_gmaps4rails=)).with(@id).and_return(@events = [mock(Event)])

      get :show, :id => @id
      response.should be_success
    end

  end
  
  describe "GET 'index'" do
    
    it "should render index template w/ params" do
      get :index, { :numdays => 14, :p1 => "manage" }
      response.should render_template('index')
    end
       
    it "should load a list of all events" do
      Event.stub_chain(:active, :is_visible?, :current).and_return(@events = [mock(Event)])
      get :index, { :numdays => 14 }      
      response.code.should eq ("200")
    end
    
    it "should load owned events" do
      @user = [mock(User)]
      Event.stub(:owned).with(@user).and_return(@events = [mock(Event)])
      get :index, { :numdays => 14 }       
      response.code.should eq ("200")
    end
    
    it "should assign @events" do
      Event.stub_chain(:active, :is_visible?, :current) { [mock_event] }
      get :index, { :numdays => 14 } 
      assigns[:events].should eq([mock_event])  
    end
    
  end
  
  describe "GET 'edit'" do
 
     describe "success" do
         
        it "should get edit" do
       
          @event = Factory(:event)
          get :edit, :id=>@event   
          response.should be_success
        end
      end
         
  end

  describe "POST 'create'" do
    
    describe "success" do

       before(:each) do
        @attr = { :name => "Test", :event_type => "ue", :title => "Test", 
              :start_date => Date.today, :end_date => Date.today, :state => 'CA',
              :start_time => "11:00PM", :end_time => "11:30PM" }
        @params = {:event => {}, :activity_type => "Activity", :event_type => "ue",
                    :start_date => "06/05/2011", :end_date => "06/05/2011"}
        Event.stub(:update_attributes => true)  #{ @event }
       end

      it "should create an event" do
                             
        post :create, :event => {}
        response.should be_success
      end

      it "should redirect to home path" do
        Event.stub(:new) { mock_event(:save => true) }

        post :create, :event => {}
        response.should redirect_to(home_path)
      end

      it "should change event count" do
        lambda do
          @event = Factory(:event)
          
          post :create, :event => @attr
        end.should change(Event, :count)
      end    
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :event_type => "", :title => "", :start_date => "" }
        @event = Factory.stub(:event)
      end
      
      it "should not create an event" do
        lambda do
          post :create, :event => @event
        end.should_not change(Event, :count)
      end
      
      it "should render the 'new' page" do
        post :create, :event => @event
        response.should render_template('new')
      end
      
      it "should put a message in flash[:error]" do
        post :create, :event => @event
        flash[:error].should == "There was a problem!"
      end
    end
 
  end
  
  describe "PUT /:id" do
    describe "with valid params" do

    end
   
    describe "failure" do
               
        it "re-renders the 'edit' template" do
          mock_event(:update_attributes => false)
          Event.stub(:find).with("15") { @mock_event }
          put :update, :id => "15"
          response.should render_template("edit")
        end
        
    end

  end

  describe "DELETE 'destroy'" do
    
  end
end
