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
        :showSocCircle, :showPrivCircle, :showWorldCircle,
        :mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, 
        :eventday, :eventmonth, :eventgday, :eventgmonth,:obscaltype,
        :annualsamedate, :speaker, :speakertopic, :rsvp,
        :host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime, :LastModifyDate
  
  validates :event_title, :presence => true
  validates :event_type, :presence => true
  validates_presence_of :eventstartdate, :if => "eventstartdate.nil?"
  validates_presence_of :eventstarttime, :if => "eventstarttime.nil?"
  validates_presence_of :eventendtime, :if => "eventendtime.nil?"
  validates :eventenddate, :presence => true
  validates :RSVPemail, :email_format => true, :unless => Proc.new { |a| a.RSVPemail.blank? } 
  validates_uniqueness_of :event_title, :scope => [:contentsourceID,:eventstartdate, :eventstarttime]
            
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
   
  
end
