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
    (%w(conf conv fest conc trmt fr).detect { |x| x == etype})
  end
  
  def life_event?(etype)
    etlist = LifeEventType.all
    (etlist.detect {|x| x.Code == etype })
  end

  def private_event?(etype)
    etlist = PrivateEventType.all
    (etlist.detect {|x| x.code == etype })
  end
  
  def tsd_event?(etype)
    etlist = EventType.get_tsd_event_types
    (etlist.detect {|x| x.code == etype })
  end

  def current?(sdt)
    sdt >= DateTime.now ? true : false 
  end
  
  def holiday?(etype)
    etype == 'h' 
  end
  
  def observance?(etype)
     life_observance?(etype) || etype == 'm' || etype == 'h'
  end
      
  def is_session?(etype)
    etype == 'es' || etype == 'se' || etype == 'sm'
  end  
  
  def time_left?(e)
    if e.eventenddate.to_date > Date.today 
      if e.eventstartdate.to_date <= Date.today 
        compare_time(Time.now, e.eventendtime)
      else  
        true
      end
    else
      e.eventenddate.to_date == Date.today && compare_time(Time.now, e.eventendtime) ? true : false
    end    
  end
  
  def rsvp?(val)
    return false if val.blank? 
    val.downcase == 'yes' ? true : false
  end  

  def is_past?(ev)
    return false if ev.endGMToffset.blank?
    etm = ev.eventendtime.advance(:hours => (0 - ev.endGMToffset).to_i)
    ev.eventstartdate <= Date.today && compare_time(Time.now, etm) ? true : false    
  end
  
  def compare_time(ctime, etime)
    if ctime.hour > etime.hour
      false
    elsif ctime.hour == etime.hour && ctime.min > etime.min
      false
    else
      true
    end
  end
  
  def compare_times(cur_tm, end_tm)
    ['hour', 'min'].each { |method|
        return false if cur_tm.send(method) > end_tm.send(method) }
    true
  end  
  
  def chk_start_dt(start_dt)
    start_dt < Date.today ? false : true
  end
  
  def chk_event_type(etype, egrp)
    case egrp
    when 'Shop'
      (['perform', 'match', 'sale', 'fund', 'ue', 'ce'].detect {|x| x == etype}).blank?
    else false
    end
  end  
  
  # used to build each day's schedule of events
  def list_events(elist, start_date)
    elist.select {|event| event.eventstartdate.to_date == start_date && time_left?(event)}   
  end
  
  # determines date range to build schedule view
  def get_date_range(*args)
    return [] unless args[0]
    event = args[0]   
    
    if args[1] 
      sdate = event.first.eventstartdate.to_date
      args[1] ? edate = args[1] : edate = sdate
    else
      sdate = event.eventstartdate.to_date
      edate = event.eventenddate.to_date
    end
    sdate = Date.today if sdate < Date.today 
    drange = (sdate..edate).collect { |x| x }
  end

  # adjusts time display by v1.0 time zone offset when appropriate
  def chk_offset(*tm)
    return Time.now unless tm[0]
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
    get_user_events.count > 0 ? true : false
  end
  
  def subscribed?(ssid)
    slist =  @user.try(:subscriptions)
    slist.detect {|u| u.channelID == ssid } if slist
  end

  def observances?
    get_observances.count > 0 ? true : false
  end
  
  def get_user_events
    ssid = @host_profile.try(:subscriptionsourceID)
    @events.select {|e| e.contentsourceID == ssid && !observance?(e.event_type) && !appt?(e.event_type) && time_left?(e)}
  end
  
  def get_appointments
    @events.select {|event| appt?(event.event_type) && time_left?(event)}
  end
  
  def get_subscriptions
    @events.select {|e| subscribed?(e.subscriptionsourceID) && time_left?(e) && !is_session?(e.event_type) }
  end
           
  def get_observances
    @events.select {|e| observance?(e.event_type) && view_obs?(e.location) }
  end
  
  def get_opp_events
    @user_events = get_user_events
    @trk_events = get_subscriptions
    @host_profile.blank? ? ssid = " " : ssid = @host_profile.subscriptionsourceID
    @events.reject {|e| observance?(e.event_type) || e.contentsourceID == ssid || chk_user_events(@user_events, e) || is_session?(e.event_type) || chk_user_events(@trk_events, e) || !time_left?(e)}
  end
  
  def chk_user_events(elist, event)
    elist.detect{|x| x.eventstartdate == event.eventstartdate && x.eventstarttime == event.eventstarttime && x.event_name == event.event_name}
  end
  
  def get_sponsor_type(ary)
    ary.uniq{|x| x.sponsor_type}
  end
  
  def get_sponsors(ary, logo, stype)
    ary.select {|x| x.logo_type == logo && x.sponsor_type == stype} 
  end
  
  def get_logo_size(val)
    list = LogoType.all.select {|x| x.code == val }
    list.first.logo_size
  end
    
  # build default schedule for new web-based users 
  def get_opportunities
    events = []
    t = Time.now
    3.times do |i|
      start_time = Time.at(t.to_i - t.sec - t.min % 15 * 60).advance(:hours => i + 1)
      end_time = Time.at(t.to_i - t.sec - t.min % 15 * 60).advance(:hours => i + 2)
      events << {:start_date => Date.today, :start_time => start_time, :end_time => end_time}
    end
    return events
  end
  
  # determine which events to display
  def get_events(area)
    case 
    when !(area =~ /Observances/i).nil?; get_observances 
    when !(area =~ /Upcoming/i).nil?; get_opp_events
    when !(area =~ /Opportunities/i).nil?; get_opportunities
    when !(area =~ /Appointment/i).nil?; get_appointments
    when !(area =~ /Subscription/i).nil?; get_subscriptions
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
	  etype = EventTypeImage.all.detect { |e| e.event_type == ecode } 
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
  
  def show_date(start_dt)  
    start_dt <= Date.today ? Date.today : start_dt
  end
    
  def get_nice_date(*args) 
    args[0].blank? ? '' : args[1].blank? ? args[0].strftime("%D") : args[0].strftime('%m-%d-%Y') 
  end  

  def set_slider_class(area)
    case 
    when !(area =~ /Observances/i).nil?
      sclass = {:lnav => 'prev-btn', :rnav => "next-btn", :stype => "obsrv-slider" } 
    when !(area =~ /Upcoming/i).nil?
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
      @date_s = "#{start_dt.strftime("%D")} - #{end_dt.strftime("%D")}" 
    end     
	end
	
	# set blank user photo based on gender
	def showphoto(gender)	  	  
	  gender == "Male" ? @photo = "headshot_male.jpg" : @photo = "headshot_female.jpg"
	end
	
  def set_header(form)
    case form
    when "add_event";  "Add Event"
    when "edit_event"; @form = "add_event"; 'Edit Event' 
    when "event_list"; 'Manage Events'
    when "show_event"; 'Event Details'
    end
  end	

	def getquote
	  @quote
	end
end
