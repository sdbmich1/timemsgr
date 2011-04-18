require 'spec_helper'

describe Affiliation do
	
  before(:each) do
    @user = Factory(:user)
    @attr = { :name => "org", :affiliation_type => "Social" }
  end

  it "should create a new instance given valid attributes" do
    @user.affiliations.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @affiliation = @user.affiliations.create(@attr)
    end

    it "should have a user attribute" do
      @affiliation.should respond_to(:user)
    end

    it "should have the right associated user" do
      @affiliation.user.should == @user
    end
  end
  
  describe "validations" do
    before(:each) do
      @affiliation = @user.affiliations.create(@attr)
    end
    
    it "should require a name" do
   		@affiliation.name = nil
   		@affiliation.should_not be_valid
   	end
   	
   	it "should require a type" do
   		@affiliation.affiliation_type = nil
   		@affiliation.should_not be_valid
   	end
  end

end
