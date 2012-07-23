class SearchChannelsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout

  def index
    @channels = LocalChannel.search params[:search], :conditions => {:localename => @location.city + '*'}, :page => params[:page] || 1, :per_page => 10
  end
  
  def page_layout 
    mobile_device? ? 'pages' : "users"
  end    

end
