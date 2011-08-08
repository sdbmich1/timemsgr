require 'rewards'
class Event < ActiveRecord::Base
  set_table_name 'eventspriv'
  set_primary_key 'ID'
  include Rewards # include rewards to add credits for user where appropriate
  before_save :set_flds, :add_rewards
  after_save :save_rewards
  attr_accessor :current_user, :activity_type
 	attr_accessible :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
				:eventendtime, :event_type, :reoccurrencetype, 
				:mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, 
				:mapplacename, :contentsourceID, :localGMToffset, :endGMToffset,
				:allowPrivCircle, :allowSocCircle, :allowWorldCircle, :speaker, :speakertopic, :rsvp,
				:host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime, :LastModifyDate
	
#	has_attached_file :imagelink, :default_url => "/images/clock_grey.png" #, :styles => { :thumb => "35x35>", :medium => "100x100>" }
#  validates_attachment_content_type :imagelink, :content_type => ['image/jpeg', 'image/png'] 
#	validates_attachment_size :imagelink, :less_than => 1.megabyte
	
	validates :event_title, :presence => true
	validates :event_type, :presence => true
	validates_presence_of :eventstartdate, :if => "eventstartdate.nil?"
  validates_presence_of :eventstarttime, :if => "eventstarttime.nil?"
  validates_presence_of :eventendtime, :if => "eventendtime.nil?"
  validates :eventenddate, :presence => true
  validates :RSVPemail, :email_format => true, :unless => Proc.new { |a| a.RSVPemail.blank? } 
      		
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

  def self.current_events(enddate)
    active.is_visible?.upcoming(Time.now, enddate).where("eventstarttime >= time(?) and eventendtime <= time(?)", Time.now, enddate)
  end  
  
  def self.current(edt, cid)
    where_dt = "where (status = 'active' and hide = 'No') 
                and (eventstartdate >= curdate() and eventstartdate <= ?) 
                or (eventstartdate <= curdate() and eventenddate >= ?) "
    where_cid = where_dt + " and (contentsourceID = ?)"
    find_by_sql(["#{getSQL} FROM `kits_development`.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM `kitscentraldb`.events #{where_dt} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, cid, edt, edt]) 
  end
  
  def self.find_event(eid)
    where_id = "where (id = ?))"
    find_by_sql(["#{getSQL} FROM `kits_development`.eventspriv #{where_id} 
         UNION #{getSQL} FROM `kitscentraldb`.events #{where_id}", eid, eid])        
  end

  def add_rewards
    @reward_amt = add_credits(self.changes)
  end
  
  def save_rewards
    save_credits(self.contentsourceID, 'Event', @reward_amt)
  end
  
  def self.observance?
    where("event_type in ('h', 'm')")
  end
  
  def owned?(user)
    self.contentsourceID == user.id
  end
    
  def reset_attr
    self.eventstartdate=self.eventenddate = nil
  end
     
  define_index do
      indexes :event_title, :sortable => true
      indexes :event_name, :sortable => true
      indexes :eventstartdate, :sortable => true
      indexes :eventenddate, :sortable => true
   
      has :id, :event_type
  end
      
  protected
   
    def self.getSQL
      "(SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID,
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID"     
    end
    
    def set_flds
      if status.nil?
        self.status = "active" 
        self.hide = "No"
        self.event_name = self.event_title
        self.postdate = Date.today
        self.cformat = "html"
        self.CreateDateTime = Time.now
        self.ID = Event.count + 10000
      end
    end
       
end
