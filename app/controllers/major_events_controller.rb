class MajorEventsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def show
    @event = Event.find(params[:id])
    @sponsor_pages = @event.try(:sponsor_pages)   
    mobile_device? ? @presenters = @event.presenters : @presenters = @event.presenters.paginate(:page => params[:presenter_page], :per_page => 15)
    mobile_device? ? @sessions = @event.sessions : @sessions = @event.sessions.paginate(:page => params[:session_page], :per_page => 15) 
  end
  
  def about
    @event = Event.find(params[:id])
    mobile_device? ? @presenters = @event.presenters : @presenters = @event.presenters.paginate(:page => params[:presenter_page], :per_page => 15)
  end

  private
  
  def page_layout 
    mobile_device? ? action_name == 'show' ? 'showitem' : 'list' : "events"
  end    

end
