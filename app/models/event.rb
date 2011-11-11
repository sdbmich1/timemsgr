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
  has_many :rsvps, :dependent => :destroy, :primary_key=>:eventid, :foreign_key => :EventID
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank 

  has_many :sponsor_pages, :dependent => :destroy
  #, :foreign_key => :subscriptionsourceID, :primary_key => :subscriptionsourceID
  
  default_scope :order => 'eventstartdate, eventstarttime ASC'

  def self.channel_events(edt, ssid)
    where_ssid = where_dt + " AND (subscriptionsourceID = ?)" 
    find_by_sql(["#{getSQL} FROM `kitsknndb`.events WHERE #{where_ssid}) 
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, ssid]) 
  end 
  
  def self.current_events(edt)
    find_by_sql(["#{getSQL} FROM `kitscentraldb`.events WHERE #{where_dt} )
         UNION #{getSQL} FROM `kitsknndb`.events WHERE #{where_dt} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, edt, edt]) 
  end  
  
  def self.current(edt, cid)
    where_cid = where_dte + " AND (e.contentsourceID = ?)" 
    where_sid = where_subscriber_id + ' AND ' + where_dte   
    find_by_sql(["#{getSQLe} FROM `kits_development`.eventspriv e WHERE #{where_cid} ) 
         UNION #{getSQLe} FROM `kits_development`.eventsobs e WHERE #{where_cid} )
         UNION #{getSQLefee} FROM `kitsknndb`.events e WHERE #{where_dte} )
         UNION #{getSQLe} FROM `kitscentraldb`.events e WHERE #{where_dte} )
         UNION #{getSQLefee} FROM `kitsknndb`.events #{where_sid} )
         UNION #{getSQLe} FROM `kits_development`.events e WHERE #{where_cid} )
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, cid, edt, edt, cid, edt, edt, edt, edt, cid, edt, edt, edt, edt, cid]) 
  end
  
  def self.get_event(eid, etype)
    where_id = "where (ID = ? AND event_type = ?))"
    find_by_sql(["#{getSQL} FROM `kits_development`.eventspriv #{where_id} 
         UNION #{getSQL} FROM `kits_development`.eventsobs #{where_id} 
         UNION #{getSQL} FROM `kits_development`.events #{where_id} 
         UNION #{getSQLfee} FROM `kitsknndb`.events #{where_id} 
         UNION #{getSQL} FROM `kitscentraldb`.events #{where_id}", eid, etype, eid, etype, eid, etype, eid, etype, eid, etype])        
  end
  
  def self.find_event(eid, etype)
    get_event(eid, etype).try(:first)
  end 
  
  def self.find_events(edate, hp) 
    edate.blank? ? edate = Date.today+14.days : edate  
    hp.blank? ? current_events(edate) : current(edate, hp.subscriptionsourceID)    
  end
  
  def self.get_event_details(eid)
    joins(:sessions).find(eid) 
  end
  
  def self.getSQL
      "(SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID, 
        0 as MemberFee, 0 as NonMemberFee, 0 as GroupFee, 0 as SpouseFee, 0 as AffiliateFee, 
        0 as AtDoorFee, 0 as Other1Fee, 0 as Other2Fee, 0 as Other3Fee, 0 as Other4Fee, 
        0 as Other5Fee, 0 as Other6Fee, contentsourceURL, subscriptionsourceURL "     
  end
  
  def self.getSQLfee
      "(SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID,
        MemberFee, NonMemberFee, GroupFee, SpouseFee, AffiliateFee, AtDoorFee,
        Other1Fee, Other2Fee, Other3Fee, Other4Fee, Other5Fee, Other6Fee, contentsourceURL, subscriptionsourceURL"     
  end
 
  def self.getSQLe
      "(SELECT e.ID, e.event_name, e.event_type, e.eventstartdate, e.eventenddate, e.eventstarttime, 
        e.eventendtime, e.event_title, e.cbody, e.bbody, e.mapplacename, e.localGMToffset, e.endGMToffset,
        e.mapstreet, e.mapcity, e.mapstate, e.mapzip, e.mapcountry, e.location, e.subscriptionsourceID, 
        e.speaker, e.RSVPemail, e.speakertopic, e.host, e.rsvp, e.eventid, e.contentsourceID,     
        0 as MemberFee, 0 as NonMemberFee, 0 as GroupFee, 0 as SpouseFee, 0 as AffiliateFee, 
        0 as AtDoorFee, 0 as Other1Fee, 0 as Other2Fee, 0 as Other3Fee, 0 as Other4Fee, 
        0 as Other5Fee, 0 as Other6Fee, e.contentsourceURL, e.subscriptionsourceURL "     
  end
   
  def self.getSQLefee
      "(SELECT e.ID, e.event_name, e.event_type, e.eventstartdate, e.eventenddate, e.eventstarttime, 
        e.eventendtime, e.event_title, e.cbody, e.bbody, e.mapplacename, e.localGMToffset, e.endGMToffset,
        e.mapstreet, e.mapcity, e.mapstate, e.mapzip, e.mapcountry, e.location, e.subscriptionsourceID, 
        e.speaker, e.RSVPemail, e.speakertopic, e.host, e.rsvp, e.eventid, e.contentsourceID,     
        e.MemberFee, e.NonMemberFee, e.GroupFee, e.SpouseFee, e.AffiliateFee, e.AtDoorFee,
        e.Other1Fee, e.Other2Fee, e.Other3Fee, e.Other4Fee, e.Other5Fee, e.Other6Fee, e.contentsourceURL, e.subscriptionsourceURL"     
  end
 
   
  def self.where_dt
      "(status = 'active' AND hide = 'No') 
                AND ((eventstartdate >= curdate() and eventstartdate <= ?) 
                OR (eventstartdate <= curdate() and eventenddate BETWEEN curdate() and ?)) "
  end
  
  def self.where_dte
      "( e.status = 'active' AND e.hide = 'No') 
                AND ((e.eventstartdate >= curdate() and e.eventstartdate <= ?) 
                OR (e.eventstartdate <= curdate() and e.eventenddate BETWEEN curdate() and ?)) "
  end
   
  def self.where_subscriber_id 
     "e,`kitsknndb`.subscriptions s 
        WHERE s.contentsourceID = ?
        AND s.channelID = e.subscriptionsourceID "
  end    
end
