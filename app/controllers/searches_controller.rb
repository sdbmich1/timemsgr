class SearchesController < ApplicationController
  before_filter :authenticate_user! 
  layout :page_layout

  def index
    @results = ThinkingSphinx.search query, :classes => [CalendarEvent, Event], :conditions => {:mapcity => @location.city + '*'}, 
         :order => :eventstartdate, :page => params[:page], :per_page => offset
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'pages' : "events"
  end    

  def offset
    mobile_device? ? 30 : 15
  end 
  
  def query
    @query = params[:search]
  end    

end
