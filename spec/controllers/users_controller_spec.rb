require 'spec_helper'

describe UsersController do
  render_views
  
  include Devise::TestHelpers

  before(:each) do
    @user = Factory.create(:user)
    sign_in @user
  end

  def mock_user(stubs={})
        @mock_user ||= mock_model(User, stubs).as_null_object
  end

  def log_in_test_user
    attr = { :username => "Foobar", :email => "test@foobar.com" }

  	before(:each) do
        # mock up an authentication in the underlying warden library
        request.env['warden'] = mock(Warden, :authenticate => mock_user,
                                             :authenticate! => mock_user)
  	end
  end
   
  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
  
  describe "layout" do
     it "should use user layout" do
      controller.should_receive(:render).with(:layout => "/layouts/user")
      controller.should_receive(:render).with(:no_args)
      get 'index'
    end   
  end

end
