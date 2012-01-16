class Event < KitsTsdModel  
  include ResetDate
  set_primary_key 'ID' 
  
  belongs_to :channel
  
  has_many :session_relationships, :dependent => :destroy
  has_many :sessions, :through => :session_relationships, :dependent => :destroy

  has_many :event_presenters, :primary_key => :eventid, :foreign_key=>:eventid, :dependent => :destroy
  has_many :presenters, :through => :event_presenters, :dependent => :destroy

  has_many :event_sites, :dependent => :destroy
  has_many :event_tracks, :dependent => :destroy
  has_many :pictures, :as => :imageable, :dependent => :destroy
  has_many :rsvps, :dependent => :destroy, :primary_key=>:eventid, :foreign_key => :EventID
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank 

  has_many :sponsor_pages, :dependent => :destroy, :foreign_key => :subscriptionsourceID, :primary_key => :subscriptionsourceID
  
  default_scope :order => 'eventstartdate, eventstarttime ASC'

  define_index do
    indexes :event_name, :sortable => true
    indexes :bbody, :sortable => true
    indexes :cbody, :sortable => true
    indexes :eventstartdate, :sortable => true
    indexes :eventenddate, :sortable => true
   
    has :ID, :as => :event_id
    has :event_type
    where "(status = 'active' AND hide = 'no' AND event_type != 'es')
          AND ((eventstartdate >= curdate() ) 
                OR (eventstartdate <= curdate() and eventenddate >= curdate()) ) "
  end
  
  sphinx_scope(:datetime_first) { 
    {:order => 'eventstartdate, eventstarttime ASC'}
  }  
  
  default_sphinx_scope :datetime_first

  def self.dbname
    Rails.env.development? ? "`kits_development`" : "`kits_production`"
  end
  
  def self.channel_events(edt, ssid)
    where_ssid = where_dt + " AND (subscriptionsourceID = ?)" 
    find_by_sql(["#{getSQL} FROM `kitsknndb`.events WHERE #{where_ssid}) 
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, ssid]) 
  end 
  
  def self.current_events(edt)
    find_by_sql(["#{getSQL} FROM `kitscentraldb`.events WHERE #{where_dt} )
         UNION #{getSQL} FROM `kitsknndb`.eventstsd WHERE #{where_dt} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, edt, edt]) 
  end  
  
  def self.current(edt, cid, loc)
    where_cid = where_dte + " AND (e.contentsourceID = ?)" 
    where_sid = where_subscriber_id + ' AND ' + where_dte   
    where_loc = where_dte + " AND (e.mapcity = ?)"
    find_by_sql(["#{getSQLe} FROM #{dbname}.eventspriv e WHERE #{where_cid} ) 
         UNION #{getSQLe} FROM #{dbname}.eventsobs e WHERE #{where_cid} )
         UNION #{getSQLefee} FROM `kitsknndb`.eventstsd #{where_sid} )
         UNION #{getSQLefee} FROM `kitscentraldb`.events e WHERE #{where_loc} )
         UNION #{getSQLe} FROM #{dbname}.events e WHERE #{where_cid} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, cid, edt, edt, cid, cid, edt, edt, edt, edt, loc, edt, edt, cid]) 
  end
  
  def self.get_event(eid, etype)
    where_id = "where (ID = ? AND event_type = ?))"
    find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_id} 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_id} 
         UNION #{getSQL} FROM #{dbname}.events #{where_id} 
         UNION #{getSQLfee} FROM `kitsknndb`.eventstsd #{where_id} 
         UNION #{getSQL} FROM `kitscentraldb`.events #{where_id}", eid, etype, eid, etype, eid, etype, eid, etype, eid, etype])        
  end
  
  def self.find_event(eid, etype, sdate)
    event = get_event(eid, etype).try(:first)
    event.eventstartdate = sdate if event
    event
  end 
  
  def self.find_events(edate, hp, loc) 
    locale = Location.find(loc)
    edate.blank? ? edate = Date.today+7.days : edate 
    hp.blank? ? current_events(edate) : current(edate, hp.ssid, locale.city)    
  end
  
  def self.get_schedule(edate, usr)
    elist = Event.find_events(edate, usr.profile)
    usr.private_trackers.each do |pt|
      elist = elist | pt.private_events
    end
    elist   
  end
  
  def self.get_event_details(eid)
    joins(:sessions).find(eid) 
  end
  
  def ssid
    subscriptionsourceID
  end
  
  def cid
    contentsourceID
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
  
  def self.upcoming_events(edate, hp)
    Rails.cache.fetch("find_events", :expires_in => 30.minutes) do 
      find_events(edate, hp)
    end 
  end
  
  def self.delete_cached
    Rails.cache.delete('find_events')
  end
  
  def self.getSQL
      "(SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID, 
        0 as MemberFee, 0 as NonMemberFee, 0 as GroupFee, 0 as SpouseFee, 0 as AffiliateFee, 0 as AtDoorFee, 
        0 as Other1Fee, 0 as Other2Fee, 0 as Other3Fee, 0 as Other4Fee, 0 as Other5Fee, 0 as Other6Fee, 
        0 as Other1Title, 0 as Other2Title, 0 as Other3Title, 0 as Other4Title, 0 as Other5Title, 0 as Other6Title, 
        contentsourceURL, subscriptionsourceURL "     
  end
  
  def self.getSQLfee
      "(SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID,
        MemberFee, NonMemberFee, GroupFee, SpouseFee, AffiliateFee, AtDoorFee,
        Other1Fee, Other2Fee, Other3Fee, Other4Fee, Other5Fee, Other6Fee, 
        Other1Title, Other2Title, Other3Title, Other4Title, Other5Title, Other6Title, 
        contentsourceURL, subscriptionsourceURL"     
  end
 
  def self.getSQLe
      "(SELECT e.ID, e.event_name, e.event_type, e.eventstartdate, e.eventenddate, e.eventstarttime, 
        e.eventendtime,  e.bbody, e.mapplacename, e.localGMToffset, e.endGMToffset,
        e.mapstreet, e.mapcity, e.mapstate, e.mapzip, e.mapcountry, e.location, e.subscriptionsourceID, 
        e.speaker, e.RSVPemail, e.speakertopic, e.host, e.rsvp, e.eventid, e.contentsourceID,     
        0 as MemberFee, 0 as NonMemberFee, 0 as GroupFee, 0 as SpouseFee, 0 as AffiliateFee, 
        0 as AtDoorFee, 0 as Other1Fee, 0 as Other2Fee, 0 as Other3Fee, 0 as Other4Fee, 0 as Other5Fee, 0 as Other6Fee, 
        0 as Other1Title, 0 as Other2Title, 0 as Other3Title, 0 as Other4Title, 0 as Other5Title, 0 as Other6Title, 
        e.contentsourceURL, e.subscriptionsourceURL "     
  end
   
  def self.getSQLefee
      "(SELECT e.ID, e.event_name, e.event_type, e.eventstartdate, e.eventenddate, e.eventstarttime, 
        e.eventendtime,  e.bbody, e.mapplacename, e.localGMToffset, e.endGMToffset,
        e.mapstreet, e.mapcity, e.mapstate, e.mapzip, e.mapcountry, e.location, e.subscriptionsourceID, 
        e.speaker, e.RSVPemail, e.speakertopic, e.host, e.rsvp, e.eventid, e.contentsourceID,     
        e.MemberFee, e.NonMemberFee, e.GroupFee, e.SpouseFee, e.AffiliateFee, e.AtDoorFee,
        e.Other1Fee, e.Other2Fee, e.Other3Fee, e.Other4Fee, e.Other5Fee, e.Other6Fee, 
        e.Other1Title, e.Other2Title, e.Other3Title, e.Other4Title, e.Other5Title, e.Other6Title,         
        e.contentsourceURL, e.subscriptionsourceURL"     
  end
   
  def self.where_dt
      "(LOWER(status) = 'active' AND LOWER(hide) = 'no') 
        AND ((eventstartdate >= curdate() and eventstartdate <= ?) 
        OR (eventstartdate <= curdate() and eventenddate BETWEEN curdate() and ?)) "
  end
  
  def self.where_dte
      "( LOWER(e.status) = 'active' AND LOWER(e.hide) = 'no') 
         AND ((e.eventstartdate >= curdate() and e.eventstartdate <= ?) 
         OR (e.eventstartdate <= curdate() and e.eventenddate BETWEEN curdate() and ?)) "
  end
   
  def self.where_subscriber_id 
     "e,`kitsknndb`.subscriptions s 
        WHERE s.contentsourceID = ?
        AND s.channelID = e.subscriptionsourceID "
  end    
end
