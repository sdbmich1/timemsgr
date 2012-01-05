class LifeEventsController < ApplicationController
  before_filter :authenticate_user!
  include ResetDate, SetAssn
  layout :page_layout

  def show
    @event = LifeEvent.find(params[:id])
  end

  def new
    @event = LifeEvent.new(:eventstartdate=>Date.today, :eventenddate=>Date.today)
    @picture = set_associations(@event.pictures, 1)
  end

  def create
    @event = LifeEvent.new(reset_dates(params[:life_event]))
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = LifeEvent.find(params[:id])
    @picture = set_associations(@event.pictures, 1)
  end

  def update
    @event = LifeEvent.find(params[:id])
    if @event.update_attributes(reset_dates(params[:life_event]))
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = LifeEvent.set_status(params[:id])
    @event.save ? flash[:notice] = "Removed event from schedule." : flash[:notice] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to(events_url) } 
      format.mobile { redirect_to(events_url) }
      format.js {@events = PrivateEvent.get_event_data(params[:page], current_user.ssid, params[:sdate])}
    end  
  end
    
  def clone  
    @event = LifeEvent.find(params[:id]).clone_event
  end
  
  private
  
  def page_layout 
    if mobile_device?
      (%w(edit new).detect { |x| x == action_name}) ? 'form' : 'application'
    else
      "events"
    end
  end    


end
