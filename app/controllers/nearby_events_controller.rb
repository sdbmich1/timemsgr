class NearbyEventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout :page_layout
  respond_to :html, :json, :xml, :js, :mobile
  
  def index
    @user ||= current_user
    @events = Event.find_events @enddate, @user
    @nearby_events = @user.nearby_events(location, @enddate)
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'form' : "events"
  end    
    
  def location
    loc = Location.nearest_city(params[:loc]) if params[:loc]
    loc ? loc.city : @location.city
  end
  
  def load_data
    @enddate = params[:end_date] ? Date.today+params[:end_date].to_i.days : Date.today+7.days 
  end
  
end
