class Event < KitsTsdModel  
  include ResetDate
  set_primary_key 'ID' 
  acts_as_mappable
  
  belongs_to :channel
  
  has_many :session_relationships #, :primary_key => :eventid, :foreign_key=>:eventid
  has_many :sessions, :through => :session_relationships

  has_many :event_presenters #, :primary_key => :eventid, :foreign_key=>:eventid
  has_many :presenters, :through => :event_presenters

  has_many :event_sites
  has_many :event_tracks
  has_many :pictures, :as => :imageable, :dependent => :destroy
  has_many :rsvps, :dependent => :destroy, :primary_key=>:eventid, :foreign_key => :EventID
  accepts_nested_attributes_for :rsvps, :reject_if => :all_blank 

  has_many :sponsor_pages
  
  default_scope :order => 'eventstartdate, eventstarttime ASC'

  # define sphinx search criteria and indexes
  define_index do
    indexes :event_name, :sortable => true
    indexes :bbody
    indexes :cbody
   
    has :ID, :as => :event_id
    has :event_type
    has :eventstartdate
    has :mapcity
    where "(status = 'active' AND hide = 'no' AND event_type != 'es')
          AND ((eventstartdate >= curdate() ) 
                OR (eventstartdate <= curdate() and eventenddate >= curdate()) ) "
    set_property :enable_star => 1
    set_property :min_prefix_len => 3
  end
  
  sphinx_scope(:datetime_first) { 
    {:order => 'eventstartdate ASC'}
  }  
  
  default_sphinx_scope :datetime_first

  def self.dbname
    Rails.env.development? ? "`kits_development`" : "`kits_production`"
  end
  
  def self.cal_events edt, cid, sdt=Date.today, loc='USA'
    current(edt, cid, sdt).select {|e| (chk_holiday?(e) && view_obs?(e.location, loc)) || !chk_holiday?(e)}
  end
  
  def self.view_obs?(loc, val)
    if val == 'USA'
      loc.blank? ? true : !(loc =~ /^.*\b(United States|USA)\b.*$/i).nil?
    else
      !(loc =~ /^.*\b(val)\b.*$/i).nil?
    end
  end
  
  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.ID,
      :title => self.event_name,
      :description => self.bbody || "",
      :start => setTimes(self.eventstartdate, self.eventstarttime),
      :end => setTimes(self.eventenddate, self.eventendtime),
      :allDay => holiday?,
      :recurring => false,
      :url => get_url,
      :color => get_color,
      :textColor => get_text_color
    }
  end
  
  def get_url
    unless holiday?
      Rails.application.routes.url_helpers.event_path(self.id, :eid=>self.eventid, :etype=>self.event_type, :sdt=>self.eventstartdate)
    end
  end
  
  def setTimes dt, tm
    unless holiday?
      newdt = dt.strftime('%Y-%m-%d')
      newtm = tm.strftime('%H:%M:%S') if tm
      DateTime.strptime(newdt + ' '+ newtm, '%Y-%m-%d %H:%M:%S').to_time.iso8601
    else
      dt.to_i
    end
  end
  
  def get_color
    if holiday?
      '#CCCCCC'
    elsif self.cid == @@userCid
      '#0C6FCB'
    else
      'green'
    end    
  end
  
  def get_text_color
    if holiday?
      '#000000'
    else
      '#ffffff'
    end
  end
  
  def holiday? 
    (%w(h m).detect { |x| x == self.event_type})
  end 
  
  def self.chk_holiday? e
    (%w(h m).detect { |x| x == e.event_type})    
  end   

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

  # find events based on random selection of given channels  
  def self.nearby_events(chlist, edt)
    events = []        
    chlist.sort_by{rand}[0..9].each do |channel|
      list = channel.calendar_events.range(edt) 
      events = events | list if list
    end
    events.sort_by { |e| e.eventstartdate }
  end
  
  def self.calendar edt
    where(where_dt, edt, edt)
  end
      
  def self.get_local_events loc, edt, limit=90 
    where_loc = where_dt + " AND (mapcity = ?)"
    find_by_sql(["#{getSQL} FROM `kitscentraldb`.events WHERE #{where_loc} ) 
         ORDER BY eventstartdate, eventstarttime ASC LIMIT #{limit}", edt, edt, loc])     
  end
  
  # build dynamic union to pull event data from dbs across different schemas
  def self.current(edt, cid, sdt=Date.today, limit=240, offset=0)
    @@userCid = cid
    where_cid = where_dte + " AND (e.contentsourceID = ?)" 
    where_sid = where_subscriber_id + ' AND ' + where_dte   
    where_hol = where_dte + " AND (e.event_type in ('h','m'))"
    find_by_sql(["#{getSQLe} FROM #{dbname}.eventspriv e WHERE #{where_cid} ) 
         UNION #{getSQLe} FROM #{dbname}.eventsobs e WHERE #{where_cid} )
         UNION #{getSQLefee} FROM `kitscentraldb`.events #{where_sid} )
         UNION #{getSQLefee} FROM `kitsknndb`.events #{where_sid} )
         UNION #{getSQLe} FROM #{dbname}.events e WHERE #{where_cid} )
         UNION #{getSQLefee} FROM `kitscentraldb`.events e WHERE #{where_hol})
         ORDER BY eventstartdate, eventstarttime ASC 
         LIMIT #{limit} OFFSET #{offset}", 
              sdt, edt, sdt, sdt, edt, cid, 
              sdt, edt, sdt, sdt, edt, cid, 
              cid, sdt, edt, sdt, sdt, edt,
              cid, sdt, edt, sdt, sdt, edt,
              sdt, edt, sdt, sdt, edt, cid, 
              sdt, edt, sdt, sdt, edt]) 
  end

  # build dynamic union to pull event data from dbs across different schemas for specific event  
  def self.get_event(eid, etype, evid)
    where_id = "where (ID = ? AND event_type = ? AND eventid = ?))"
    find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_id} 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_id} 
         UNION #{getSQL} FROM #{dbname}.events #{where_id} 
         UNION #{getSQLfee} FROM `kitsknndb`.events #{where_id} 
         UNION #{getSQL} FROM `kitscentraldb`.events #{where_id}", 
         eid, etype, evid, eid, etype, evid, 
         eid, etype, evid, eid, etype, evid, 
         eid, etype, evid])        
  end
  
  def self.find_event(id, etype, eid, sdt)
    event = get_event(id, etype, eid).first rescue nil
    event.eventenddate, event.eventstartdate = sdt, sdt if event
    event
  end 
  
  def self.find_events(edate, usr, sdt=Date.today, limit=90, offset=0) 
    edate.blank? ? edate = Date.today+7.days : edate 
    usr.blank? ? current_events(edate) : current(edate, usr.ssid, Date.today, limit, offset)    
  end
  
  # used to get friends schedule when shared
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
    eventstartdate.to_date if eventstartdate
  end
  
  def end_date
    eventenddate.to_date if eventenddate
  end
  
  def isLegacy?
    contentsourceURL == "http://KITSC.rbca.net"
  end

  def get_zip
    mapzip.blank? ? '' : mapzip
  end
  
  def get_city
    mapcity.blank? ? '' : mapcity
  end
  
  def get_state
    mapstate.blank? ? '' : mapstate
  end
  
  def get_location
    location.blank? || !(location =~ /http/i).nil? ? get_place.blank? ? '' : get_place : location
  end
  
  def get_place
    mapplacename.blank? ? '' : mapplacename
  end
  
  def cityState
    if mapcity && mapstate
      [mapcity, mapstate].compact.join(', ')
    elsif !get_city.blank?
      mapcity
    else
      ''     
    end
  end
  
  def csz
    mapcity.blank? ? '' : mapstate.blank? ? mapcity : [mapcity, mapstate].compact.join(', ') + ' ' + get_zip
  end
  
  def location_details
    get_location.blank? ? csz : [get_location, mapstreet, csz].join(', ') unless get_place.blank? && csz.blank?
  end    
  
  def summary
    bbody.gsub("\\n",' ').gsub("\r\n",' ').gsub("\n",' ').gsub("<br />", ' ').html_safe[0..64] + '...' rescue nil
  end
  
  def listing
    event_name.length < 30 ? event_name.html_safe : event_name.html_safe[0..29] + '...' rescue nil
  end
  
  def details
    cbody.gsub("\\n","<br />").html_safe[0..499]
  end
  
  def full_details
    cbody.gsub("\\n","<br />").html_safe
  end
    
  # action caching for SELECT UNION query
  def self.upcoming_events(edate, hp, loc)
    Rails.cache.fetch("find_events", :expires_in => 30.minutes) do 
      find_events(edate, hp, loc)
    end 
  end
  
  def self.delete_cached
    Rails.cache.delete('find_events')
  end
  
  # define SQL field for SELECT UNION statements without fee and title fields
  def self.getSQL
    "(#{getSQLhdr}, #{otherSQLstr}"     
  end
  
  # define SQL field for SELECT UNION statements with join tables
  def self.getSQLfee
      "(#{getSQLhdr}, MemberFee, NonMemberFee, GroupFee, SpouseFee, AffiliateFee, AtDoorFee,
        Other1Fee, Other2Fee, Other3Fee, Other4Fee, Other5Fee, Other6Fee, 
        Other1Title, Other2Title, Other3Title, Other4Title, Other5Title, Other6Title"     
  end
 
  # define SQL field for SELECT UNION statements for event table without fee and title fields
  def self.getSQLe
    "(#{getSQLehdr}, #{otherSQLstr}"     
  end
  
  def self.otherSQLstr
    "0 as MemberFee, 0 as NonMemberFee, 0 as GroupFee, 0 as SpouseFee, 0 as AffiliateFee, 
     0 as AtDoorFee, 0 as Other1Fee, 0 as Other2Fee, 0 as Other3Fee, 0 as Other4Fee, 0 as Other5Fee, 0 as Other6Fee, 
     0 as Other1Title, 0 as Other2Title, 0 as Other3Title, 0 as Other4Title, 0 as Other5Title, 0 as Other6Title"
  end
  
  # define SQL field for SELECT UNION statements with join tables
  def self.getSQLefee
      "(#{getSQLehdr},  e.MemberFee, e.NonMemberFee, e.GroupFee, e.SpouseFee, e.AffiliateFee, e.AtDoorFee,
        e.Other1Fee, e.Other2Fee, e.Other3Fee, e.Other4Fee, e.Other5Fee, e.Other6Fee, 
        e.Other1Title, e.Other2Title, e.Other3Title, e.Other4Title, e.Other5Title, e.Other6Title"     
  end
  
  def self.getSQLehdr
    "SELECT e.ID, e.event_name, e.event_type, e.eventstartdate, e.eventenddate, e.eventstarttime, 
        e.eventendtime,  e.bbody, e.mapplacename, e.localGMToffset, e.endGMToffset,
        e.mapstreet, e.mapcity, e.mapstate, e.mapzip, e.mapcountry, e.location, e.subscriptionsourceID, 
        e.speaker, e.RSVPemail, e.speakertopic, e.host, e.rsvp, e.eventid, e.contentsourceID,         
        e.contentsourceURL, e.subscriptionsourceURL, e.imagelink "
  end
  
  def self.getSQLhdr
    "SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID, 
        contentsourceURL, subscriptionsourceURL, imagelink "
  end
   
  # define SQL WHERE clause for SELECT UNION statements 
  def self.where_dt
      "(LOWER(status) = 'active' AND LOWER(hide) = 'no') 
        AND ((eventstartdate >= curdate() and eventstartdate <= ?) 
        OR (eventstartdate <= curdate() and eventenddate BETWEEN curdate() and ?)) "
  end
  
  # define SQL WHERE clause for SELECT UNION statements 
  def self.where_dte
      "( LOWER(e.status) = 'active' AND LOWER(e.hide) = 'no' ) 
         AND (e.eventstarttime IS NOT NULL AND e.eventendtime IS NOT NULL)
         AND ((e.eventstartdate >= ? and e.eventstartdate <= ?) 
         OR (e.eventstartdate <= ? and e.eventenddate BETWEEN ? and ?)) "
  end
   
  def self.where_subscriber_id 
     "e,`kitsknndb`.subscriptions s 
        WHERE s.contentsourceID = ?
        AND s.channelID = e.subscriptionsourceID "
  end
  
  def self.calSQL
#    '(SELECT e.ID, e.event_name as "title", Unix_Timestamp(e.eventstartdate) as "start", Unix_Timestamp(e.eventenddate) as "end" '
    "(SELECT e.ID, e.eventid, e.event_name, e.eventstartdate, e.eventenddate "
  end    
end
