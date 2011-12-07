class SearchesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  layout :page_layout

  def index
    query = params[:search]
    page  = params[:page] || 1
    @results = ThinkingSphinx.search query, :classes => [CalendarEvent, Event] #, :with => {:location_id => @user.location_id}
  end
  
  def page_layout 
    mobile_device? ? 'list' : "events"
  end    

end
