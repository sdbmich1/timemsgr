class SearchNearbyEventsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout

  def index    
    @nearby_events = CalendarEvent.search query, :conditions => {:mapcity => @location.city + '*'}, :page => params[:page] || 1, :per_page => offset
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'form' : "users"
  end  
  
  def offset
    mobile_device? ? 30 : 15
  end 
  
  def query
    @query = params[:search]
  end 

end
