class PrivateEventsController < ApplicationController
  before_filter :authenticate_user!
  include ResetDate
  layout :page_layout

  def index
    @start_date = params[:sdate]
    mobile_device? ? @events = PrivateEvent.get_events(@user.ssid) : @events = PrivateEvent.get_event_data(params[:page], @user.ssid, @start_date )
  end

  def show
    @event = PrivateEvent.find_event(params[:id])
  end

  def new
    @event = PrivateEvent.new(:eventstartdate=>Date.today, :eventenddate=>Date.today)
  end

  def create
    @event = PrivateEvent.new(reset_dates(params[:private_event]))
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = PrivateEvent.find(params[:id])
  end

  def update
    @event = PrivateEvent.find_event(params[:id])
    if @event.update_attributes(reset_dates(params[:private_event]))
      redirect_to events_url, :notice  =>  "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = PrivateEvent.set_status(params[:id])
    @event.save ? flash[:notice] = "Removed event from schedule." : flash[:notice] = "Unable to remove event from schedule."
    respond_to do |format|
      format.html { redirect_to(events_url) } 
      format.mobile { redirect_to(events_url) }
      format.js {@events = PrivateEvent.get_event_data(params[:page], current_user.ssid, params[:sdate])}
    end      
  end
    
  def clone  
    @event = PrivateEvent.find_event(params[:id]).clone_event
  end
 
  private
  
  def page_layout 
    mobile_device? ? (%w(edit new).detect { |x| x == action_name}) ? 'form' : action_name == 'show' ? 'showitem' : 'application' : "events"
  end    

end
