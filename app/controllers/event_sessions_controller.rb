class EventSessionsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout

  def index
    @event = Event.get_event_details(params[:event_id])
  end

  def show
    @event = Event.find(params[:id])
    @notification = Notification.new
    @presenters, @sessions = @event.presenters, @event.sessions
  end

  private
  
  def page_layout 
    mobile_device? ? action_name == 'show' ? 'showitem' : 'list' : "events"
  end    

end
