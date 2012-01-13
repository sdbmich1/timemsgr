class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @categories = Category.get_active_list
    @channels = @location.channels.paginate(:page => params[:channel_page], :per_page => 15)
  end

  private
  
  def page_layout 
    mobile_device? ? 'list' : "users"
  end 
    
end
