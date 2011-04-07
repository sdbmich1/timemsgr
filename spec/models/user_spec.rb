require 'spec_helper'

describe User do
  render_views
	
  before(:each) do
    @attr = { :first_name => "Example", :last_name => "User", :email => "user@example.com",
    	 :gender => 'Male', :birth_date => '1980-11-11'}
  end
 
  it "should require a first name" do
    no_first_name_user = User.new(@attr.merge(:first_name => ""))
    no_first_name_user.should_not be_valid
  end
  
  it "should require a last name" do
    no_last_name_user = User.new(@attr.merge(:last_name => ""))
    no_last_name_user.should_not be_valid
  end
  
  it "should require a gender" do
    no_gender_user = User.new(@attr.merge(:gender => ""))
    no_gender_user.should_not be_valid
  end
  
  it "should require a birthday" do
    no_birth_user = User.new(@attr.merge(:birth_date => ""))
    no_birth_user.should_not be_valid
  end
  
  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        visit signin_path
        fill_in :email,    :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
      
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "First Name",   :with => "Example"
          fill_in "Last Name",    :with => "User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
end
