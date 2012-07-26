class SearchesController < ApplicationController
  before_filter :authenticate_user! 
  layout :page_layout

  def index
    query, page, max_time = params[:search], params[:page] || 1, Time.now.advance(:days => 14)
    @results = ThinkingSphinx.search query, :classes => [CalendarEvent, Event], :conditions => {:mapcity => @location.city + '*'}, 
        :with => {:eventenddate => Time.now..max_time}, :page => params[:page], :per_page => offset
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'list' : "events"
  end    

  def offset
    mobile_device? ? 30 : 15
  end  

end
