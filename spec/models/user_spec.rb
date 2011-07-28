require 'spec_helper'

describe User do
	
  before(:each) do
    @attr = { :first_name => "Example", :last_name => "User", :email => "user@example.com",
    	 :gender => 'Male', :username => "test01", :birth_date => Time.parse('1980-11-11'),
    	 :location_id => 1, :password => 'setup123'}
    @user = Factory.stub(:user)  # @user = User.create(@attr)
  end
 
  it "should require a first name" do
    User.new(@attr.merge(:first_name => "")).should_not be_valid
  end
  
  it "should require a last name" do
    User.new(@attr.merge(:last_name => "")).should_not be_valid
  end
  
  it "should require a gender" do
    User.new(@attr.merge(:gender => "")).should_not be_valid
  end
  
  it "should require a birthday" do
    User.new(@attr.merge(:birth_date => "")).should_not be_valid
  end
  
  it "should require a user name" do
    User.new(@attr.merge(:username => "")).should_not be_valid
  end
  
  it "should require a location" do
    User.new(@attr.merge(:location_id => "")).should_not be_valid
  end
  
  describe "interests user" do

    it "should have an interest users attribute" do
      @user.should respond_to(:interests)
    end
  end
 
  describe "affiliations" do

    it "should have a affiliations attribute" do
      @user.should respond_to(:affiliations)
    end
  end
  
  describe "associates" do

    it "should have a associates attribute" do
      @user.should respond_to(:associates)
    end
  end
  
  describe "channels" do

    before(:each) do
      @sub = Factory(:subscription, :user => @user) 
    end

    it "should have a channels attribute" do
      @user.should respond_to(:subscriptions)
    end
  end

  describe "host profiles" do

    before(:each) do
      @sub = Factory(:host_profile, :user => @user) 
    end

    it "should have a host profile attribute" do
      @user.should respond_to(:host_profiles)
    end
  end  
  
  describe "settings" do

    before(:each) do
      @sub = Factory(:setting, :user => @user) 
    end

    it "should have a setting attribute" do
      @user.should respond_to(:settings)
    end
  end  
  
  it "should update time zone on save!" do
    user = User.new(@attr)
    user.expects(:set_timezone)
    user.save!
  end
  
  it "should update settings on save" do
    user = User.new(@attr)
    user.expects(:add_settings)
    user.stub :save => true
  end
  
  context 'rewards' do
        
    before :each do
      @user = Factory.build(:user)      
    end
    
    it "should add user rewards on save" do
      @user.expects(:add_rewards)
      @user.stub :save => true
    end
  
    it "should save user rewards on save" do
      @user.expects(:save_rewards)
      @user.stub :save => true
    end  
  end

end
