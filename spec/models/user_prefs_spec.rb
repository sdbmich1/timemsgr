require 'spec_helper'

describe UserPrefs do
 render_views
 	
 before(:each) do
    @user = Factory(:user)
    @attr = { :pref => "Sports" }
  end

  it "should create a new instance given valid attributes" do
    @user.userprefs.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @userpref = @user.userprefs.create(@attr)
    end

    it "should have a user attribute" do
      @userpref.should respond_to(:user)
    end

    it "should have the right associated user" do
      @userpref.user_id.should == @user.id
      @userpref.user.should == @user
    end
  end
end
