class LifeEvent < ActiveRecord::Base
  set_table_name 'eventsobs'
  set_primary_key 'ID'
  
  belongs_to :channel
  
  before_save :set_flds
  
  attr_accessor :allday, :loc, :fbCircle
  attr_accessible :allday, :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
        :eventendtime, :event_type, :eventid, :subscriptionsourceID,
        :contentsourceID, :localGMToffset, :endGMToffset, :allowSocCircle, :allowPrivCircle, :allowWorldCircle,
        :ShowSocCircle, :ShowPrivCircle, :ShowWorldCircle, :mapplacename,
        :mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, 
        :eventday, :eventmonth, :eventgday, :eventgmonth,:obscaltype, :remindflg, :remindertype, :reoccurrenceenddate,
        :annualsamedate, :speaker, :speakertopic, :rsvp, :contentsourceURL, :subscriptionsourceURL,
        :postdate, :status, :hide, :pictures_attributes, :host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime, :LastModifyDate, :fbCircle
  
  validates :event_name, :presence => true, :length => { :maximum => 100 },
        :uniqueness => { :scope => [:contentsourceID,:eventstartdate, :eventstarttime] }, :unless => :inactive?
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
  
  def inactive?
    status == 'inactive'
  end
    
  def ssid
    subscriptionsourceID
  end
  
  def ssurl
    subscriptionsourceURL
  end
    
  def cid
    contentsourceID
  end
  
  def start_date
    eventstartdate.to_date
  end
  
  def end_date
    eventenddate.to_date
  end
    
  def get_location
    location.blank? || !(location =~ /http/i).nil? ? get_place.blank? ? '' : get_place : location
  end
  
  def get_place
    mapplacename.blank? ? '' : mapplacename
  end
  
  def csz
    mapcity.blank? ? '' : mapstate.blank? ? mapcity : [mapcity, mapstate].compact.join(', ') + ' ' + mapzip
  end
  
  def location_details
    get_location.blank? ? csz : [get_location, mapstreet, csz].join(', ') unless get_place.blank? && csz.blank?
  end    
  
  def summary
    bbody.gsub("\\n",'').html_safe[0..59] + '...' rescue nil
  end
  
  def listing
    event_name.length < 30 ? event_name.html_safe : event_name.html_safe[0..30] + '...' rescue nil
  end
  
  def details
    cbody.gsub("\\n","<br />")[0..499] rescue nil
  end
  
  def full_details
    cbody.gsub("\\n","<br />")
  end
  
  def self.find_event id, eid
    LifeEvent.find_by_ID_and_eventid(id, eid)
  end
  
  def self.set_rel_birth_date model
    trkr = User.find model.tracker_id
    trkd = User.find model.tracked_id
    
    add_birth_date trkr, trkd
    add_birth_date trkd, trkr
  end
    
  protected
  
  def self.add_birth_date usr1, usr2
    new_event = LifeEvent.new
    new_event.eventstartdate = new_event.eventenddate = usr2.birth_date
    new_event.event_type, new_event.annualsamedate = 'birthday', 'yes'
    new_event.event_name = usr2.name + ' Birthday'
    new_event.contentsourceID = new_event.subscriptionsourceID = usr1.ssid
    new_event.save(:validate=>false)    
  end
  
  def clone_event
    new_event = self.clone
    new_event.eventstartdate = new_event.eventenddate = Date.today
    new_event
  end
   
  def set_flds
    #set dates 
    if self.annualsamedate == 'no'
      self.eventmonth, self.eventday = self.eventstartdate.month, self.eventstartdate.day
    else
      self.eventgmonth, self.eventgday = self.eventstartdate.month, self.eventstartdate.day
      self.eventstarttime, self.eventendtime = Time.parse('00:00'), Time.parse('23:59')
    end
     
    self.postdate, self.event_title, self.bbody = Time.now, self.event_name, self.cbody
    self.eventid = self.event_type[0..1] + Time.now.to_i.to_s 
 
    if new_record?     
      self.obscaltype, self.status, self.hide  = 'Gregorian', 'active', 'no'
    end 
  end
    
  def self.set_status(eid)
    event = LifeEvent.find(eid)
    event.status = 'inactive'
    event
  end    

  define_index do
    indexes :event_name, :sortable => true
    indexes :bbody, :sortable => true
    indexes :cbody, :sortable => true
    indexes :eventstartdate, :sortable => true
    indexes :eventenddate, :sortable => true
   
    has :ID, :as => :event_id
    has :event_type
    where "(status = 'active' AND LOWER(hide) = 'no') "
  end
  
  sphinx_scope(:datetime_first) { 
    {:order => 'eventstartdate ASC'}
  }  
  
  default_sphinx_scope :datetime_first
end
