class EventSessionsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :js, :mobile, :json
  layout :page_layout

  def index
    @event = Event.get_event_details(params[:event_id], @user.ssid)
  end
  
  def calinfo
    @event = Event.get_event_details(params[:event_id], @user.ssid)
    render :json => @event.sessions.to_json
  end  
  
  def schedule
    @event = Event.get_event_details(params[:event_id], @user.ssid)   
  end

  def show
    @event = Event.find(params[:id])
    @notification = Notification.new
    @presenters = @event.presenters rescue nil
    @sessions = @event.sessions rescue nil
  end

  private
  
  def page_layout 
    mobile_device? ? action_name == 'show' ? 'sessions' : 'list' : "events"
  end    

end
