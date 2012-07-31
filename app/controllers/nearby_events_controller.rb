require 'will_paginate/array'
class NearbyEventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout :page_layout
  
  def index
    @channels = LocalChannel.pick_channels(@user.interests, location.city, @user.location).paginate(:page => params[:page], :per_page => offset)
    @events = Event.nearby_events @channels, @enddate
  end
  
  protected
  
  def page_layout 
    mobile_device? ? 'nearby' : "events"
  end    
  
  def offset
    mobile_device? ? 30 : 15
  end 
  
  def location
    @location ||= Location.nearest_city(params[:loc]) 
  end
  
  def load_data
    @enddate = params[:end_date] ? Date.today+params[:end_date].to_i.days : Date.today+7.days 
  end
  
end
