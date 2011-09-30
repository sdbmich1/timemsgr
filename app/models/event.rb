class Event < KitsTsdModel   
  belongs_to :channel

  has_many :session_relationships, :dependent => :destroy
  has_many :sessions, :through => :session_relationships, 
          :dependent => :destroy

  has_many :event_presenters, :dependent => :destroy
  has_many :presenters, :through => :event_presenters, :dependent => :destroy

  has_many :event_sites, :dependent => :destroy
  has_many :event_tracks, :dependent => :destroy
  has_many :pictures, :as => :imageable, :dependent => :destroy
  
  default_scope :order => 'eventstartdate, eventstarttime ASC'

  def self.current_events(edt)
    find_by_sql(["#{getSQL} FROM `kitscentraldb`.events #{where_dt} )
         UNION #{getSQL} FROM `kitstsddb`.events #{where_dt} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, edt, edt]) 
  end  
  
  def self.current(edt, cid)
    where_cid = where_dt + " and (contentsourceID = ?)"    
    find_by_sql(["#{getSQL} FROM `kits_development`.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM `kitscentraldb`.events #{where_dt} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, cid, edt, edt]) 
  end
  
  def self.get_event(eid)
    where_id = "where (ID = ?))"
    find_by_sql(["#{getSQL} FROM `kits_development`.eventspriv #{where_id} 
         UNION #{getSQL} FROM `kitscentraldb`.events #{where_id}", eid, eid])        
  end
  
  def self.find_event(eid)
    get_event(eid).first
  end 
  
  def self.get_event_details(eid)
    joins(:sessions, :presenters).find(eid)
  end
  
  def self.getSQL
      "(SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID"     
   end
   
   def self.where_dt
      "where (status = 'active' and hide = 'No') 
                and (eventstartdate >= curdate() and eventstartdate <= ?) 
                or (eventstartdate <= curdate() and eventenddate >= ?) "
   end
    
end
