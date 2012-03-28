require "simple_time_select"
module EventsHelper
  
  def life_observance?(etype)
    (%w(birthday anniversary).detect { |x| x == etype})
  end
  
  def appt?(etype)
    (%w(appt med remind).detect { |x| x == etype})
  end
    
  def is_break?(session_type)
    (%w(wkshp cls ue mtg key brkout panel).detect { |x| x == session_type }).blank?
  end
  
  def major_event?(etype)
    (%w(cnf conf cnv fest crs sem prf trmt).detect { |x| x == etype})
  end
    
  def life_event?(etype)
    etlist = LifeEventType.all.detect {|x| x.Code == etype }
  end

  def private_event?(etype)
    PrivateEventType.all.detect {|x| x.code == etype }
  end
  
  def tsd_event?(etype)
    TsdEventType.active.detect {|x| x.code == etype }
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
    if e[0].eventenddate.to_date > Date.today 
      if e[1].blank? 
         e[0].eventstartdate.to_date <= Date.today ? compare_time(Time.now, e[0].eventendtime) : true 
      else  
         e[1] <= Date.today ? compare_time(Time.now, e[0].eventendtime) : true 
      end
    else
      e[0].eventenddate.to_date == Date.today && compare_time(Time.now, e[0].eventendtime) ? true : false
    end    
  end
  
  def rsvp?(val)
    val.blank? ? false : val.downcase == 'yes' 
  end  

  def is_past?(ev)
    return false if ev.blank? 
    etm = ev.eventendtime.advance(:hours => (0 - ev.endGMToffset).to_i)
    ev.eventstartdate <= Date.today && compare_time(Time.now, etm) ? true : false    
  end
  
  def compare_time(ctime, etime)
    if etime.blank? || ctime.hour > etime.hour
      false
    else
      ctime.hour == etime.hour && ctime.min > etime.min ? false : true
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
#    return tm[0].getlocal if tm[0] && !( tm[2].to_s =~ /^.*\b(facebook|twitter)\b.*$/i).nil?
    unless @user.blank?
      offset = tm[1] - @user.localGMToffset if tm[1]
      @tm = tm[0].advance(:hours => (0 - offset).to_i) if offset
    end 
    @tm.blank? ? tm[0].strftime("%l:%M %p") : @tm.strftime("%l:%M %p")
  end 

  # determine correct observances to display on schedule
  def view_obs?(loc)
    loc.blank? ? true : !(loc =~ /United States/i).nil?
  end
  
  def user_events?
    get_user_events.count > 0
  end
  
  def appointments?
    get_appointments.count > 0
  end
  
  def subscribed?(ssid)
    slist = @user.subscriptions rescue nil
    slist.blank? ? false : slist.detect {|u| u.channelID == ssid && u.status == 'active' }
  end

  def subscriptions?
    get_subscriptions.count > 0
  end
  
  def observances?
    get_observances.count > 0
  end
  
  def get_user_events
    @events.select {|e| e.cid == @user.ssid && !observance?(e.event_type) && !appt?(e.event_type) && time_left?(e)}
  end
  
  def get_event_list(dt)
    get_trkr_schedule(@user, @events, dt).select {|e| (e.cid == @user.ssid || trkr_event?(e.cid)) && e.start_date == dt }.sort_by {|x| x.eventstarttime}     
  end
  
  def get_appointments
    @events.select {|event| appt?(event.event_type) && time_left?(event)}
  end
  
  def get_subscriptions
    @events.reject {|e| !subscribed?(e.ssid) || chk_user_events(get_user_events, e) || !time_left?(e) || is_session?(e.event_type) }
  end
           
  def get_observances
    @events.select {|e| observance?(e.event_type) && view_obs?(e.location) }
  end
  
  def get_upcoming_events(sdt)
    @trk_events ||= get_subscriptions
    @user_events ||= get_user_events
    @events.reject {|e| observance?(e.event_type) || e.start_date > sdt || e.end_date < sdt || e.cid == @user.ssid || chk_user_events(@user_events, e) || is_session?(e.event_type) || !time_left?(e, sdt) || chk_user_events(@trk_events, e)}.map {|e| set_start_date(e,sdt) }
  end
  
  # used to reset the start date for events ranging multiple days when creating daily schedule of upcoming events
  def set_start_date(event, sdt)
    event.eventstartdate = sdt if event.eventenddate >= sdt && event.eventstartdate < sdt
    event
  end
   
  # checks if user has already added an event to their schedule so that it's not added twice for the same date/time 
  def chk_user_events(elist, event)
    elist.detect{|x| x.eventstartdate == event.eventstartdate && x.eventstarttime == event.eventstarttime && x.event_name == event.event_name}
  end
  
  def chk_action(action, event)
    action == 'new' ? true : event.cid == event.ssid ? true : false
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
  
  def get_trkr_schedule(usr, elist, dt)
    (usr.private_trackers | usr.private_trackeds).each do |pt|
      elist = elist | pt.private_events.map {|e| set_event_text(e, pt.first_name, dt)}
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
    when !(args[0] =~ /Suggested/i).nil?; get_upcoming_events(args[1])
    when !(args[0] =~ /Scheduled/i).nil?; get_opportunities(args[1])
    when !(args[0] =~ /Appointment/i).nil?; get_appointments
    when !(args[0] =~ /Tracked/i).nil?; get_subscriptions
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
    when !(area =~ /Tracked/i).nil?
      sclass = {:lnav => 'prev-btn', :rnav => "next-btn", :stype => "sub-slider" } 
    when !(area =~ /Suggested/i).nil?
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
      if start_dt == Date.today
        @date_s = "Today" 
      else
        dtype == "List" ? @date_s = " #{start_dt.strftime("%D")}" : @date_s = "#{start_dt.strftime("%A, %B %e, %Y")}"
      end
    else
      start_dt.blank? ? @date_s = "#{end_dt.strftime("%A, %B %e, %Y")}" : @date_s = "#{start_dt.strftime("%D")} - #{end_dt.strftime("%D")}" 
    end     
	end
	
	# set blank user photo based on gender
	def showphoto(gender)	  	  
	  gender == "Male" ? @photo = "headshot_male.jpg" : @photo = "headshot_female.jpg"
	end
	
  def set_header(form)
    case 
    when !(form =~ /add_event/i).nil?; "Add Activity"
    when !(form =~ /edit_event/i).nil?; @form = "shared/add_event"; "Edit Activity"
    when !(form =~ /event_list/i).nil?; "My Activities"
    when !(form =~ /show_event/i).nil?; "Event Details"
    end
  end	

	def getquote
	  @quote
	end
	
	# get color theme for mobile nav bar tabs - a => black; b=> blue; blue is current tab
	def get_theme(val)
	  val.blank? ? 'baaa' : (val.to_date - Date.today).to_i == 7 ? 'abaa' : (val.to_date - Date.today).to_i == 14 ? 'aaba' : 'baaa'
	end
	
	def bbody?(event)
	  event.bbody.blank? ? false : event.bbody.length < 120 ? false : true
	end
	
	def set_location(event)
	  event.event_type == 'other' ? event.location : event.location_details
	end
	
	def get_nice_date(*args) 
    args[0].blank? ? '' : args[1].blank? ? args[0].strftime("%D") : args[0].strftime('%m/%d/%Y') 
  end  
  
  def get_nice_time(val)
    val.blank? ? '' : val.strftime('%l:%M %p')
  end
  
  def get_local_time(tm)
    tm.utc.getlocal.strftime('%m/%d/%Y %I:%M%p')
  end  
end
