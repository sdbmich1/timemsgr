class LifeEventsController < PrivateEventsController

  def show
    @event = LifeEvent.find_by_eventid(params[:eid])
  end

  def new
    @event = LifeEvent.new
  end

  def create
    @user ||= current_user
    @event = LifeEvent.new(ResetDate::reset_dates(params[:life_event]))
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = LifeEvent.find_event(params[:id], params[:eid])
  end

  def update
    @event = LifeEvent.find(params[:id])
    if @event.update_attributes(ResetDate::reset_dates(params[:life_event]))
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user ||= current_user
    @event = LifeEvent.find_event(params[:id], params[:eid])
    @event.destroy ? flash[:notice] = "Removed event from schedule." : flash[:error] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to(events_url) } 
      format.mobile { redirect_to(events_url) }
      format.js { load_events }
    end  
  end
    
  def clone  
    @event = LifeEvent.find_event(params[:id], params[:eid]).clone_event
  end  

end
