require 'rewards'
class ObservanceEvent < ActiveRecord::Base
  set_table_name 'eventsobs'
  set_primary_key 'ID'
  include Rewards # include rewards to add credits for user where appropriate
  
  belongs_to :channel
  
  before_save :set_flds, :add_rewards
  after_save :save_rewards 
  
  attr_accessor :allday
  attr_accessible :allday, :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
        :eventendtime, :event_type, :eventid, :subscriptionsourceID,
        :contentsourceID, :localGMToffset, :endGMToffset,
        :allowSocCircle, :allowPrivCircle, :allowWorldCircle,
        :ShowSocCircle, :ShowPrivCircle, :ShowWorldCircle, :mapplacename,
        :mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, 
        :eventday, :eventmonth, :eventgday, :eventgmonth,:obscaltype,
        :annualsamedate, :speaker, :speakertopic, :rsvp,
        :postdate, :status, :hide,
        :host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime, :LastModifyDate
  
  validates :event_name, :presence => true, :length => { :maximum => 100 },
        :uniqueness => { :scope => [:contentsourceID,:eventstartdate, :eventstarttime] }
  validates :event_type, :presence => true
  validates_date :eventstartdate, :presence => true, :date => {:after_or_equal_to => Date.today}
  validates_date :eventenddate, :presence => true, :allow_blank => false, :date => {:after_or_equal_to => :eventstartdate}
  validates :eventstarttime, :presence => true
  validates_time :eventendtime, :presence => true, :after => :eventstarttime, :if => :same_day?
  validates :bbody, :length => { :maximum => 255 }  
            
  default_scope :order => 'eventstartdate, eventstarttime ASC'
  
  scope :active, where(:status.downcase => 'active')
  scope :is_visible?, where(:hide.downcase => 'no')

  protected
  
   def same_day?
     eventstartdate == eventenddate
   end
  
   def add_rewards
     @reward_amt = add_credits(self.changes)
   end
  
   def save_rewards
     save_credits(self.contentsourceID, 'Event', @reward_amt)
   end
   
   def set_flds
     if status.nil?
      if self.annualsamedate == 'no'
       self.eventmonth = self.eventstartdate.month
       self.eventday = self.eventstartdate.day
      else
       self.eventgmonth = self.eventstartdate.month
       self.eventgday = self.eventstartdate.day
       self.eventenddate = self.eventstartdate+120.years
       self.eventstarttime = Time.parse('00:00')
       self.eventendtime = Time.parse('11:59')
      end
     
      self.event_title = self.event_name
      self.obscaltype = 'Gregorian'
      self.status = 'active'
      self.hide = 'no'
      self.postdate = Time.now
      self.eventid = self.event_type[0..1] + Time.now.to_i.to_s 
    end 
  end
    
end
