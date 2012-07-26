class ScheduledEventsController < PrivateEventsController
  before_filter :authenticate_user!, :except => [:create]

  def create
    @user ||= current_user
    @event = ScheduledEvent.add_event params[:id], params[:etype], @user.ssid, params[:eid], params[:sdate]
    @event.save ? flash[:notice] = "Added event to schedule." : flash[:error] = "Unable to add event to schedule."
    redirect_to events_url
  end
  
  def edit
    @event = ScheduledEvent.find(params[:id])
    @picture = set_associations(@event.pictures, 1)
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
    @user ||= current_user
    @pgType = params[:edate].to_date < Date.today ? 'past_page' : 'upcoming_page'
    @event = params[:eid] ? ScheduledEvent.find_by_eventid(params[:eid]) : ScheduledEvent.find(params[:id])
    @event.destroy ? flash[:notice] = "Removed event from schedule." : flash[:error] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to events_url } 
      format.mobile { redirect_to events_url }
      format.js { load_events }
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
