class SearchPrivateEventsController < ApplicationController
  before_filter :authenticate_user! 
  layout :page_layout

  def index
    @results = ThinkingSphinx.search query, :classes => [PrivateEvent, LifeEvent, ScheduledEvent], 
        :conditions => {:contentsourceID => @user.ssid}, :page => params[:page], :per_page => 15 unless query.blank?
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'list' : "events"
  end 
  
  def query
    @query = params[:search]
  end    
     
end
