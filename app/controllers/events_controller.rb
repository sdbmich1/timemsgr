class EventsController < ApplicationController
   before_filter :authenticate_user!, :load_data, :except => [:get_drop_down_options]
   respond_to :html, :xml, :js, :mobile
	
	def show
    @form = 'show_event'  			
 		respond_with(@event = Event.find_event(params[:id]).first)
	end
	
	# list user-specific events
	def manage	
    @form = 'event_list'	  
	  respond_with(@events = Event.owned(@user.id))
	end
	
	def index
	 	@form = "event_slider"  
	 	@slider = params[:slider] if params[:slider] 
    params[:end_date].blank? ? enddate = Time.now+30.days : enddate = Time.now+params[:end_date].to_i.days   
    respond_with(@events = Event.current(enddate, @user.id))
 	end
	
	def clone  
    redirect_to new_event_path(@event, {:p1 => 'clone', :p2 => params[:id]})
	end
	
	def edit
    @form = "edit_event"	
    @options = get_options 
    respond_with(@event = Event.find(params[:id]))
	end
	
	def update
	  reset_vars
    @event = Event.find(params[:id])                 
    flash[:notice] = "#{get_msg(@user, 'Event')}" if @event.update_attributes(params[:event])       
    respond_with(@event)
	end
	
	def new  			  
    @event = Event.new   
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
    @quote = Promo.random
    @etypes = EventTypeImage.all
  end
	  
  def load_vars
    @form = "add_event"    
    @event.localGMToffset = @event.endGMToffset = @user.localGMToffset 
    @event.contentsourceID = @user.id
    @options = get_options('Activity') # get dropdown options
  end
  
	def chk_params(item)
	  item[:eventstartdate] = parse_date(item[:eventstartdate])  
    item[:eventenddate] = parse_date(item[:eventenddate])
    item[:event_type] = params[:event_type] if params[:event_type]
    item[:activity_type] = params[:activity_type] if params[:activity_type]
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
    chk_params(params[:event]) if params[:event]
  end
  
  # clone event   
  def set_clone(id)
    @event = Event.find(id).clone       
    @event.reset_attr # reset date/time fields
  end	
end
