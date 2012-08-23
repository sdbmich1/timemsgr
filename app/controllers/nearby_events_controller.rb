require 'will_paginate/array'
class NearbyEventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout :page_layout
  
  def index
    @user ||= current_user
    @events = Event.find_events @enddate, @user
    @nearby_events = @user.nearby_events(location, @enddate)
  end
  
  protected
  
  def page_layout 
    mobile_device? ? 'form' : "events"
  end    
  
  def offset
    mobile_device? ? 30 : 15
  end 
  
  def location
    loc = params[:loc] ? Location.nearest_city(params[:loc]) : @location
    loc.blank? ? @location.city : loc.city
  end
  
  def load_data
    @enddate = params[:end_date] ? Date.today+params[:end_date].to_i.days : Date.today+7.days 
  end
  
end
