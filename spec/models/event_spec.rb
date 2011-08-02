require 'spec_helper'

describe Event do
  
  it "should require a title" do
    Event.new(:title => "").should_not be_valid
  end
  
  it "should require an event code" do
    Event.new(:event_type => "").should_not be_valid
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
  
  context '.active' do
    
    it "should respond to active method" do
      Event.should respond_to(:active)
    end
    
    it "should include active events" do
        event = Factory(:event, :status => 'active')
        Event.active.should include(event)
    end
    
    it "should not list of unactive events" do
        event = Factory(:event, :status => 'inactive')
        Event.active.should_not include(event)
    end

  end
  
  context '.is_visible?' do
 
    it "should respond to is_visible? method" do
      Event.should respond_to(:is_visible?)
    end
   
    it "should get a list of all events that are unhidden" do
        events = []
        events << Factory(:event, :hide => 'no')
        events << Factory(:event, :hide => 'no')
        events.each { |e| e.hide.should == 'no' }
    end

    it "should not list of hidden events" do
        event = Factory(:event, :hide => 'yes')
        Event.is_visible?.should_not include(event)
    end
  end
  
  context ".upcoming" do
    
    it "should respond to upcoming method" do
      Event.should respond_to(:upcoming)
    end
    
    it "should list of upcoming events within given date range" do
        events = []
        events << Factory(:event, :start_date => Date.today)
        events << Factory(:event, :end_date => Date.today+2.days)
        events.each { |e| Event.upcoming(Date.today,Date.today+2.days).should include(e) }       
    end
  end
    
  describe "email validations" do
    
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.com first.last@foo.jp]
      addresses.each do |address|
        valid_email = Factory(:event, :email => address)
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

  describe '.add_rewards' do
    before :each do
      @event = Factory.build(:event)      
    end
        
    it "should add credits for appropriate changed fields" do
      @event.should_receive(:add_rewards) 
      @event.save!     
    end
  end
  
  context '.save_rewards' do
            
    before :each do
      @event = Factory.build(:event)      
    end

    it "should save rewards" do
      @event.should_receive(:save_rewards) 
      @event.save!          
    end 
  end 
  
  context '.owned' do
    
    it "should respond to owned method" do
      Event.should respond_to(:owned)
    end
    
    it "should get a list of all events given user_id" do
        uid = 123
        event = Factory(:event, :user_id => uid)
        Event.owned(uid).should include(event)
    end    
    
    it "should not list of all events given user_id" do
        uid = 123
        event = Factory(:event, :user_id => nil)
        Event.owned(uid).should_not include(event)
    end     
  end     
end
