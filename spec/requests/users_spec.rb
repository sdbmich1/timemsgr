require 'spec_helper'

describe "Users" do
  
  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          click_button "Sign Up"
          response.should render_template('users/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do

      it "should make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in "First Name",   :with => "Example"
          fill_in "Last Name",    :with => "User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Username",     :with => "foobar"
          fill_in "City",         :with => 1
          fill_in "Gender",       :with => "Male"
          fill_in "Birthdate",        :with => "1967-04-23"
          click_button "Sign Up"
          response.should have_selector(:content => "Interests")
          response.should render_template('users/home')
        end.should change(User, :count).by(1)
      end
    end
  end
  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        visit new_user_session_path
        fill_in "Username or email",    :with => ""
        fill_in "Password", :with => ""
        click_button "Sign In"
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = User.new(@attr)
        visit new_user_session_path
        fill_in "Username or email",    :with => user.email
        fill_in "Password", :with => user.password
        click_button "Sign In"
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
      
      it "should make a new user" do
        lambda do
          visit new_user_registration_path
          user = User.new(@attr)
          click_button 
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/home')
        end.should change(User, :count).by(1)
      end
    end
  end
end
