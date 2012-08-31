class MajorEventsController < ApplicationController
  require 'will_paginate/array'
  before_filter :authenticate_user!, :load_data
  layout :page_layout
  
  def show
    @event = Event.find_event(params[:id], params[:etype], params[:eid], params[:sdt])
    @notification = Notification.new
    @sponsor_pages = @event.sponsor_pages 
    @presenters = @event.presenters.paginate(:page => params[:presenter_page], :per_page => 15) 
    @sessions = @event.sessions.paginate(:page => params[:session_page], :per_page => 15) 
  end
  
  def about
    @event = Event.find_event(params[:id], params[:etype], params[:eid], params[:sdt])
  end

  private
  
  def page_layout 
    mobile_device? && action_name == 'show' ? 'showitem' : "list"
  end    

  def load_data
    @notice_types = NoticeType.find_types(params[:etype]) if params[:etype]
  end
end
