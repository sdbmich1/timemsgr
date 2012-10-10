class PrivateEvent < ActiveRecord::Base
  include ResetDate
  set_table_name 'eventspriv'
  set_primary_key 'ID'

  before_save :set_flds
  
  attr_accessor :allday, :loc, :fbCircle
 	attr_accessible :allday, :event_name, :event_title, :eventstartdate, :eventenddate, :eventstarttime,
				:eventendtime, :event_type, :reoccurrencetype, :ID, :eventid, :subscriptionsourceID, :pageexttype,
				:mapstreet, :mapcity, :mapstate, :mapzip, :mapcountry, :bbody, :cbody, :location, :contentsourceURL,
				:mapplacename, :contentsourceID, :localGMToffset, :endGMToffset, :status, :hide, :pageextsourceID,
				:allowPrivCircle, :allowSocCircle, :allowWorldCircle, :speaker, :speakertopic, :rsvp, :pageextsrc,
				:remindstartdate, :remindenddate, :remindstarttime, :remindendtime, :reoccurrenceenddate,
				:host, :RSVPemail, :imagelink, :LastModifyBy, :CreateDateTime, :pictures_attributes, :remindflg, :remindertype, :fbCircle
				        
  validates :event_name, :presence => true, :length => { :maximum => 255 },
        :uniqueness => { :scope => [:contentsourceID,:eventstartdate, :eventstarttime] }, :unless => :frequent?
  validates :event_type, :presence => true
  validates_date :eventstartdate, :presence => true #, :on_or_after => :today 
  validates_date :eventenddate, :presence => true, :allow_blank => false, :on_or_after => :eventstartdate
  validates :eventstarttime, :presence => true, :allow_blank => false
  validates :eventendtime, :presence => true, :allow_blank => false
  validates_time :eventendtime, :after => :eventstarttime, :if => :same_day?
  validates_date :reoccurrenceenddate, :presence => true, :allow_blank => false, :between => [:eventenddate, :max_end_date], :if => :frequent?

  has_many :reminders, :dependent => :destroy, :primary_key=>:eventid, :foreign_key => :eventid, 
      :conditions => proc {"eventstartdate = '#{self.eventstartdate}'"} 
  
  has_many :pictures, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true
  
  default_scope :order => 'eventstartdate, eventstarttime ASC'
  
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
	
	scope :active, where(:status.downcase => 'active')
	scope :unhidden, where(:hide.downcase => 'no')
  scope :current, where('eventenddate >= curdate()')

  def inactive?
    status == 'inactive'
  end	
  
  def max_end_date
    eventenddate + 5.years
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
    bbody.gsub("\\n",'').gsub("\n",'')[0..69] + '...' rescue nil
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
    
  def self.upcoming(start_dt, end_dt)
    active.unhidden.where("(eventstartdate >= date(?) and eventenddate <= date(?)) or (eventstartdate <= date(?) and eventenddate >= date(?))", start_dt, end_dt, start_dt, end_dt)
  end   
    
  def owned?(ssid)
    self.contentsourceID == ssid
  end
 
  def self.find_event(eid)
    get_event(eid).first
  end 
  
  def same_day?
    eventstartdate == eventenddate
  end
  
  def frequent?
    reoccurrencetype != 'once' && !reoccurrencetype.blank?
  end
  
  def self.locate_event id, eid
    PrivateEvent.find_by_ID_and_eventid(id, eid) 
  end
  
  def self.move_event(eid, etype, ssid)
    selected_event = Event.find_event(eid, etype)
    selected_event.ID, selected_event.contentsourceID = nil, ssid
    new_event = PrivateEvent.new(selected_event.attributes)
    
    selected_event.pictures.each do |p|
      new_event.pictures.build(:photo => p.photo)
    end
   
    # reset event type
    [['ue','other'],['conf','other'],['conc','other'],['fest','other'],['tmnt','other'],['prf','other'],['mtg','meeting'], ['te','match'], ['es','session']].each do |i|
      new_event.event_type = i[1] if selected_event.event_type == i[0]
    end
    new_event
  end
  
  def self.build_event sdt
    if sdt.blank? || sdt.to_datetime < Time.now 
       PrivateEvent.new
    else
       PrivateEvent.new :eventstartdate => sdt.to_date, :eventenddate => sdt.to_date, :eventstarttime => sdt.to_datetime, :eventendtime => sdt.to_datetime+1.hour
    end
  end
  
  def self.new_event(*args)
    pe, title, *elem = args 
    if title
      newEvent = PrivateEvent.build_event args[6]
      offset = args[6].to_time.utc.getlocal.utc_offset/3600
      
      newEvent.eventstarttime = newEvent.eventstarttime.advance(:hours=>offset)
      newEvent.eventendtime = newEvent.eventendtime.advance(:hours=>offset)
      newEvent.subscriptionsourceID = newEvent.contentsourceID = args[4]
      newEvent.event_title = newEvent.event_name = title
      newEvent.localGMToffset = newEvent.endGMToffset = User.get_user(args[4]).localGMToffset  
      newEvent.event_type =  'OT'
      newEvent
    else    
      pe ? PrivateEvent.new(ResetDate::reset_dates(pe)) : PrivateEvent.add_event(*elem)
    end
  end
  
  def self.add_event(eid, etype, ssid, evid, sdt, title='')
    selected_event = Event.find_event(eid, etype, evid, sdt)
    new_event = PrivateEvent.new(selected_event.attributes) 
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
  
  def self.add_facebook_events(fb_user, usr)
    if fb_user
      fb_user.events.each do |event|
        if event.end_time > Time.now
          start_offset, end_offset = event.start_time.getlocal.utc_offset/3600, event.end_time.getlocal.utc_offset/3600           
          new_event = PrivateEvent.find_or_initialize_by_pageextsourceID(event.identifier, :event_name => event.name)       
          new_event.eventstartdate = new_event.eventstarttime = event.start_time.advance(:hours=>start_offset)
          new_event.eventenddate = new_event.eventendtime = event.end_time.advance(:hours=>end_offset)
          new_event.pageextsourceID, new_event.location, new_event.cbody = event.identifier, event.location, event.description
          new_event.contentsourceURL, new_event.event_type = event.endpoint, 'other'
          new_event.pageexttype, new_event.pageextsrc = 'Facebook','html'
          new_event.contentsourceID = new_event.subscriptionsourceID = usr.ssid
          new_event.localGMToffset = new_event.endGMToffset = usr.localGMToffset
          new_event.save(:validate=>false)
        end
      end
    end 
  end
  
  def clone_event
    new_event = self.clone
    new_event.eventstartdate = new_event.eventenddate = Date.today
    new_event
  end  
      
  protected
   
  def reset_attr
    self.eventstartdate=self.eventenddate = nil
  end
     
  def set_flds
    if new_record?
      self.hide, self.cformat, self.status = "no", "html", "active"
      self.event_title, self.bbody = self.event_name, self.cbody
      self.postdate, self.CreateDateTime = Date.today, Time.now
      self.eventid = self.event_type[0..1] + Time.now.to_i.to_s if self.eventid.blank? 
      self.reoccurrencetype = 'once' if self.reoccurrencetype.blank?
    end
  end
  
  def self.dbname
    Rails.env.development? ? "`kits_development`" : "`kits_production`"
  end  

  def self.current(edt, cid)
    edt.blank? ? edt = Date.today+14.days : edt  
    where_cid = where_dt + " and (contentsourceID = ?)"    
    find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_cid} )
         UNION #{getSQL} FROM #{dbname}.events #{where_cid} )
         ORDER BY eventstartdate, eventstarttime DESC", edt, edt, cid, edt, edt, cid, edt, edt, cid]) 
  end
   
  def self.get_events(cid)
     where_cid = "#{where_stmt} (contentsourceID = ?)"    
     find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_cid} )
         UNION #{getSQL} FROM #{dbname}.events #{where_cid} )
         ORDER BY eventstartdate, eventstarttime DESC", cid, cid, cid]) 
  end
  
  def self.past_events(cid)
     where_cid = "#{where_stmt} (contentsourceID = ?) #{pastSQL}"    
     find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_cid} )
         UNION #{getSQL} FROM #{dbname}.events #{where_cid} )
         ORDER BY eventstartdate, eventstarttime DESC", cid, cid, cid]) 
  end
  
  def self.current_events(cid)
     where_cid = "#{where_stmt} (contentsourceID = ?) #{currentSQL}"    
     find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_cid} )
         UNION #{getSQL} FROM #{dbname}.events #{where_cid} )
         ORDER BY eventstartdate, eventstarttime DESC", cid, cid, cid]) 
  end
  
      
  def self.get_event_pages(page, cid)
     where_cid = "#{where_stmt} (contentsourceID = ?)"    
     paginate_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_cid} )
         UNION #{getSQL} FROM #{dbname}.events #{where_cid} )
         ORDER BY eventstartdate, eventstarttime DESC", cid, cid, cid], :page=>page, :per_page => 30) 
  end
  
  def self.get_event_data(page, cid, sdate)
    sdate.blank? ? get_event_pages(page, cid) : get_event_list(page, cid, sdate)
  end
  
  def self.get_event_list(page, cid, sdate)     
     where_cid = "#{where_stmt} (contentsourceID = ?) AND (date(eventstartdate) = ?)"    
     paginate_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_cid} ) 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_cid} )
         UNION #{getSQL} FROM #{dbname}.events #{where_cid} )
         ORDER BY eventstartdate, eventstarttime DESC", cid, sdate, cid, sdate, cid, sdate], :page=>page, :per_page => 30) 
  end 
  
  def self.where_stmt
    "WHERE (status = 'active' and LOWER(hide) = 'no') AND "
  end  
 
  def self.getSQL
      "(SELECT ID, event_name, event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, subscriptionsourceID, 
        speaker, RSVPemail, speakertopic, host, rsvp, eventid, contentsourceID, status"     
  end
   
  def self.where_dt
      "#{where_stmt} ((eventstartdate >= curdate() and eventstartdate <= ?) 
                or (eventstartdate <= curdate() and eventenddate >= ?)) "
  end 
  
  def self.get_event(eid)
     where_id = "where (eventID = ?))"
     find_by_sql(["#{getSQL} FROM #{dbname}.eventspriv #{where_id} 
         UNION #{getSQL} FROM #{dbname}.eventsobs #{where_id}       
         UNION #{getSQL} FROM #{dbname}.events #{where_id}", eid, eid, eid])        
  end
  
  def self.pastSQL
    'AND eventenddate BETWEEN DATE_SUB(curdate(),INTERVAL 3 MONTH) AND curdate()' 
  end
  
  def self.currentSQL
    "AND ( (eventstartdate BETWEEN curdate() AND DATE_ADD(curdate(), INTERVAL 1 YEAR) ) 
            or (eventstartdate <= curdate() and eventenddate BETWEEN curdate() AND DATE_ADD(curdate(), INTERVAL 1 YEAR)) )"
  end
  
  
  def self.set_status(eid)
    event = PrivateEvent.find_event(eid)
    event.status = 'inactive' if event
    event
  end
       
end
