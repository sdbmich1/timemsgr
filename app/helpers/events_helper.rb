module EventsHelper

	def showtime
		@time = Time.zone.now
	end
	
	def set_form_type(fname)
	  @form = fname
	end
		
	def get_etype_icon(elist, ecode)
	  etype = elist.detect { |e| e.event_type == ecode } 
	  etype.blank? ? 'star_icon.png' : etype.image_file
	end
	
	def nav_btn_img(direction)
	  direction == "left" ? "Arrow-Left-Gray.png" : "Arrow-Right-Gray.png"
	end
	
	def view_obs?(loc)
    loc.blank? ? true : !(loc =~ /United States/i).nil?
  end
  
  def user_events?
    get_user_events.count > 0 ? true : false
  end

  def observances?
    get_observances.count > 0 ? true : false
  end
	
	def life_observance?(etype)
	  (%w(birthday anniversary).detect { |x| x == etype})
	end
	
	def appt?(etype)
    ['appointment', 'medical appointment', 'reminder'].detect { |x| x == etype}
  end
	
	def get_user_events
	  @events.select {|event| event.contentsourceID == @host_profile.subscriptionsourceID && !observance?(event.event_type)}
	end
	
	def get_appointments
    @events.select {|event| appt?(event.event_type)}
  end
	
	def current?(sdt)
	  dt = DateTime.parse(Date.today.year.to_s + '-' + sdt.month.to_s + '-' + sdt.day.to_s)
	  dt >= Date.today ? true : false 
	end
	  	
	def get_observances
	  @events.select {|e| observance?(e.event_type) && view_obs?(e.location) && current?(e.eventstartdate) }
	end
  
  def get_opp_events
    @host_profile.blank? ? ssid = " " : ssid = @host_profile.subscriptionsourceID
    @events.reject {|e| observance?(e.event_type) || e.contentsourceID == ssid || is_session?(e.event_type) }
  end
    
  def get_events(area)
    case 
    when !(area =~ /Observances/i).nil?; get_observances 
    when !(area =~ /Upcoming/i).nil?; get_opp_events
    when !(area =~ /Opportunities/i).nil?; get_opportunities
    when !(area =~ /Appointment/i).nil?; get_appointments
    else get_user_events
    end
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
	
	def get_image
	  @event.photo_file_name.blank? ? "schedule1.jpg" : @event.photo.url()
	end
	
  def holiday?(etype)
    etype == 'h' 
  end
  
  def observance?(etype)
     life_observance?(etype) || etype == 'm' || etype == 'h'
  end
  
	def get_event_type
	  @event.event_type if @event
	end
	
	def chk_start_dt(start_dt)
	  start_dt < Date.today ? false : true
	end
	
	def compare_times(cur_tm, end_tm)
	  ['hour', 'min'].each { |method|
        return true if cur_tm.send(method) > end_tm.send(method) }
    false
	end
	
	def is_past?(ev)
	  return false if ev.endGMToffset.blank?
    etm = ev.eventendtime.advance(:hours => (0 - ev.endGMToffset).to_i)
    ev.eventstartdate <= Date.today && compare_times(Time.now, etm) ? true : false    
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

	def getquote
	  @quote
	end
end
