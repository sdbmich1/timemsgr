class CalendarEvent < KitsCentralModel
  set_table_name 'events'
  set_primary_key 'ID'
   
  default_scope :order => 'eventstartdate, eventstarttime ASC'
  
  has_many :pictures, :as => :imageable, :dependent => :destroy
  
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')

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
