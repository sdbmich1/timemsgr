class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @categories = Category.get_active_list
    @channels = LocalChannel.get_channel_by_loc(@location.city).paginate(:page => params[:page], :per_page => 10) 
  end
  
  def list
    @channels = Category.get_channels(params[:category], @location.city)[0].paginate(:page => params[:page], :per_page => 10 )
  end

  private
  
  def page_layout 
    mobile_device? ? 'list' : "users"
  end 
    
end
