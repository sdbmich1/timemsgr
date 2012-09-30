class SearchNearbyEventsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout

  def index    
    @nearby_events = CalendarEvent.search query, :conditions => {:mapcity => @location.city + '*'}, :page => params[:page] || 1, 
        :per_page => offset unless query.blank?
    @enddate ||= Date.today+7.days
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'nearby' : "users"
  end  
  
  def offset
    mobile_device? ? 30 : 15
  end 
  
  def query
    @query = params[:search]
  end 

end
