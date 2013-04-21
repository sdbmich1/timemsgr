class NearbyEventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout :page_layout
  respond_to :html, :json, :xml, :js, :mobile
  
  def index
    @user ||= current_user
    @events = Event.find_events @enddate, @user, location
    @nearby_events = @user.nearby_events(location, @enddate)
  end  
  
  private
  
  def page_layout 
    mobile_device? ? 'nearby' : "events"
  end    
    
  def location
   # loc = Location.nearest_city(params[:loc]) if params[:loc] rescue nil
   # @location = loc ? loc : @location
    @location.city
  end
  
  def load_data
    @enddate = params[:end_date] ? Date.today+params[:end_date].to_i.days : Date.today+7.days 
  end  
  
  rescue Geokit::Geocoders::GeocodeError
    flash[:error] = "Geocode access error. Please try again!"
    redirect_to root_url   
end
