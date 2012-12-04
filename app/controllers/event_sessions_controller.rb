class EventSessionsController < ApplicationController
  before_filter :authenticate_user! 
  before_filter :load_info, :only => [:index, :calinfo, :schedule] 
  respond_to :html, :xml, :js, :mobile, :json
  layout :page_layout
 
  def calinfo
    render :json => @event.sessions.to_json
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
  
  def load_info
    @event = Event.get_event_details(params[:event_id], @user.ssid)      
  end 

end
