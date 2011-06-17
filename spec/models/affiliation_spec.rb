require 'spec_helper'

describe Affiliation do
	
  before(:each) do
    @user = Factory.stub(:user)
    @attr = { :name => "org", :affiliation_type => "Social" }
    @aff = @user.affiliations.build
    @affiliation = @user.affiliations.create(@attr)
  end
  
  # validate fields
  subject { @aff }

  context "when name empty" do
    it { should_not be_valid }
    specify { @aff.save.should == false }
  end
  
  context "when name not empty" do
    before { @aff.name = 'YBC'
             @aff.affiliation_type = "Social" }
 
    it { should be_valid }
    specify { @aff.save.should == true }
  end
  
  context "when affiliation_type empty" do
    it { should_not be_valid }
    specify { @aff.save.should == false }
  end

  describe "create affiliation" do
        
    it "should reject duplicate affiliations" do
      duplicate_aff = @user.affiliations.build(@attr)
      duplicate_aff.stub :save => false
    end
    
  end

  describe "user associations" do

    it "should have a user attribute" do
      @affiliation.should respond_to(:user)
    end

    it "should have the right associated user" do
      @affiliation.user_id.should == @user.id
    end
  end
  
  describe "validations" do
    
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
