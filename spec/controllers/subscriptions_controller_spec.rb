require 'login_user_spec'

describe SubscriptionsController do 
#  render_views
  include LoginTestUser

  def mock_subscription(stubs={})
    (@mock_subscription ||= mock_model(Subscription, stubs).as_null_object).tap do |subscription|
          subscription.stub(stubs) unless stubs.empty?
    end
  end

  def mock_user(stubs={})
    (@mock_user ||= mock_model(User, stubs).as_null_object).tap do |user|
          user.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    log_in_test_user
    @subscription = stub_model(Subscription, :id=>1, :subscriptionsourceID=>"ABC123")
    @user = stub_model(User, :id=>1)
  end

  describe "GET 'edit/:id'" do

    before :each do
      @subscriptions = mock("subscriptions")
      Subscription.stub!(:get_active_list).and_return( @subscriptions )
    end

    def do_get
      get :edit, :id => @user
    end

    it "should load the requested subscriptions" do
      Subscription.stub(:get_active_list).with(@user.id).and_return(@subscriptions)
      do_get
    end

    it "should assign @subscription" do
      do_get
      assigns(:subscriptions).should_not be_nil 
    end

    it "should load the requested subscription" do
      do_get
      response.should be_success
    end
  end

  describe "PUT /:id" do

    context "with valid params" do
    
      before (:each) do
        mock_user(:update_attributes => true)
        User.stub(:find).with("1") { @mock_user }
      end

      def do_put
        put :update, :id => '1'
      end

      it "should load the requested user" do
        User.stub(:find).with("1").and_return(@user)
      end

      it "updates the user" do
	do_put
      end

      it "should assign @user" do
	do_put
        assigns(:user).should_not be_nil 
      end

      it "redirects to subscriptions" do
	do_put
	response.should redirect_to(home_url)
      end
    end

    context "with invalid params" do
    
      before (:each) do
        mock_user(:update_attributes => false)
        User.stub(:find).with("12") { @mock_user }
      end

      def do_put
        put :update, :id => '12'
      end

      it "should load the requested subscription" do
        User.stub(:find).with("12").and_return(@user)
      end

      it "should assign @user" do
	do_put
        assigns(:user).should_not be_nil 
      end

      it "renders the edit form" do 
        User.stub(:find).with("12") { mock_user(:update_attributes => false) }
	do_put
	response.should render_template(:edit)
      end
    end
  end

  describe "POST 'add'" do

    before :each do
      @subscription = stub_model(Subscription)
      @channel = stub_model(Channel)
      @user = stub_model(User, :id => 1)
      Channel.stub(:find).and_return(@channel)
      User.stub(:find).and_return(@user)
    end

    def do_post
      post :add, :user_id => '1', :channel_id => '12'
    end

    context "when success" do

      before :each do
        @subscription.stub!(:save).and_return(true)
      end

      it "should be successful" do
        Subscription.stub_chain(:new, :save, :get_msg).with('1','12') { mock_subscription(:save => true) }
        do_post
        assigns[:subscription].should_not be_nil
      end    

      it "redirects to channel" do
        do_post
	response.should redirect_to(channel_url(@channel))
      end

      it "should change subscription count" do
        lambda do
          do_post
          should change(Subscription, :count).by(1)
        end
      end
    end

    context "when unsuccessful" do
      before :each do
        @subscription.stub!(:save).and_return(false)
      end

      it "should assign @subscription" do
        do_post
        assigns(:subscription).should_not be_nil 
      end

      it "should redirect" do
        do_post
	response.should redirect_to(channel_url(@channel))
      end

      it "should not create an subscription" do
        lambda do
          do_post
          should_not change(Subscription, :count)
        end
      end
    end
  end
end
