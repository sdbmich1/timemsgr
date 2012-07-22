class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :js, :mobile
  layout :page_layout

  def create
    @event = Event.find_event params[:id], params[:etype], params[:eid], params[:sdate]
    @notification = Notification.new(params[:notification])
    @notification.save ? flash[:notice] = "Notification request sent." : flash[:notice] = "Unable to send notification request."
    respond_to do |format|
      format.mobile { redirect_to event_url(:id=>@event, :etype=>@event.event_type, :sdt=>@event.eventstartdate, :eid=>params[:eid]) }
      format.js { render :nothing => true }
    end
  end
  
  def new
    @event = Event.find_event params[:id], params[:etype], params[:eid], params[:sdate]
    @notification = Notification.new
  end
  
  private
  
  def page_layout 
    mobile_device? ? action_name == 'new' ? 'form' : "list" : "list"
  end   
end
