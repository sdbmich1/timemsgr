class SearchPrivateEventsController < ApplicationController
  before_filter :authenticate_user! 
  layout :page_layout

  def index
    query = params[:search]
    page  = params[:page] || 1
    @results = ThinkingSphinx.search query, :classes => [PrivateEvent, LifeEvent, ScheduledEvent] #, :with => {:location_id => @user.location_id}
  end
  
  def page_layout 
    mobile_device? ? 'list' : "events"
  end    
end
