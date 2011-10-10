require 'rewards'
class PrivateEvent < ActiveRecord::Base
  set_table_name 'eventspriv'
  set_primary_key 'ID'
  include Rewards # include rewards to add credits for user where appropriate

  before_save :set_flds, :add_rewards
  after_save :save_rewards
  attr_accessor :allday
 	attr_accessible :allday, :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
				:eventendtime, :event_type, :reoccurrencetype, :ID, :eventid, :subscriptionsourceID,
				:mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, 
				:mapplacename, :contentsourceID, :localGMToffset, :endGMToffset,
				:allowPrivCircle, :allowSocCircle, :allowWorldCircle, :speaker, :speakertopic, :rsvp,
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
  scope :current_time, lambda { | start_tm, end_tm | where("eventstarttime >= time(?) and eventendtime <= time(?)", start_tm, end_tm)}
  scope :owned, lambda { | uid |
            { :conditions => { :contentsourceID => uid }} } 
#  scope :etype, joins('JOIN event_types ON event_types.event_type = events.event_type')
  
  def self.upcoming(start_dt, end_dt)
    active.is_visible?.where("(eventstartdate >= date(?) and eventenddate <= date(?)) or (eventstartdate <= date(?) and eventenddate >= date(?))", start_dt, end_dt, start_dt, end_dt)
  end   
  
  def self.observance?
    where("event_type in ('h', 'm')")
  end
  
  def owned?(ssid)
    self.contentsourceID == ssid
  end
 
  def self.find_event(eid)
    get_event(eid).first
  end 

  define_index do
      indexes :event_title, :sortable => true
      indexes :event_name, :sortable => true
      indexes :eventstartdate, :sortable => true
      indexes :eventenddate, :sortable => true
   
      has :id, :event_type
  end
      
  protected
  
   def same_day?
     eventstartdate == eventenddate
   end
   
   def reset_attr
     self.eventstartdate=self.eventenddate = nil
   end

   def add_rewards
     @reward_amt = add_credits(self.changes)
   end
  
   def save_rewards
     save_credits(self.contentsourceID, 'Event', @reward_amt)
   end
     
   def set_flds
      if status.nil?
        self.hide = "no"
        self.event_title = self.event_name
        self.postdate = Date.today
        self.cformat = "html"
        self.status = "active" 
        self.CreateDateTime = Time.now
        self.eventid = self.event_type[0..1] + Time.now.to_i.to_s  
     end
   end

   def self.current(edt, cid)
     edt.blank? ? edt = Date.today+14.days : edt  
     where_cid = where_dt + " and (contentsourceID = ?)"    
     find_by_sql(["#{getSQL} FROM `kits_development`.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM `kits_development`.eventsobs #{where_cid} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, cid, edt, edt, cid]) 
   end
   
   def self.getSQL
      "(SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID"     
   end
   
   def self.where_dt
      "where (status = 'active' and LOWER(hide) = 'no') 
                and ((eventstartdate >= curdate() and eventstartdate <= ?) 
                or (eventstartdate <= curdate() and eventenddate >= ?)) "
   end 
       
  def self.get_current_events
    where('((eventstartdate >= curdate() and eventstartdate <= curdate()) 
            or (eventstartdate <= curdate() and eventenddate >= curdate()))')
  end
  
  def self.get_event(eid)
    where_id = "where (ID = ?))"
    find_by_sql(["#{getSQL} FROM `kits_development`.eventspriv #{where_id} 
         UNION #{getSQL} FROM `kits_development`.eventsobs #{where_id}", eid, eid])        
  end
       
end
