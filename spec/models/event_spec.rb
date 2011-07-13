require 'spec_helper'

describe Event do
  
  it "should require a title" do
    Event.new(:title => "").should_not be_valid
  end
  
  describe "date validations" do

    it "should require a start date" do
      Event.new(:start_date => "").should_not be_valid
    end
    
    it "should require a start time" do
      Event.new(:start_time => "").should_not be_valid
    end
    
    it "should require an end date" do
      Event.new(:end_date => "").should_not be_valid
    end
    
    it "should require an end time" do
      Event.new(:end_time => "").should_not be_valid
    end
    
    it "should reject bad start date" do
      @start = Date.today-1.day
      Event.new(:start_date => @start).should_not be_valid
    end
    
    it "should reject bad end date" do
      @start = Date.today
      @end = Date.today-1.day
      Event.new(:start_date => @start, :end_date => @end).should_not be_valid      
    end
        
    it "should reject bad end time" do
      @start = Time.now.strftime("%I:%M%p")
      @end = Time.now.advance(:hours => -2).strftime("%I:%M%p")
      
      Event.new(:start_time => @start, :end_time => @end).should_not be_valid           
    end

  end
  
  it "should get a list of all possible events that are active" do
        events = []
        events << Factory(:event, :status => 'active')
        events << Factory(:event, :status => 'active')
        events.each { |e| e.status.should == 'active' }
  end
  
  it "should get a list of all possible events that are unhidden" do
        events = []
        events << Factory(:event, :hide => 'no')
        events << Factory(:event, :hide => 'no')
        events.each { |e| e.hide.should == 'no' }
  end
    
  describe "email validations" do
    
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.org first.last@foo.jp]
      addresses.each do |address|
        valid_email = Event.new(:email => address)
        valid_email.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = Event.new(:email => address)
        invalid_email_user.should_not be_valid
      end
    end
  end

  describe :add_credits do
    before :each do
      @event = Event.new(:city => 'SF', :event_type => 'ue', :start_time_zone => 'UTC')     
#      @credits = Event.add_credits 
    end
    
    it "should add credits for creditworthy fields" do
      @event.changes.each do |key, item|
        @credits += RewardCredit.find_by_name(key).credits unless RewardCredit.find_by_name(key).nil?
      end
      @event.credits should == @credits
    end
    
    it "should not add credits for invalid fields" do
      
    end
  
  end
  
end
