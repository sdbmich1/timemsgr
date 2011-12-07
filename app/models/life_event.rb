require 'rewards'
class LifeEvent < ActiveRecord::Base
  set_table_name 'eventsobs'
  set_primary_key 'ID'
  include Rewards # include rewards to add credits for user where appropriate
  
  belongs_to :channel
  
  before_save :set_flds, :add_rewards
  after_save :save_rewards 
  
  attr_accessor :allday, :loc
  attr_accessible :allday, :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
        :eventendtime, :event_type, :eventid, :subscriptionsourceID,
        :contentsourceID, :localGMToffset, :endGMToffset,
        :allowSocCircle, :allowPrivCircle, :allowWorldCircle,
        :ShowSocCircle, :ShowPrivCircle, :ShowWorldCircle, :mapplacename,
        :mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, 
        :eventday, :eventmonth, :eventgday, :eventgmonth,:obscaltype,
        :annualsamedate, :speaker, :speakertopic, :rsvp, :contentsourceURL, :subscriptionsourceURL,
        :postdate, :status, :hide, :pictures_attributes,
        :host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime, :LastModifyDate
  
  validates :event_name, :presence => true, :length => { :maximum => 100 },
        :uniqueness => { :scope => [:contentsourceID,:eventstartdate, :eventstarttime] }
  validates :event_type, :presence => true
  validates_date :eventstartdate, :presence => true, :on_or_after => :today 
  validates_date :eventenddate, :presence => true, :allow_blank => false, :on_or_after => :eventstartdate
  validates :eventstarttime, :presence => true, :allow_blank => false
  validates :eventendtime, :presence => true, :allow_blank => false
  validates_time :eventendtime, :after => :eventstarttime, :if => :same_day?
  validates :bbody, :length => { :maximum => 255 }  
  
  has_many :pictures, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true

  default_scope :order => 'eventstartdate, eventstarttime ASC'
  
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')
  scope :current, where('eventenddate >= curdate()')
  
  def same_day?
    eventstartdate == eventenddate
  end
  
  def ssid
    subscriptionsourceID
  end
  
  def cid
    contentsourceID
  end
  
  protected
  
  def clone_event
    new_event = self.clone

    new_event.eventstartdate = new_event.eventenddate = Date.today
    new_event
  end
    
   def add_rewards
     @reward_amt = add_credits(self.changes)
   end
  
   def save_rewards
     save_credits(self.contentsourceID, 'Event', @reward_amt)
   end
   
   def set_flds
     
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
     
    self.postdate = Time.now
    self.eventid = self.event_type[0..1] + Time.now.to_i.to_s 
    self.event_title = self.event_name
 
    if status.nil?     
      self.obscaltype = 'Gregorian'
      self.status = 'active'
      self.hide = 'no'
    end 
  end
    
end
