class MajorEventsController < ApplicationController
  require 'will_paginate/array'
  before_filter :authenticate_user!, :load_items
  layout :page_layout
  
  def show
    @event = Event.find_event(params[:id], params[:etype], params[:eid], params[:sdt])
    @notification = Notification.new
    @sponsors = @event.sponsors.paginate(:page => params[:sponsor_page], :per_page => 15) rescue nil
    @presenters = @event.presenters.paginate(:page => params[:presenter_page], :per_page => 15) rescue nil
    @sessions = @event.sessions.paginate(:page => params[:session_page], :per_page => 15) rescue nil
    @exhibitors = @event.exhibitors.paginate(:page => params[:exhibitor_page], :per_page => 15) rescue nil
  end
  
  def about
    @event = Event.find_event(params[:id], params[:etype], params[:eid], params[:sdt])
  end

  private
  
  def page_layout 
    if mobile_device? 
      action_name == 'show' ? 'showitem' : "list"
    else
      'showevent'
    end
  end    

  def load_items
    @notice_types = NoticeType.find_types(params[:etype]) if params[:etype]
  end
end
