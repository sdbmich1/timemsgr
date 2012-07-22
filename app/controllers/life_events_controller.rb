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
    @user ||= current_user
    @event = LifeEvent.new(reset_dates(params[:life_event]))
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = params[:eid] ? LifeEvent.find_by_eventid(params[:eid]) : LifeEvent.find(params[:id])
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
    @user ||= current_user
    @event = params[:eid] ? LifeEvent.find_by_eventid(params[:eid]) : LifeEvent.find(params[:id])
    @event.destroy ? flash[:notice] = "Removed event from schedule." : flash[:error] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to(events_url) } 
      format.mobile { redirect_to(events_url) }
      format.js {@events = PrivateEvent.get_event_data(params[:page], @user.ssid, params[:sdate])}
    end  
  end
    
  def clone  
    @event = params[:eid] ? LifeEvent.find_by_eventid(params[:eid]).clone_event : LifeEvent.find(params[:id]).clone_event
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
