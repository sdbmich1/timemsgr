class Event < KitsTsdModel  
  set_primary_key 'ID' 
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
    find_by_sql(["#{getSQL} FROM `kitscentraldb`.events WHERE #{where_dt} )
         UNION #{getSQL} FROM `kitstsddb`.events WHERE #{where_dt} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, edt, edt]) 
  end  
  
  def self.current(edt, cid)
    where_cid = where_dte + " AND (e.contentsourceID = ?)" 
    where_sid = where_subscriber_id + ' AND ' + where_dte   
    find_by_sql(["#{getSQLe} FROM `kits_development`.eventspriv e WHERE #{where_cid} ) 
         UNION #{getSQLe} FROM `kits_development`.eventsobs e WHERE #{where_cid} )
         UNION #{getSQLe} FROM `kitscentraldb`.events e WHERE #{where_dte} )
         UNION #{getSQLe} FROM `kitstsddb`.events #{where_sid} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, cid, edt, edt, cid, edt, edt, cid, edt, edt]) 
  end
  
  def self.get_event(eid)
    where_id = "where (ID = ?))"
    find_by_sql(["#{getSQL} FROM `kits_development`.eventspriv #{where_id} 
         UNION #{getSQL} FROM `kits_development`.eventsobs #{where_id} 
         UNION #{getSQL} FROM `kitstsddb`.events #{where_id} 
         UNION #{getSQL} FROM `kitscentraldb`.events #{where_id}", eid, eid, eid, eid])        
  end
  
  def self.find_event(eid)
    get_event(eid).try(:first)
  end 
  
  def self.find_events(edate, hprofile) 
    edate.blank? ? edate = Date.today+14.days : edate  
    hprofile.blank? ? current_events(edate) : current(edate, hprofile.subscriptionsourceID)    
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
 
  def self.getSQLe
      "(SELECT e.ID, e.event_name, e.event_type, e.eventstartdate, e.eventenddate, e.eventstarttime, 
        e.eventendtime, e.event_title, e.cbody, e.bbody, e.mapplacename, e.localGMToffset, e.endGMToffset,
        e.mapstreet, e.mapcity, e.mapstate, e.mapzip, e.mapcountry, e.location, e.subscriptionsourceID, 
        e.speaker, e.RSVPemail, e.speakertopic, e.host, e.rsvp, e.eventid, e.contentsourceID"     
  end
   
  def self.where_dt
      "(status = 'active' AND hide = 'No') 
                AND ((eventstartdate >= curdate() and eventstartdate <= ?) 
                OR (eventstartdate <= curdate() and eventenddate >= ?)) "
  end
  
  def self.where_dte
      "( e.status = 'active' AND e.hide = 'No') 
                AND ((e.eventstartdate >= curdate() and e.eventstartdate <= ?) 
                OR (e.eventstartdate <= curdate() and e.eventenddate >= ?)) "
  end
   
  def self.where_subscriber_id 
     "e,`kitstsddb`.subscriptions s 
        WHERE s.contentsourceID = ?
        AND s.channelID = e.subscriptionsourceID "
  end    
end
