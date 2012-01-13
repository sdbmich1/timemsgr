class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout

  def create
    @event = Event.find_event(params[:id], params[:etype], params[:sdate])
    @notification = Notification.new(params[:notification])
    @notification.save ? flash[:notice] = "Notification request sent." : flash[:notice] = "Unable to send notification request."
    respond_to do |format|
      format.mobile { redirect_to event_url(:id=>@event, :etype=>@event.event_type, :sdate=>@event.eventstartdate) }
    end
  end
  
  def new
    @notification = Notification.new
    @event = Event.find_event(params[:id], params[:etype], params[:sdate])
  end
  
  private
  
  def page_layout 
    mobile_device? ? action_name == 'new' ? 'form' : "list" : "list"
  end   
end
