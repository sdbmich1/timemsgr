class MajorEventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout :page_layout
  
  def show
    @event = Event.find_event(params[:id], params[:etype], params[:eid], params[:sdt])
    @notification = Notification.new
    @sponsor_pages, @presenters, @sessions = @event.try(:sponsor_pages), @event.try(:presenters), @event.try(:sessions)
  end
  
  def about
    @event = Event.find(params[:id])
    @event.try(:presenters)
  end

  private
  
  def page_layout 
    mobile_device? ? action_name == 'show' ? 'showitem' : 'list' : "events"
  end    

  def load_data
    @notice_types = NoticeType.find_types(params[:etype]) if params[:etype]
  end
end
