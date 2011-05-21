class EventsController < ApplicationController
   before_filter :authenticate_user!, :load_user, :load_event	
   respond_to :html, :xml, :js
	
  def load_user
    @user = current_user
  end
  
  def load_event
    
    # get list of events 
    @events = Event.active.is_visible?.current(Time.now, Time.now+21.days) 

    # create new event
    @event = Event.new 
 
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
		  
	  # list user-specific events
#    redirect_to home_url(@events, {:p1 => 'manage'})
    redirect_to :controller => 'events', :action => 'index', :p1 => 'manage'
	end
	
	def index
 	
    # set form type
	 	@form = "event_section" 
	 	
	 	# list all or user-specific events 
    if !params[:p1].nil? 
      if params[:p1] == "manage"
        # get user event data
        @events = Event.owned(@user.id)
        
        # set form type
        @form = 'event_list'
      end
    else
      debugger
      if !params[:numdays].nil? 
        @events = Event.active.is_visible?.current(Time.now, Time.now+params[:numdays].to_i) 
     end
    end
	 	
#		respond_with(@events)	
	end
	
	def clone
	     
    # get id
    @id = params[:id]
    
    # display event
    redirect_to new_event_path(@event, {:p1 => 'clone', :p2 => @id})
	end
	
	def edit
	  
    # get event data
    @event = Event.find(params[:id])
	  
	  # set form type
    @form = "add_event"	
    
    # get dropdown options
    @options = get_options(@event.activity_type)  
    
    # get event type
    @event_type = @event.event_type  
   
    # set page title
    @activity_title = 'Edit Event'
    
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
           
    if @event.update_attributes(params[:event])  
       redirect_to home_path, :notice  => "Successfully updated event."
    else
      flash.now[:error] =  error_messages_for(@event) # @event.errors
      render :action => 'edit'
    end		
	end
	
	def new
     			  
	  # create new event or clone
	  if !params[:p1].nil? 
	    if params[:p1] == "clone"
	       set_clone(params[:p2])
	    end
	  end

    # load initial variables
    load_vars
    
    # set time zone
    @event.start_time_zone = @user.time_zone
    @event.end_time_zone = @user.time_zone
	end
	
	def create
        
    # check dates
    reset_dates 
     
    # set new event data
    @event = Event.new(params[:event]) #@user.events.build
    
    @event.activity_type = params[:activity_type]
    @event.event_type = params[:event_type]
    
    debugger
      
    respond_to do |format| 
      if @event.update_attributes params[:event]    
          format.html { redirect_to home_path, :notice => "Successfully created event." } #
      else
          load_vars
          
          debugger
          flash.now[:error] = @event.errors
          format.html { render :action => :new }  
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
      render :action => :index 
    end
  end
  
  def get_drop_down_options
    val = params[:radio_val]
 
    # get dropdown options 
    render :partial => "typelist", :locals => { :typelist => get_options(val) }
  end
	
	protected
	
	def set_time_format(old_time)
    @new_time = old_time.strftime("%l:%M %P")
  end
  
  def load_vars
    
    # set form type
    @form = "add_event"    
    
    # get dropdown options
    @options = get_options('Activity')    

    # set page title
    @activity_title = 'Add Event'   
  end
  
	def chk_params(item)
	  item[:start_date] = parse_date(item[:start_date])  
    item[:end_date] = parse_date(item[:end_date])
	end
	
	def parse_date(old_dt)
      sdate = old_dt.to_s.split('/')
      @new_dt = Date.parse(sdate.last + '-' + sdate.first + '-' + sdate.second)    
  end     
  
  def get_options(val)
    val ||= 'Activity'
    
    if val == 'Activity'
      options = EventType.all #.collect{|x| "'#{x.Code}', '#{x.Description}'"} 
    else
      options = LifeEventType.all #.collect{|x| "'#{x.Code}', '#{x.Description}'"}      
    end
  end
  
  def reset_dates
    params[:event] ||= {}
    
    if !params[:event].empty?
      chk_params(params[:event])
    end
  end
  
  def set_clone(id)
 
    # clone event   
    @event = Event.find(id).clone   
    
    # set event type   
    @event_type = @event.event_type
    
    # reset date/time fields
    @event.created_at = nil
    @event.updated_at = nil
    @event.start_date = nil
    @event.end_date = nil
    @event.start_time = nil
    @event.end_time = nil
  end	
end
