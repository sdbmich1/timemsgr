require 'spec_helper'

describe InterestsUsers do
  before(:each) do
    @user = Factory(:user)
    @interest = Factory(:interest)
    @interests = @user.interests.build(@interest)
  end

  it "should create a new instance given valid attributes" do
    @interests.save!
  end
  
  context 'rewards' do
    
    before(:each) do
      @user = Factory(:user)
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
