class PrivateEventsController < ApplicationController
   before_filter :authenticate_user!, :except => [:index]
   before_filter :load_data
   respond_to :html, :xml, :js, :mobile

  def index
    @events = PrivateEvent.get_current_events
  end

  def show
    @event = PrivateEvent.find_event(params[:id])
  end

  def new
    @event = PrivateEvent.new
  end

  def create
    @event = PrivateEvent.new(params[:private_event])
    if @event.save
      redirect_to @event, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = PrivateEvent.find(params[:id])
  end

  def update
    @event = PrivateEvent.find(params[:id])
    if @event.update_attributes(params[:private_event])
      redirect_to @event, :notice  =>  "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = PrivateEvent.find(params[:id])
    @event.destroy
    redirect_to private_events_url, :notice => "Successfully destroyed private event."
  end
  
  def move
    @selected_event = Event.find_event(params[:id])
    @event = PrivateEvent.new(@selected_event.attributes)
    flash[:notice] = "#{get_msg(@user, 'Event')}" if @event.save 
    respond_with(@events = PrivateEvent.current(params[:end_date])) 
  end
  
  def clone  
    respond_with(@event = Event.find(params[:id]).clone)
  end
 
  private
    
  def load_data
    @user = current_user
    @quote = Promo.random  
    @etypes = EventTypeImage.all
    @slider = params[:slider] if params[:slider] # used to define sliders for mobile app
  end
   
  def chk_params(item)
    item[:eventstartdate] = parse_date(item[:eventstartdate]) if item[:eventstartdate] 
    item[:eventenddate] = parse_date(item[:eventenddate]) if item[:eventenddate]
  end
  
  def parse_date(old_dt)
    sdate = old_dt.to_s.split('/')
    new_dt = Date.parse(sdate.last + '-' + sdate.first + '-' + sdate.second)    
  end   

end
