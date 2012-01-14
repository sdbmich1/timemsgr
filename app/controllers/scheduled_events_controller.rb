class ScheduledEventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
  include ResetDate, SetAssn
  layout :page_layout

  def create
    @event = ScheduledEvent.add_event(params[:id],params[:etype], @user.ssid, params[:sdate] )
    @event.save ? flash[:notice] = "Added event to schedule." : flash[:notice] = "Unable to add event to schedule."
    redirect_to events_url
  end
  
  def edit
    @event = ScheduledEvent.find(params[:id])
    @picture = set_associations(@event.pictures, 1)
  end
  
  def index
    @events = Event.find_events(@enddate, @user.profile)
    @notices = EventNotice.get_notices(@user.ssid).paginate(:page => params[:notice_page], :per_page => 10)
  end

  def update
    @event = ScheduledEvent.find(params[:id])
    if @event.update_attributes(reset_dates(params[:scheduled_event]))
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = ScheduledEvent.set_status(params[:id])
    @event.save ? flash[:notice] = "Removed event from schedule." : flash[:notice] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to(events_url) } 
      format.mobile { redirect_to(events_url) }
      format.js {@events = PrivateEvent.get_event_data(params[:page], current_user.ssid, params[:sdate])}
    end   
  end
    
  def clone  
    @event = ScheduledEvent.find(params[:id]).clone_event
  end
  
  private
  
  def page_layout 
    mobile_device? ? (%w(edit new).detect { |x| x == action_name}) ? 'form' : action_name == 'show' ? 'showitem' : 'application' : "events"
  end    

end
