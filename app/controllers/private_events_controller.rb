class PrivateEventsController < ApplicationController
  before_filter :authenticate_user!
  include ResetDate, ImportEvent
  layout :page_layout

  def index
    @start_date = params[:sdate]
    @events = mobile_device? ? PrivateEvent.get_events(@user.ssid) : PrivateEvent.get_event_data(params[:page], @user.ssid, @start_date )
  end

  def show
    @event = PrivateEvent.find_event(params[:id])
  end

  def new
    @event = PrivateEvent.new #(:eventstartdate=>Date.today, :eventenddate=>Date.today)
  end

  def create
    @user ||= current_user
    @event = PrivateEvent.new(reset_dates(params[:private_event]))
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = params[:eid] ? PrivateEvent.find_by_eventid(params[:eid]) : PrivateEvent.find(params[:id])
  end

  def update
    @event = PrivateEvent.find_event(params[:id])
    if @event.update_attributes(reset_dates(params[:private_event]))
      redirect_to events_url, :notice  => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user ||= current_user
    @event = params[:eid] ? PrivateEvent.find_by_eventid(params[:eid]) : PrivateEvent.find(params[:id])
    @event.destroy ? flash[:notice] = "Removed event from schedule." : flash[:error] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to events_url } 
      format.mobile { redirect_to events_url }
      format.js {@events = PrivateEvent.get_event_data(params[:current_page], @user.ssid, params[:sdate])}
    end      
  end
    
  def clone 
    @event = params[:eid] ? PrivateEvent.find_by_eventid(params[:eid]).clone_event : PrivateEvent.find(params[:id]).clone_event 
  end
  
  def gcal_import
    email, pwd = params[:user][:email], params[:user][:password] # grab login parameters

    # import events from google calendar    
    if ImportEvent.gcal_import(email, pwd, @user)
      redirect_to private_events_url 
      flash[:notice] = "Your google calendar events have been successfully imported." 
    else
      flash[:error] = "Import events authentication failed.  Please re-enter your email and password." 
    end
  end
 
  private
  
  def page_layout 
    mobile_device? ? (%w(edit new).detect { |x| x == action_name}) ? 'form' : action_name == 'show' ? 'showitem' : 'list' : "showevent"
  end    

end
