class EventsController < ApplicationController
   before_filter :authenticate_user!	
# respond_to :html, :xml, :js
	
	def show
		#set current user
  		@user = current_user  
  		
 		# get event data
		@event = Event.all #@user.includes(:user_events)	
		
#		@time = Time.now
		
#		debugger
	end
	
	def index
		#set current user
  	@user = current_user 
  	
  	# get list of events 
	 	@events = Event.active.is_visible? #.current_events(Time.now, Time.now+7.days) 
	 	@sections = EventPageSection.all
	 	@time = Time.now
	 	
#	 	respond_to do |format|
#    		format.html # index.html.erb
#    		format.js
#    		format.xml  { render :xml => @posts }
#  		end
#		respond_with(@events)	
	end
	
	def edit
		
	end
	
	def update
		
	end
	
	def new
		
	end
	
	def create
		
	end
	
end
