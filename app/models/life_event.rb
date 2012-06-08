class LifeEvent < ActiveRecord::Base
  set_table_name 'eventsobs'
  set_primary_key 'ID'
  
  belongs_to :channel
  
  before_save :set_flds
  
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
    location.blank? ? '' : get_place.blank? ? location : get_place + ', ' + location 
  end
  
  def get_place
    mapplacename.blank? ? '' : mapplacename + ' '
  end
  
  def csz
    mapcity.blank? ? '' : mapstate.blank? ? mapcity : mapcity + ', ' + mapstate + ' ' + mapzip
  end
  
  def location_details
    get_location + csz
  end  
    
  protected
  
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
      self.eventgmonth, self.eventgday, self.eventenddate = self.eventstartdate.month, self.eventstartdate.day, self.eventstartdate+120.years
      self.eventstarttime, self.eventendtime = Time.parse('00:00'), Time.parse('11:59')
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
