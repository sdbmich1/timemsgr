class CalendarEvent < KitsCentralModel
  set_table_name 'events'
  set_primary_key 'ID'
  
  before_save :set_flds

  attr_accessible :allday, :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
        :eventendtime, :event_type, :reoccurrencetype, :ID, :eventid, :subscriptionsourceID,
        :mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, :postdate,
        :mapplacename, :contentsourceID, :localGMToffset, :endGMToffset, :status, :hide, :pageextsourceID,
        :allowPrivCircle, :allowSocCircle, :allowWorldCircle, :speaker, :speakertopic, :rsvp, :LastModifyDateTime,
        :host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime, :pictures_attributes, :contentsourceURL
                  
  default_scope :order => 'eventstartdate, eventstarttime ASC'
  
  has_many :pictures, :as => :imageable, :dependent => :destroy
  
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')
  
  def self.holidays
    where(:event_type => ['h','m'])
  end

  def ssid
    subscriptionsourceID
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
    mapplacename.blank? ? '' : mapplacename
  end
  
  def csz
    mapcity.blank? ? '' : mapstate.blank? ? mapcity : mapcity + ', ' + mapstate + ' ' + mapzip
  end
  
  def location_details
    get_location + ', ' + csz
  end
  
  def set_flds
    if new_record?
      self.hide, self.cformat, self.status, self.LastModifyBy, self.rsvp = "no", "html", "active", "system", "No"
      self.event_name,self.bbody  = self.event_title[0..99], self.cbody
      self.CreateDateTime, self.LastModifyDateTime = Time.now, Time.now
      self.eventid = self.event_type[0..1].upcase + Time.now.to_i.to_s if self.eventid.blank? 
    end
  end
    
  define_index do
    indexes :event_name, :sortable => true
    indexes :bbody
    indexes :cbody
    indexes :eventstartdate, :sortable => true
    indexes :eventenddate
   
    has :ID, :as => :event_id
    has :event_type
    where "(status = 'active' AND hide = 'no' AND event_type NOT IN ('es', 'h', 'm'))
          AND ((eventstartdate >= curdate() ) 
                OR (eventstartdate <= curdate() and eventenddate >= curdate()) ) "
  end
  
  sphinx_scope(:datetime_first) { 
    {:order => 'eventstartdate, eventstarttime ASC'}
  }  
  
  default_sphinx_scope :datetime_first
end
