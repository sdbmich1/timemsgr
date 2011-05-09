module EventsHelper

	def showtime
		 @time = Time.now
	end
	
	def get_nice_date(edate)  
	  edate.nil? ? '' : edate.strftime('%m-%d-%Y') 
	end
	
	def chk_activity_type(event)
	  event.nil? ? '' : event.activity_type
	end
	
	def get_start_date(start_dt, end_dt, dtype)

    if start_dt == end_dt
      if start_dt == Date.today
        @date_s = "Today" 
      else
        if dtype == "List"
          @date_s = " #{start_dt.strftime("%D")}"
        else
          @date_s = "#{start_dt.strftime("%A, %B %e, %Y")}"
        end
      end
     else
      @date_s = "#{start_dt.strftime("%D")} - #{end_dt.strftime("%D")}" 
    end     
	end
	
	def showphoto(gender)
	  	  
	  if gender == "Male"
	    @photo = "headshot_male.jpg"
	  else
	    @photo = "headshot_female.jpg"
	  end
	end
	
	def showtitle(type, title)
	  @elist = []
	  
    # check if event type has any listings
	  @events.each do |e|
	    if e.event_type == type
	      @elist << e
	      break
	    end	    
	  end	  
	
	  # check if any events were found if so display section title  
	  if !@elist.empty?
	     @etitle = true
	  else
	     @etitle = false
    end  
	end
end
