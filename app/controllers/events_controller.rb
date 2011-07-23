require 'rewards'
class EventsController < ApplicationController
   before_filter :authenticate_user!, :load_data
   respond_to :html, :xml, :js
   include Rewards
	
	def show
    @form = 'show_event'  			
    @event = Event.find(params[:id])
 		@json = @event.to_gmaps4rails # get google map data
 		respond_with(@event)
	end
	
	# list user-specific events
	def manage	
    @form = 'event_list'	  
	  respond_with(@events = Event.owned(@user.id))
	end
	
	def index
	 	@form = "event_slider"  
    params[:end_date].blank? ? enddate = Time.now+30.days : enddate = Time.now+params[:end_date].to_i.days   
    @events = Event.upcoming(Time.now, enddate)     		
    respond_with(@events)
 	end
	
	def clone  
    redirect_to new_event_path(@event, {:p1 => 'clone', :p2 => params[:id]})
	end
	
	def edit
    @form = "edit_event"	
    @event = Event.find(params[:id])
    @options = get_options(@event.activity_type) # get dropdown options 
    respond_with(@event)
	end
	
	def update
	  reset_vars
    @event = Event.find(params[:id])                 
    flash[:notice] = "#{get_msg(@user, 'Event')}" if @event.update_attributes(params[:event])       
    respond_with(@event)
	end
	
	def new  			  
    @event = Event.new(@user.time_zone)   
    set_clone(params[:p2]) if params[:p1] == "clone"
    load_vars
    respond_with(@event)
	end
	
	def create
    reset_vars 
    @event = Event.new(params[:event])
    flash[:notice] = "#{get_msg(@user, 'Event')}" if @event.save          
    respond_with(@event, :location => home_url)
 	end
	
	def destroy
    @event = Event.find(params[:id])      
    flash[:notice] = "Successfully deleted event." if @event.destroy  
    respond_with(@event, :location => manage_events_url)
  end
  
  # get event type dropdown options  
  def get_drop_down_options
    render :partial => "typelist", :locals => { :typelist => get_options(params[:radio_val]) }
  end
		
	protected

  def load_data
    @user = current_user
    @credits = get_credits(@user.id)
    @etypes = EventType.all
  end
	  
  def load_vars
    @form = "add_event"    
    @event.start_time_zone, @event.end_time_zone = @user.time_zone, @user.time_zone 
    @options = get_options('Activity') # get dropdown options
  end
  
	def chk_params(item)
	  item[:start_date] = parse_date(item[:start_date])  
    item[:end_date] = parse_date(item[:end_date])
    item[:Code] = params[:Code] unless params[:Code].blank?
    item[:activity_type] = params[:activity_type] unless params[:activity_type].blank?
	end
	
	def parse_date(old_dt)
    sdate = old_dt.to_s.split('/')
    new_dt = Date.parse(sdate.last + '-' + sdate.first + '-' + sdate.second)    
  end     
  
  def get_options(val='Activity')
    val == 'Activity' ? options = EventType.all : options = LifeEventType.all       
  end
  
  def reset_vars
    @form = "add_event"    
    params[:event] ||= {}       
    chk_params(params[:event]) unless params[:event].empty?
  end
  
  # clone event   
  def set_clone(id)
    @event = Event.find(id).clone       
    @event.reset_attr # reset date/time fields
  end	
end
