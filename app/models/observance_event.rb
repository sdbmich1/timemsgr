require 'rewards'
class ObservanceEvent < ActiveRecord::Base
  set_table_name 'eventsobs'
  set_primary_key 'ID'
  include Rewards # include rewards to add credits for user where appropriate
  
  belongs_to :channel
  
  before_save :set_flds, :add_rewards
  after_save :save_rewards
  attr_accessor :current_user
  attr_accessible :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
        :eventendtime, :event_type, :eventid, :subscriptionsourceID,
        :contentsourceID, :localGMToffset, :endGMToffset,
        :allowSocCircle, :allowPrivCircle, :allowWorldCircle,
        :showSocCircle, :showPrivCircle, :showWorldCircle, :mapplacename,
        :mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, 
        :eventday, :eventmonth, :eventgday, :eventgmonth,:obscaltype,
        :annualsamedate, :speaker, :speakertopic, :rsvp,
        :host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime, :LastModifyDate
  
  validates :event_name, :presence => true
  validates :event_type, :presence => true
  validates_presence_of :eventstartdate, :if => "eventstartdate.nil?"
  validates_presence_of :eventstarttime, :if => "eventstarttime.nil?"
  validates_presence_of :eventendtime, :if => "eventendtime.nil?"
  validates :eventenddate, :presence => true
  validates :RSVPemail, :email_format => true, :unless => Proc.new { |a| a.RSVPemail.blank? } 
  validates_uniqueness_of :event_name, :scope => [:contentsourceID,:eventstartdate, :eventstarttime]
            
  default_scope :order => 'eventstartdate, eventstarttime ASC'
  
  scope :active, where(:status.downcase => 'active')
  scope :is_visible?, where(:hide.downcase => 'no')


  
  protected
  
   def add_rewards
     @reward_amt = add_credits(self.changes)
   end
  
   def save_rewards
     save_credits(self.contentsourceID, 'Event', @reward_amt)
   end
   
   def set_flds
     if self.annualsamedate.blank?
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
   end
    
end
