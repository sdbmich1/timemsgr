require 'spec_helper'

describe Associate do
 
  before(:each) do
    @user = Factory(:user)
    @attr = { :email => "foo@foobar.com" }
  end
  
  it "should create a new instance given valid attributes" do
    @user.associates.create!(@attr)
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = Associate.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = Associate.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  describe "user associations" do

    before(:each) do
      @associate = @user.associates.create(@attr)
    end

    it "should have a user attribute" do
      @associate.should respond_to(:user)
    end

    it "should have the right associated user" do
      @associate.user_id.should == @user.id
      @associate.user.should == @user
    end
  end
end
