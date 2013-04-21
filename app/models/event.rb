class Event < KitsTsdModel  
  include ResetDate
  set_primary_key 'ID' 
  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  
  belongs_to :channel
  
  has_many :session_relationships #, :primary_key => :eventid, :foreign_key=>:eventid
  has_many :sessions, :through => :session_relationships

  has_many :event_presenters #, :primary_key => :eventid, :foreign_key=>:eventid
  has_many :presenters, :through => :event_presenters

  has_many :event_sponsors #, :primary_key => :eventid, :foreign_key=>:eventid
  has_many :sponsors, :through => :event_sponsors
  
  has_many :event_exhibitors #, :primary_key => :eventid, :foreign_key=>:eventid
  has_many :exhibitors, :through => :event_exhibitors

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
    events = current(edt, cid, sdt).select {|e| (chk_holiday?(e) && view_obs?(e.location, loc)) || !chk_holiday?(e) }
    sub_events = events.select {|e| e.cid == @@userCid}
    events.reject{|e| chk_user_events(sub_events, e)} 
  end
  
  # checks if user has already added an event to their schedule so that it's not added twice for the same date/time 
  def self.chk_user_events(elist, event)
    elist.detect{|x| (x.eventstartdate == event.eventstartdate && x.eventstarttime == event.eventstarttime && x.event_name == event.event_name) && x.cid != event.cid}
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
      :title => self.listing,
      :description => self.summary,
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
    unless is_session?
      holiday? ? '#CCCCCC' : self.cid == @@userCid ? '#0C6FCB' : 'green'
    else
      EventTrack.get_color self.id, self.track
    end        
  end
  
  def get_text_color
    holiday? ? '#000000' : '#ffffff'   
  end
  
  def holiday? 
    !(%w(h m).detect { |x| x == self.event_type}).nil?
  end 
  
  def is_session?
    (%w(es se sm session).detect { |x| x == self.event_type }) 
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
      
  def self.get_local_events loc, edt, limit=30 
    where_loc = where_dt + " AND (mapcity = ?)"
    find_by_sql(["#{getSQL} FROM `kitscentraldb`.events WHERE #{where_loc} ) 
         ORDER BY eventstartdate, eventstarttime ASC LIMIT #{limit}", edt, edt, loc])     
  end
  
  # build dynamic union to pull event data from dbs across different schemas
  def self.current(edt, cid, sdt=Date.today, limit=240, offset=0)
    @@userCid = cid
    newDt = edt >= Date.today ? edt : Date.today+30.days
    where_cid = where_dte + " AND (e.contentsourceID = ?)" 
    where_sid = where_subscriber_id + ' AND ' + where_edt   
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
              cid, newDt, newDt,
              cid, newDt, newDt,
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
  
  def self.find_events(edate, usr, loc, sdt=Date.today, limit=90, offset=0) 
    edate = edate.blank? ? Date.today+7.days : edate 
    @elist = usr.blank? ? current_events(edate) : current(edate, usr.ssid, Date.today, limit, offset)
    
    # get user schedule data by sections
    @user_events = get_user_events(usr, @elist)
    @elist    
  end
  
  def self.appointments usr
    get_appointments(usr, @elist)
  end
  
  def self.observances
    get_observances @elist
  end
  
  def self.logistics usr
    get_log_events usr, @elist
  end
  
  def self.schedule edate, usr
    build_schedule edate, @elist, usr
  end
  
  def self.subscriptions edate, usr
    @subscriptions = build_subscriptions edate, @elist, usr
  end

  def self.upcoming_events(usr, edate, loc, sdt=Date.today)
    @upcoming_events = build_upcoming_events(usr, sdt, @elist, edate, loc)
  end
  
  def self.user_events
    @user_events
  end
      
  # used to get friends schedule when shared
  def self.get_schedule(edate, usr)
    elist = Event.find_events(edate, usr.profile)
    usr.private_trackers.each do |pt|
      elist = elist | pt.private_events
    end
    elist   
  end
  
  def self.get_event_details(eid, cid)
    @@userCid = cid
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
    event_name.length < 35 ? event_name.html_safe : event_name.html_safe[0..34] + '...' rescue nil
  end
  
  def details
    cbody.gsub("\\n","<br />").html_safe[0..499]
  end
  
  def full_details
    cbody.gsub("\\n","<br />").html_safe
  end
    
  # action caching for SELECT UNION query
  def self.find_schedule(edate, usr, loc)
    Rails.cache.fetch("find_events", :expires_in => 30.minutes) do 
      find_events(edate, usr, loc)
    end 
  end
  
  def self.delete_cached
    Rails.cache.delete('find_events')
  end
  
  def self.list_events(eid, ssid)
    elist = []
    sel_event = Event.get_event_details(eid, ssid)
    (sel_event.start_date..sel_event.end_date).each do |edate|
      elist = parse_list(sel_event.sessions, edate)      
    end
    elist
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
        e.contentsourceURL, e.subscriptionsourceURL, e.imagelink, e.longitude, e.latitude "
  end
  
  def self.getSQLhdr
    "SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID, 
        contentsourceURL, subscriptionsourceURL, imagelink, longitude, latitude "
  end
   
  # define SQL WHERE clause for SELECT UNION statements 
  def self.where_dt
      "(LOWER(status) = 'active' AND LOWER(hide) = 'no') 
        AND ((eventstartdate >= curdate() and eventstartdate <= ?) 
        OR (eventstartdate <= curdate() and eventenddate BETWEEN curdate() and ?)) "
  end

  def self.where_edt
      "(LOWER(e.status) = 'active' AND LOWER(e.hide) = 'no') 
        AND ( (e.eventstartdate >= curdate() and e.eventstartdate <= ?) 
        OR (e.eventstartdate <= curdate() and e.eventenddate BETWEEN curdate() AND ? )) "
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
  
  def life_observance?
    LifeEventType.all.detect{ |x| x.code == event_type}
  end
  
  def appt?
    (%w(appt med remind).detect { |x| x == event_type})
  end
  
  def logistical?
    event_type == 'log' 
  end 
    
  def is_break?
    (%w(wkshp cls ue mtg key brkout panel).detect { |x| x == session_type }).blank?
  end
  
  def major_event?
    (%w(cnf conf cnv fest crs sem prf trmt).detect { |x| x == event_type})
  end  
  
  # check time
  def compare_time ctime, etime
    if etime.blank? || ctime.day == etime.day && ctime < etime 
      true
    else
      ctime.day == etime.day && ctime > etime ? false : true
    end
  end 
  
  def adjust_time val, tz_offset, usr
    offset = tz_offset - usr.localGMToffset if tz_offset
    tm = offset ? val.advance(:hours => (0 - offset).to_i) : val
    tm
  end  
  
  # determines date range to build schedule view
  def self.get_date_range(*args)
    return [] unless args[0]
    args[1] ? edate = args[1].to_date : edate = args[0].first.end_date
    drange = (Date.today..edate).collect { |x| x }
  end
  
  def get_dates(val)
    drange = (val.start_date..val.end_date).collect { |x| x }
  end  
  
  def goneBy? usr
    eventenddate.to_date < Date.today && compare_time(adjust_time(Time.now, endGMToffset, usr), eventendtime)
  end

  def time_left?(usr)
    eventenddate.to_date > Date.today ? true : !goneBy?(usr)
  end

  def trkr_event?(uid, usr)
    (usr.private_trackers | usr.private_trackeds).detect {|x| x.ssid == uid }
  end

  def current?
    eventstartdate >= DateTime.now 
  end
  
  def holiday?
    event_type == 'h' 
  end
  
  def memorance?
    event_type == 'm' 
  end
  
  def observance?
    life_observance? || memorance? || holiday?
  end
      
  def is_session?
    (%w(es se sm session).detect { |x| x == event_type }) 
  end 

  # determine correct observances to display on schedule
  def view_obs?
    location.blank? ? true : !(location =~ /^.*\b(United States|USA)\b.*$/i).nil?
  end
    
  def self.get_appointments usr, elist
    elist.select {|event| event.appt? && event.time_left?(usr)}
  end
  
  def self.get_log_events usr, elist
    elist.select {|event| event.logistical? && event.time_left?(usr)}
  end
  
  def self.get_past_events elist
    elist.reject {|event| chk_user_events(get_current_events(elist), event)}
  end

  def self.get_current_events elist
    elist.select {|event| event.eventstartdate.to_date >= Date.today || event.eventenddate.to_date >= Date.today}
  end  
  
  def self.get_observances elist
    elist.select {|e| e.observance? && e.view_obs? }
  end  

  def self.get_user_events usr, elist
    elist.select {|e| e.cid == usr.ssid && !e.observance? && !e.logistical? && !e.appt? && e.time_left?(usr)}
  end
    
  def self.user_events? 
    @user_events.count > 0 || @trkd
  end
  
  def self.appointments? usr
    appointments(usr).count > 0
  end

  def self.subscriptions? sdt, usr
    subscriptions(sdt, usr).count > 0 rescue nil
  end
  
  def self.observances? 
    observances.count > 0 rescue nil
  end
  
  def self.logistics? usr
    logistics(usr).count > 0 rescue nil
  end
    
  def subscribed?(usr)
    slist = usr.subscriptions rescue nil
    slist.blank? ? false : slist.detect {|u| u.channelID == ssid && u.status.downcase == 'active' }
  end  
  
  # checks if user has already added an event to their schedule so that it's not added twice for the same date/time 
  def self.chk_user_events(elist, event)
    if elist
      elist.detect {|x| (x.eventstartdate == event.eventstartdate && x.eventstarttime == event.eventstarttime && x.event_name == event.event_name) || (x.eventid == event.eventid && x.eventstartdate == event.eventstartdate)}
    end
  end

  # used to reset the start date for events ranging multiple days when creating daily schedule of upcoming events
  def set_start_date(sdt, *args)
    if eventenddate.to_date >= sdt.to_date && eventstartdate.to_date <= sdt.to_date
      self.eventstartdate = sdt
      self
    else
      args[0] ? self : nil
    end 
  end 
    
  # used to build each day's schedule of events
  def self.build_schedule edt, elist, usr
    events = []
    get_date_range(elist, edt).each do |edate|
      events << get_event_list(usr, edate, elist)
    end
    events.flatten 1
  end
  
  def self.build_subscriptions edt, elist, usr
    events = []
    get_date_range(elist, edt).each do |edate|
      events << get_subscriptions(edate, elist, usr)
    end
    events.flatten 1    
  end
  
  def self.build_upcoming_events(usr, sdt, elist, edt, loc)
    events = []
    get_date_range(elist, edt).each do |edate|
      events << get_upcoming_events(usr, sdt, elist, edt, loc)
    end
    events.flatten 1
  end
  
  def self.list_events(usr, elist, start_date)
    elist.select {|event| event.start_date == start_date && event.time_left?(usr)}
    elist = parse_list elist, usr, start_date 
  end  
  
  def self.parse_list elist, usr, dt, *args
    elist.map! {|e| e.set_start_date(dt, args)}.compact! 
    elist = elist.select { |e| e.time_left?(usr) } 
    elist   
  end
  
  def self.get_event_list(usr, dt, elist)
    slist = get_trkr_schedule(usr, user_events, dt).select {|e| e && (e.cid == usr.ssid || e.trkr_event?(e.cid, usr)) && 
        e.start_date <= dt && e.end_date >= dt}.sort_by {|x| x.eventstarttime}
    slist = parse_list slist, usr, dt          
  end  

  def self.get_upcoming_events(usr, sdt, elist, edt, loc)
    nblist = get_local_events(loc, edt)
    nblist.reject {|e| e.observance? || e.start_date > sdt || e.end_date < sdt || e.cid == usr.ssid || chk_user_events(user_events, e) || 
        e.is_session? || !e.time_left?(usr) || chk_user_events(@subscriptions, e)}.map {|e| e.set_start_date(sdt) }
  end
  
  def self.get_subscriptions *args
    sdt = args[0]
    elist = args[1].select {|e| e.subscribed?(args[2]) && !chk_user_events(user_events, e) && !e.is_session? && e.time_left?(args[2]) }
    elist.map! {|e| e.set_start_date(sdt)}.compact! if sdt
    elist
  end
     
  # adds event owner to the event text display for shared events
  def self.set_event_text(fname, dt)
    self.event_name += ' (' + fname + ')' if eventstartdate.to_date == dt
    self   
  end
   
  def shared? 
    @trkd = allowPrivCircle == 'yes' ? true : false rescue nil
  end 
  
  def self.get_trkr_schedule(usr, elist, dt)
    (usr.private_trackers | usr.private_trackeds).each do |pt|
      elist = elist | pt.private_events(dt).map {|e| e.set_event_text(pt.first_name, dt) if e.shared? }
    end
    elist
  end    
end
