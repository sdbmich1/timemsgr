module EventsHelper
	def showtime
		 @time = Time.now
	end
	
	def gettitle
	  @title = "ScheduleCast"
	end
	
	def showtitle(type, title)
	  @elist = []
	  
	  debugger
	  @events.each do |e|
	    if e.event_type == type
	      @elist << e
	      break
	    end	    
	  end	  
	  
	  if !@elist.empty?
	      render :partial => "event_title", :locals => { :title => title }
    end  
	end
end
