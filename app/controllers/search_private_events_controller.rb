class SearchPrivateEventsController < ApplicationController
  before_filter :authenticate_user! 
  layout :page_layout

  def index
    query = params[:search]
    page  = params[:page] || 1
    @results = ThinkingSphinx.search query, :classes => [PrivateEvent, LifeEvent, ScheduledEvent], :conditions => {:contentsourceID => @user.ssid}, :page => params[:page], :per_page => 15 
  end
  
  def page_layout 
    mobile_device? ? 'list' : "events"
  end    
end
