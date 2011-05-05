class EventsController < ApplicationController
   before_filter :authenticate_user!, :load_user, :load_event	
   respond_to :html, :xml, :js
	
  def load_user
    @user = current_user
  end
  
  def load_event
    
    # get list of events 
    @events = Event.active.is_visible?.current(Time.now, Time.now+21.days) 

    # get list of sections for displaying events
    @sections = EventPageSection.all
 
    # get current time
    @time = Time.now
  end

	def show
     
 		# get event data
    @event = Event.find(params[:id])
    
    # get google map data			
 		@json = Event.find(params[:id]).to_gmaps4rails

    # set form type
    @form = 'show_event'

	#	respond_with(@event)
	end
	
	def manage
	  # get event data
	  @events = Event.owned(@user.id)
	  
	  # set form type
	  @form = 'event_list'
	end
	
	def index
 	
    # load event data
    load_event
    
    # set form type
	 	@form = "event_section"
	 	
#		respond_with(@events)	
	end
	
	def clone
	  
	  # get event data
    @event = Event.find(params[:id]).clone
    
    # reset date/time fields
    @event.created_at = nil
    @event.updated_at = nil
    @event.start_date = nil
    @event.end_date = nil
    @event.start_time = nil
    @event.end_time = nil
    
    # set form type
    @form = "add_event" 
    
    # set page title
    @activity_title = 'New Activity'  
    
	end
	
	def edit
	  
    # get event data
    @event = Event.find(params[:id])
	  
	  # set form type
    @form = "add_event"	
    
    # set page title
    @activity_title = 'Edit Activity'
    
    #reset time format
    @event.start_time = set_time_format(@event.start_time)
    @event.end_time = set_time_format(@event.end_time)
	end
	
	def update
    @event = Event.find(params[:id])
  
    # check dates
    params[:event] ||= {}
    
    if !params[:event].empty?
      chk_params(params[:event])
    end
       
    debugger
    
    if @event.update_attributes(params[:event])  
       redirect_to home_path, :notice  => "Successfully updated event."
    else
      flash.now[:error] =  error_messages_for(@event) # @event.errors
      render :action => 'edit'
    end		
	end
	
	def new
     
    # create new event
    @event = Event.new
 		
		# set form type
	  @form = "add_event"
	  
	  # set page title
    @activity_title = 'Add Activity'
	end
	
	def create
        
    # check dates
    reset_dates 
     
    # set new event data
    @event = Event.new(params[:event]) #@user.events.build
   
    respond_to do |format| 
      if @event.update_attributes params[:event]
          format.html { redirect_to home_path(@user), :notice => "Successfully created event." } #
      else
          flash.now[:error] = @event.errors
          format.html { render :action => :new  }  
      end   
    end		
	end
	
	def destroy
    @event = Event.find(params[:id])   
    if @event.destroy
      flash[:notice] = "Successfully deleted event." 
      
      #load events
      @events = Event.owned(@user.id)
   
      respond_with(@events, :location => manage_url)
    else
      flash.now[:error] = @event.errors
      render :action => :manage 
    end
  end
	
	protected
	
	def set_time_format(old_time)
    @new_time = old_time.strftime("%l:%M %P")
  end
  
	def chk_params(item)
	  debugger
	  item[:start_date] = parse_date(item[:start_date])  
    item[:end_date] = parse_date(item[:end_date])
	end
	
	def parse_date(old_dt)
      sdate = old_dt.to_s.split('/')
      @new_dt = Date.parse(sdate.last + '-' + sdate.first + '-' + sdate.second)    
  end     
  
  def reset_dates
    params[:event] ||= {}
    
    if !params[:event].empty?
      chk_params(params[:event])
    end
  end
	
end
