class EventsController < ApplicationController
   before_filter :authenticate_user!, :load_data
   respond_to :html, :xml, :js, :mobile
	
	def show
 		respond_with(@event = Event.find_event(params[:id]))
	end
	
	# list user-specific events
	def manage	
	  respond_with(@events = Event.owned(@user.id))
	end
	
	def index
    params[:end_date].blank? ? @enddate = Time.now+30.days : @enddate = Time.now+params[:end_date].to_i.days   
    respond_with(@events = Event.current(@enddate, @user.id.to_s))
 	end
	
	def clone  
    respond_with(@event = Event.find(params[:id]).clone)
	end
	
	def edit
    respond_with(@event = Event.find(params[:id]))
	end
	
	def update
	  chk_params(params[:event]) if params[:event]
    @event = Event.find(params[:id])                 
    flash[:notice] = "#{get_msg(@user, 'Event')}" if @event.update_attributes(params[:event])       
    respond_with(@event)
	end
	
	def new 
    respond_with(@event = Event.new)
	end
	
	def create
    chk_params(params[:event]) if params[:event] 
    @event = Event.new(params[:event])
    flash[:notice] = "#{get_msg(@user, 'Event')}" if @event.save          
    respond_with(@event, :location => home_url)
 	end
	
	def destroy
    @event = Event.find(params[:id])      
    flash[:notice] = "Successfully deleted event." if @event.destroy     
    respond_with(@event) 
  end
  
  def move
    @selected_event = Event.find_event(params[:id])
    @selected_event.contentsourceID = @user.id
    @event = Event.new(@selected_event.attributes)
    flash[:notice] = "#{get_msg(@user, 'Event')}" if @event.save 
    respond_with(@events = Event.current(params[:end_date], @user.id.to_s)) 
  end
    		
	protected

  def load_data
    @user = current_user
    @quote = Promo.random  
    @etypes = EventTypeImage.all
    @slider = params[:slider] if params[:slider] # used to define sliders for mobile app
  end

	def chk_params(item)
	  item[:eventstartdate] = parse_date(item[:eventstartdate])  
    item[:eventenddate] = parse_date(item[:eventenddate])
	end
	
	def parse_date(old_dt)
    sdate = old_dt.to_s.split('/')
    new_dt = Date.parse(sdate.last + '-' + sdate.first + '-' + sdate.second)    
  end     

end
