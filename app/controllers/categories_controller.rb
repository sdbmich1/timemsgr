class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @categories = Category.get_active_list
    @channels = LocalChannel.get_channel_by_loc(@user.location).paginate(:page => params[:channel_page], :per_page => 15) 
  end
  
  def list
    @channels = Category.get_channels(params[:category], @location.city)[0].paginate(:page => params[:channel_page], :per_page => 15 )
  end

  private
  
  def page_layout 
    mobile_device? ? 'list' : "users"
  end 
    
end
