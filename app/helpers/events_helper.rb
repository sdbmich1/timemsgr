module EventsHelper

	def showtime
		@time = Time.zone.now
	end
		
	def get_etype_icon(elist, ecode)
	  etype = elist.detect { |e| e.event_type == ecode } 
	  etype.blank? ? 'star_icon.png' : etype.image_file
	end
	
	def nav_btn_img(direction)
	  direction == "left" ? "Arrow-Left-Gray.png" : "Arrow-Right-Gray.png"
	end
	
	def get_user_events
	  @events.select {|event| event.contentsourceID == @user.id.to_s }
	end
	
	def get_observances
	  @events.select {|event| event.event_type == 'h' || event.event_type == 'm' }
	end
	
	def user_events?
	  get_user_events.count > 0 ? true : false
	end

  def observances?
    get_observances.count > 0 ? true : false
  end
  
  def get_slider_events(area)
    case 
    when !(area =~ /Observances/i).nil?; get_observances 
    when !(area =~ /Upcoming/i).nil?; get_opp_events
    else get_user_events
    end
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
	
  def chk_offset(tm, offset, eid)
    unless offset.blank? && @user.localGMToffset.blank? && eid.blank?
      tm = tm.advance(:hours => (0 - offset).to_i)
    end
    return tm.strftime("%l:%M %p")
  end	
  
	def chk_time(val)	  
	  val.blank? ? '' : val.strftime('%l:%M %P')
	end
	
	def rsvp?(val)
	  return false if val.blank? 
	  val.downcase == 'yes' ? true : false
	end
	
	def set_panel
    'shared/user_panel'
	end
	
	def get_nice_date(edate)  
	  edate.blank? ? '' : edate.strftime('%m-%d-%Y') 
	end
	
	def set_header(form)
	  case form
	  when "add_event";  "Add Event"
	  when "edit_event"; @form = "add_event"; 'Edit Event' 
	  when "event_list"; 'Manage Events'
	  when "show_event"; 'Event Details'
	  end
	end
	
	def get_image
	  @event.photo_file_name.blank? ? "schedule1.jpg" : @event.photo.url()
	end
	
  def holiday?(etype)
    etype == 'h' ? true : false
  end

	def get_event_type
	  @event.event_type if @event
	end
	
	def chk_activity_type(event)
	  event.blank? ? '' : event.activity_type
	end
	
	def chk_event_type(etype, egrp)
	  case egrp
	  when 'Shop'
	    case etype 
	    when 'perform', 'match', 'sale', 'fund', 'ue', 'ce'; true
	    else
	      false
	    end
	  else
	    false
    end
	end
	
	def chk_start_dt(start_dt)
	  start_dt < Date.today ? false : true
	end
	
	def show_date(start_dt)  
	  start_dt <= Date.today ? Date.today : start_dt
	end
	
	def is_past?(ev)
	  return false if ev.endGMToffset.blank?
    etm = ev.eventendtime.advance(:hours => (0 - ev.endGMToffset).to_i)
    ev.eventstartdate <= Date.today && Time.now > etm ? true : false    
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
	
	# check if event photo file exists
	def eventphoto(fname)
	  fname.empty? ? fname = "camera.jpg" : fname
	end
	
	def get_opp_events
	  @events.reject {|e| e.event_type == 'h' || e.event_type == 'm' || is_past?(e) || e.contentsourceID == @user.id.to_s }
	end
	
	def getquote
	  @quote
	end
end
