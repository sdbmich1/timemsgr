module EventsHelper

	def showtime
		@time = Time.zone.now
	end
	
	def show_credits
	  @credits
	end
	
	def get_etype_icon(elist, ecode)
	  etype = elist.detect { |e| e.Code == ecode } 
	  etype.blank? ? 'star_icon.png' : etype.photo_file_name
	end
	
	def nav_btn_img(direction)
	  direction == "left" ? "Arrow-Left-Gray.png" : "Arrow-Right-Gray.png"
	end
	
	def user_events?
	  @events.select {|event| event.user_id == @user.id }.count > 0 ? true : false
	end

  def observances?
    @events.select {|event| event.Code == 'obsrv' }.count > 0 ? true : false
  end
	
	def set_slider_class(area)
	  case area
	  when "Observances"
	    sclass = {:lnav => 'prev-btn', :rnav => "next-btn", :stype => "obsv-slider" } 
 	  when "Opportunities"
      sclass = {:lnav => 'prev', :rnav => "next", :stype => "tmp-slider" } 
	  else
      sclass = {:lnav => 'sch-prev-btn', :rnav => "sch-next-btn", :stype => "sch-slider" } 
    end
	end
	
	def chk_time(val)	  
	  val.blank? ? '' : val.strftime('%l:%M %P')
	end
	
	def set_panel
	  @form == "add_event" || @form == "edit_event" ? 'photo_panel' : 'shared/user_panel'
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
	
	def get_event_type
	  @event.Code unless @event.blank?
	end
	
	def chk_activity_type(event)
	  event.blank? ? '' : event.activity_type
	end
	
	def chk_start_dt(start_dt)
	  start_dt < Date.today ? false : true
	end
	
	def show_date(start_dt)  
	  start_dt <= Date.today ? Date.today : start_dt
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
end
