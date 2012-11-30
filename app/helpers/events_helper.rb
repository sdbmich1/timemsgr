require "simple_time_select"
include Schedule
module EventsHelper
  
  def life_observance?(etype)
    LifeEventType.all.detect{ |x| x.code == etype}
  end
  
  def appt?(etype)
    (%w(appt med remind).detect { |x| x == etype})
  end
  
  def logistical?(etype)
    etype == 'log' 
  end 
    
  def is_break?(session_type)
    (%w(wkshp cls ue mtg key brkout panel).detect { |x| x == session_type }).blank?
  end
  
  def major_event?(etype)
    (%w(cnf conf cnv fest crs sem prf trmt).detect { |x| x == etype})
  end
    
  def life_event?(etype)
    lt = LifeEventType.get_type etype
    !lt.blank?
  end

  def private_event?(etype)
    pt = PrivateEventType.get_type etype 
    !pt.blank?    
  end
  
  def tsd_event?(etype)
    TsdEventType.active.detect {|x| x.code == etype.downcase }
  end
  
  def trkr_event?(uid)
    (@user.private_trackers | @user.private_trackeds).detect {|x| x.ssid == uid }
  end

  def current?(sdt)
    sdt >= DateTime.now 
  end
  
  def holiday?(etype)
    etype == 'h' 
  end
  
  def observance?(etype)
    life_observance?(etype) || etype == 'm' || etype == 'h'
  end
      
  def is_session?(etype)
    (%w(es se sm session).detect { |x| x == etype }) 
  end  
  
  def get_label(etype)
    case etype
    when 'te', 'trnt', 'tour', 'match', 'perform', 'prf'; 'Player(s)'
    when 'course', 'crs'; 'Instructor(s)'
    when 'conf', 'sem', 'cnf', 'es', 'session','seminar'; 'Speaker(s)'
    else 'Presenter(s)'    
    end
  end
  
  def time_left?(*e)
    e[0].eventenddate.to_date > Date.today ? true : !goneBy?(e)
  end
  
  def goneBy?(e)
    e[0].eventenddate.to_date < Date.today && compare_time(adjust_time(Time.now, e[0].endGMToffset), e[0].eventendtime)
  end
  
  def rsvp?(val)
    val.blank? ? false : val.downcase == 'yes' 
  end 
  
  def adjust_time val, tz_offset
    offset = tz_offset - @user.localGMToffset if tz_offset
    tm = offset ? val.advance(:hours => (0 - offset).to_i) : val
    tm
  end 

  def is_past?(ev)
    return false if ev.blank?
    return false if ev.eventstartdate.blank?
    etm = ev.eventendtime.advance(:hours => (0 - ev.endGMToffset).to_i) rescue nil
    ev.eventstartdate <= Date.today && compare_time(Time.now, etm) ? true : false    
  end
  
  def compare_time(ctime, etime)
    if etime.blank? || ctime.day == etime.day && ctime < etime 
      true
    else
      if ctime.day == etime.day && ctime > etime 
        false
      else
        true
      end
    end
  end
  
  def any_prices?(event)
    %w(AffiliateFee GroupFee MemberFee NonMemberFee AtDoorFee SpouseFee Other1Fee
       Other2Fee Other3Fee Other4Fee Other5Fee Other6Fee).each {
         |method| return true if price_exists?(event,method)
       }
    false
  end
  
  def price_exists?(event, method)
    event.send(method).blank? ? false : event.send(method) > 0 ? true : false
  end
  
  def notice_count(sid)
    notices = EventNotice.get_notices(sid)
    notices.blank? ? 0 : notices.count  
  end
  
  def compare_times(cur_tm, end_tm)
    ['hour', 'min'].each { |method|
      return false if cur_tm.send(method) > end_tm.send(method) }
    true
  end  
  
  def chk_start_dt(start_dt)
    start_dt >= Date.today
  end
  
  def chk_event_type(etype, egrp)
    egrp == 'Shop' ? (['perform', 'match', 'sale', 'fund', 'ue', 'ce'].detect {|x| x == etype}).blank? : false
  end  
    
  # used to build each day's schedule of events
  def list_events(elist, start_date)
    elist.select {|event| event.start_date == start_date && time_left?(event)}   
    elist = parse_list elist, start_date
  end
  
  # determines date range to build schedule view
  def get_date_range(*args)
    return [] unless args[0]
    args[1] ? edate = args[1].to_date : edate = args[0].first.end_date
    drange = (Date.today..edate).collect { |x| x }
  end
  
  def get_dates(val)
    drange = (val.start_date..val.end_date).collect { |x| x }
  end

  # adjusts time display by v1.0 time zone offset when appropriate
  def chk_offset(*tm)
    return Time.now unless tm[0]    
    @tm = adjust_time(tm[0], tm[1]) unless @user.blank?
    @tm.blank? ? tm[0].strftime("%l:%M %p") : @tm.strftime("%l:%M %p")
  end 

  # determine correct observances to display on schedule
  def view_obs?(loc)
    loc.blank? ? true : !(loc =~ /^.*\b(United States|USA)\b.*$/i).nil?
  end
  
  def user_events?
    get_user_events.count > 0 || @trkd
  end
  
  def appointments?
    get_appointments.count > 0
  end
  
  def subscribed?(ssid)
    slist = @user.subscriptions rescue nil
    slist.blank? ? false : slist.detect {|u| u.channelID == ssid && u.status == 'active' }
  end

  def subscriptions?
    get_subscriptions.count > 0 rescue nil
  end
  
  def observances?
    get_observances.count > 0 rescue nil
  end
  
  def logistics?
    get_log_events.count > 0 rescue nil
  end
    
  def get_user_events
    @events.select {|e| e.cid == @user.ssid && !observance?(e.event_type) && !logistical?(e.event_type) && !appt?(e.event_type) && time_left?(e)}
  end
  
  def get_event_list(dt)
    elist = get_trkr_schedule(@user, get_user_events, dt).select {|e| e && (e.cid == @user.ssid || trkr_event?(e.cid)) && e.start_date <= dt && e.end_date >= dt}.sort_by {|x| x.eventstarttime}     
    elist = parse_list elist, dt    
  end
  
  def parse_list elist, dt, *args
    elist.map! {|e| set_start_date(e,dt, args)}.compact! 
    elist = elist.select { |e| time_left?(e) } 
    elist   
  end
  
  def build_list elist, edt, *args
    newlist = []
    (Date.today..edt).each do |edate|
      newlist << parse_list(elist, edate, args)       
    end
    newlist.flatten(1).sort! {|a, b| a.eventstartdate <=> b.eventstartdate}.uniq
  end
  
  def get_appointments
    @events.select {|event| appt?(event.event_type) && time_left?(event)}
  end
  
  def get_log_events
    @events.select {|event| logistical?(event.event_type) && time_left?(event)}
  end
  
  def get_past_events
    @events.reject {|event| chk_user_events(get_current_events, event)}
  end

  def get_current_events
    @events.select {|event| event.eventstartdate.to_date >= Date.today || event.eventenddate.to_date >= Date.today}
  end
  
  def get_subscriptions *args
    elist = @events.reject {|e| !subscribed?(e.ssid) || chk_user_events(get_user_events, e) || is_session?(e.event_type) || !time_left?(e) }
    elist.map! {|e| set_start_date(e,args[0])}.compact! if args[0]
    elist
  end
           
  def get_observances
    @events.select {|e| observance?(e.event_type) && view_obs?(e.location) }
  end
  
  def get_upcoming_events(sdt)
    @trk_events = get_subscriptions sdt
    @nearby_events.reject {|e| observance?(e.event_type) || e.start_date > sdt || e.end_date < sdt || e.cid == @user.ssid || chk_user_events(get_user_events, e) || 
        is_session?(e.event_type) || !time_left?(e, sdt) || chk_user_events(@trk_events, e)}.map {|e| set_start_date(e,sdt) }
  end
  
  def chk_dup_events elist, sdt
    elist.reject {|e| observance?(e.event_type) || chk_user_events(get_user_events, e) || is_session?(e.event_type) }
    elist
  end
  
  # used to reset the start date for events ranging multiple days when creating daily schedule of upcoming events
  def set_start_date(event, sdt, *args)
    if event.eventenddate.to_date >= sdt && event.eventstartdate.to_date <= sdt
      event.eventstartdate = sdt 
      event
    else
      args[0] ? event : nil
    end 
  end
   
  # checks if user has already added an event to their schedule so that it's not added twice for the same date/time 
  def chk_user_events(elist, event)
    elist.detect{|x| (x.eventstartdate == event.eventstartdate && x.eventstarttime == event.eventstarttime && x.event_name == event.event_name) || (x.eventid == event.eventid && x.eventstartdate == event.eventstartdate)}
  end
  
  def chk_action(action, event)
    action == 'new' || action == 'edit' ? true : event.cid == event.ssid ? true : false
  end
  
  def get_sponsor_type(ary)
    ary.uniq{|x| x.sponsor_type}
  end
  
  def get_sponsors(ary, logo, stype)
    ary.select {|x| x.logo_type == logo && x.sponsor_type == stype} 
  end
  
  def get_logo_size(val)
    LogoType.logo_size(val)
  end
  
  # adds event owner to the event text display for shared events
  def set_event_text(event, fname, dt)
    event.event_name = event.event_name + ' (' + fname + ')' if event.eventstartdate.to_date == dt
    event    
  end
  
  def shared? e
    if e.allowPrivCircle == 'yes'
      @trkd = true
      true
    else
      false
    end
  end
  
  def get_trkr_schedule(usr, elist, dt)
    (usr.private_trackers | usr.private_trackeds).each do |pt|
      elist = elist | pt.private_events(@enddate).map {|e| set_event_text(e, pt.first_name, dt) if shared?(e) }
    end
    elist
  end
    
  # build default schedule for new web-based users 
  def get_opportunities(edate)
    events, t = [], Time.now
    (Date.today..edate).each do |dt|
      start_time = end_time = Time.at(t.to_i - t.sec - t.min % 15 * 60) #.advance(:hours => i + 1)
      events << {:start_date => dt, :start_time => start_time, :end_time => end_time}
    end
    events
  end
  
  # determine which events to display
  def get_events(*args)
    case 
    when !(args[0] =~ /Observances/i).nil?; get_observances 
    when !(args[0] =~ /Near/i).nil?; get_upcoming_events(args[1])
    when !(args[0] =~ /Scheduled/i).nil?; get_opportunities(args[1])
    when !(args[0] =~ /Appointment/i).nil?; get_appointments
    when !(args[0] =~ /Suggested/i).nil?; get_subscriptions(args[1])
    when !(args[0] =~ /Logistic/i).nil?; get_log_events
    else get_user_events
    end
  end    

	def showtime
		@time = Time.now
	end
	
	def set_form_type(fname)
	  @form = fname
	end
		
	def get_etype_icon(ecode)
	  etype = EventTypeImage.etype(ecode) 
	  etype.blank? ? 'star_icon.png' : etype.image_file
	end
	
	def nav_btn_img(direction)
	  direction == "left" ? "Arrow-Left-Gray.png" : "Arrow-Right-Gray.png"
	end
	
	def chk_time(val)	  
	  val.blank? ? '' : val.strftime('%l:%M %p')
	end
	
	def set_offset(val)
	  val.blank? ? @user.localGMToffset : val  
	end
	
	def set_panel
    'shared/user_panel' if @form == "event_slider"
  end
  
  def show_date(*args)  
    args[0].to_date <= args[1] ? args[1] : args[0]
  end

  def set_slider_class(area)
    case 
    when !(area =~ /Appointment/i).nil?
      sclass = {:lnav => 'prev-btn', :rnav => "next-btn", :stype => "appt-slider" } 
    when !(area =~ /Suggested/i).nil?
      sclass = {:lnav => 'prev-btn', :rnav => "next-btn", :stype => "sub-slider" } 
    when !(area =~ /Near/i).nil?
      sclass = {:lnav => 'prev', :rnav => "next", :stype => "opp-slider" } 
    else
      sclass = {:lnav => 'sch-prev-btn', :rnav => "sch-next-btn", :stype => "sch-slider" } 
    end
  end
  	
	def get_image
	  @event.photo_file_name.blank? ? "schedule1.jpg" : @event.photo.url()
	end
	
	def get_event_type
	  @event.event_type if @event
	end
	
	# parse date ranges
	def get_start_date(start_dt, end_dt, dtype)	  
    if start_dt == end_dt
      if start_dt.to_date == Date.today
        @date_s = "Today" 
      else
        dtype == "List" ? @date_s = " #{start_dt.strftime("%D")}" : @date_s = "#{start_dt.strftime("%A, %B %e, %Y")}" rescue nil
      end
    else
     @date_s = start_dt.blank? ? "#{end_dt.strftime("%A, %B %e, %Y")}" : "#{start_dt.strftime("%D")} - #{end_dt.strftime("%D")}" 
    end     
	end
	
  def set_header(form)
    case 
    when !(form =~ /add_event/i).nil?; controller_name == 'life_events' ? 'Add Life Event' : "Add Activity"
    when !(form =~ /edit_event/i).nil?; @form = "shared/add_event"; controller_name == 'life_events' ? 'Edit Life Event' : "Edit Activity"
    when !(form =~ /event_list/i).nil?; "My Activities"
    when !(form =~ /show_event/i).nil?; "Event Details"
    end
  end	

	def getquote
	  @quote
	end
	
	# get color theme for mobile nav bar tabs - a => black; b=> blue; blue is current tab
	def get_theme *val
    if val[1]
      val[0].blank? ? 'baaa' : (val[0].to_date - Date.today).to_i == 14 ? 'abaa' : (val[0].to_date - Date.today).to_i == 30 ? 'aaba' : 'baaa'
    else
      val[0].blank? ? 'baaa' : (val[0].to_date - Date.today).to_i == 7 ? 'abaa' : (val[0].to_date - Date.today).to_i == 14 ? 'aaba' : 'baaa'
    end
	end
	
	def bbody?(event)
	  event.bbody.blank? ? false : event.bbody.length < 120 ? false : true
	end
	
	def set_location(event)
	  event.event_type == 'other' ? event.location : event.location_details
	end
	
	def get_nice_date(*args)
	  newdt = args[0].blank? ? Date.today : args[0]
    args[1].blank? ? newdt.strftime("%D") : newdt.strftime('%m/%d/%Y') 
  end  
  
  def get_nice_time(val)
    val.blank? ? '' : val.strftime('%l:%M %p')
  end
  
  def get_local_time(tm)
    tm.utc.getlocal.strftime('%m/%d/%Y %I:%M%p')
  end
  
  def has_reminder? event
    event.remindflg == 'yes'
  end 
  
  def get_display_type(etype, tag)
    [etype == 'event' ? 'private_event' : 'life_event', tag].join('_')
  end 
  
  def get_etype_data(etype)
    etype == 'event' || etype == 'private_events' ? EventType.unhidden : LifeEventType.unhidden
  end
  
  def has_location?(event)
    event.mapplacename.blank? && event.mapcity.blank? && event.location.blank?
  end
  
  def reoccurring? event
    event.reoccurrencetype != 'once' && !event.reoccurrencetype.blank?
  end
  
  def get_lnglat(event)
    if event.longitude && event.latitude
      [event.latitude, event.longitude]
    else 
      addr = Schedule.get_offset event.location_details || event.location
      [addr[:lat], addr[:lng]] rescue nil 
    end 
  end
  
  def build_lnglat_ary elist
    ary = []
    elist.map { |e| ary << (e.location_details || e.location)}
    ary.flatten(1).to_json       
  end
  
  def get_lnglat_ary elist
    ary, cnt = [], 0
    elist.each do |event|
      cnt += 1
      lat, lng = get_lnglat(event)
      ary << [event.location_details, lng, lat, cnt]
    end
    ary.to_json
  end
  
  def isLegacy?(event)
    event.contentsourceURL == "http://KITSC.rbca.net" rescue nil
  end
  
  def showLocation?(event)
    !event.location.blank? && (event.location =~ /http/i).nil? && !isLegacy?(event)
  end
  
  def reminderTitle
    !has_reminder?(@event) ? "+ Add Reminder" : "- Remove Reminder"
  end
  
  def reminderImage
    !has_reminder?(@event) ? "plus_blue.png" : "minus_blue.png"
  end

  def chk_photo cnlr, actn, file_name
    (!(cnlr =~ /users/i).nil? && actn == 'edit') || (!(cnlr =~ /events/i).nil? && actn == 'index') ? @facebook_user.picture : file_name
  end 
  
  def image_exists? model
    model.imagelink.blank? ? false : true rescue nil
  end
  
  def map_loc event
    @loc || event.location_details || event.location
  end
  
  def map_title event
    @title || event.mapplacename || event.location
  end
  
  def celebration? etype
    (%w(anniversary birthday).detect { |x| x == etype})
  end
  
  def sort_list elist
    elist.sort{|a,b| b.eventstartdate <=> a.eventstartdate} if elist
  end
  
  def events_index?
    controller_name == 'events' && action_name == 'index'
  end

  def back_btn?
    (%w(maps directions).detect { |x| x == controller_name})
  end
  
  def data_form?
    (%w(new edit create update).detect { |x| x == action_name})
  end
  
  def map_btn?
    controller_name == 'events' && action_name != 'index'
  end
  
  def select_options action
    action == 'Yes' ? [['Go', {:class=>'menu_options'}], ['Home'], ['Menu']] : [['Go', {:class=>'menu_options'}], ['Home'], ['Menu'], ['Website']]   
  end
  
  def event_cntr?
    !(controller_name =~ /events/i).nil? && action_name != 'index' ? true : false
  end
  
  def picSize etype
    major_event?(etype) ? 'show-pic' : 'ppic'
  end
end
