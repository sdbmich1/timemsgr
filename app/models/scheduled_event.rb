class ScheduledEvent < ActiveRecord::Base
  set_table_name 'events'
  set_primary_key 'ID'

  before_save :set_flds
  attr_accessor :loc
 	attr_accessible :allday, :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
				:eventendtime, :event_type, :reoccurrencetype, :ID, :eventid, :subscriptionsourceID,
				:mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, 
				:mapplacename, :contentsourceID, :localGMToffset, :endGMToffset,
				:allowPrivCircle, :allowSocCircle, :allowWorldCircle, :speaker, :speakertopic, :rsvp,
				:host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime,
				:session_type, :track, :host, :RSVPemail, :rsvp, :eventid, :speaker, 
        :contentsourceID, :subscriptionsourceID, :contentsourceURL, 
        :subscriptionsourceURL, :AffiliateFee, :Other3Fee, :AtDoorFee, 
        :GroupFee, :Other1Fee, :Other2Fee, :SpouseFee, :MemberFee, :NonMemberFee, 
        :Other4Fee, :Other5Fee, :Other6Fee, :pictures_attributes, :Other1Title, :Other2Title,
        :Other3Title, :Other4Title, :Other5Title, :Other6Title
        
  validates :event_name, :presence => true, :length => { :maximum => 255 },
        :uniqueness => { :scope => [:contentsourceID,:eventstartdate, :eventstarttime] }, :unless => :inactive?
  validates :event_type, :presence => true
  validates_date :eventstartdate, :presence => true, :allow_blank => false #, :on_or_after => :today 
  validates_date :eventenddate, :presence => true, :allow_blank => false, :on_or_after => :eventstartdate
#  validates :eventstarttime, :presence => true, :allow_blank => false
#  validates :eventendtime, :presence => true, :allow_blank => false        
				        
  belongs_to :host_profile, :foreign_key => :subscriptionsourceID, :primary_key => :contentsourceID
 
  has_many :session_relationships, :primary_key => :ID, :foreign_key=>:event_id, :dependent => :destroy
  has_many :sessions, :through => :session_relationships, :dependent => :destroy
  has_many :event_presenters, :primary_key => :eventid, :foreign_key=>:eventid, :dependent => :destroy
  has_many :presenters, :through => :event_presenters, :dependent => :destroy 
  has_many :sponsor_pages, :primary_key => :ID, :foreign_key=>:event_id, :dependent => :destroy
 
  has_many :pictures, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  
  default_scope :order => 'eventstartdate, eventstarttime ASC'
	
	scope :active, where(:status.downcase => 'active')
	scope :unhidden, where(:hide.downcase => 'no')
  
  def self.upcoming(start_dt, end_dt)
    active.unhidden.where("(eventstartdate >= date(?) and eventenddate <= date(?)) or (eventstartdate <= date(?) and eventenddate >= date(?))", start_dt, end_dt, start_dt, end_dt)
  end  
  
  def self.dbname
    Rails.env.development? ? "`kits_development`" : "`kits_production`"
  end   
  
  def inactive?
    status == 'inactive'
  end
  
  def ssid
    subscriptionsourceID
  end
  
  def cid
    contentsourceID
  end

  def owned?(ssid)
    self.contentsourceID == ssid
  end

  def ssurl
    subscriptionsourceURL
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
    bbody.gsub("\\n",'').html_safe[0..74]
  end
  
  def listing
    event_name.length < 30 ? event_name.html_safe : event_name.html_safe[0..30] + '...' rescue nil
  end
  
  def details
    cbody.gsub("\\n","<br />")[0..499]
  end
  
  def full_details
    cbody.gsub("\\n","<br />")
  end
  
  def self.locate_event id, eid
    eid ? ScheduledEvent.find_by_eventid(eid) : ScheduledEvent.find(id)
  end  
  
  def self.find_event(eid)
    get_event(eid).first
  end 
  
  def same_day?
    eventstartdate == eventenddate
  end
  
  def self.add_event(eid, etype, ssid, evid, sdt)
    selected_event = Event.find_event(eid, etype, evid, sdt)
    new_event = ScheduledEvent.new(selected_event.attributes)    
    new_event.contentsourceID, new_event.eventstartdate, new_event.ID = ssid, sdt, nil 

    # reset event type
    [['ue','other'],['cnf','conf'],['prf','perform'],['fst','fest'],['tmnt','tourn'],['cnv','conv'],['mtg','meeting'], 
     ['te','match'], ['es','session'], ['fr','fund'], ['ce', 'other']].each do |i|
      new_event.event_type = i[1] if selected_event.event_type == i[0]
    end

    selected_event.pictures.each do |p|
      new_event.pictures.build(:photo => p.photo)
    end             
     
    new_event
  end
  
  protected
     
   def set_flds
     if self.status.blank?
        self.event_title = self.event_name if self.event_title.blank?
        self.postdate, self.CreateDateTime, self.status, self.hide = Date.today, Time.now, 'active', 'no'
        self.eventid = self.event_type[0..1] + Time.now.to_i.to_s if self.eventid.blank? 
     end
   end

   def self.current(edt, cid)
     edt.blank? ? edt = Date.today+14.days : edt  
     where_cid = where_dt + " and (contentsourceID = ?)"    
     find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_cid} )
         UNION #{getSQL} FROM #{dbname}.events #{where_cid} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, cid, edt, edt, cid, edt, edt, cid]) 
   end
   
   def self.get_events(cid)
     where_cid = " WHERE (contentsourceID = ?)"    
     find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_cid} )
         UNION #{getSQL} FROM #{dbname}.events #{where_cid} )
         ORDER BY eventstartdate, eventstarttime ASC", cid, cid, cid]) 
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
    find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_id} 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_id}       
         UNION #{getSQL} FROM #{dbname}.events #{where_id}", eid, eid, eid])        
  end
  
  def self.set_status(eid)
    event = ScheduledEvent.find_by_eventid(eid)
    event.status = 'inactive' if event
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
    where "(status = 'active' AND LOWER(hide) = 'no')"
  end
  
  sphinx_scope(:datetime_first) { 
    {:order => 'eventstartdate, eventstarttime ASC'}
  }  
  
  default_sphinx_scope :datetime_first
       
end
