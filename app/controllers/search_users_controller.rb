class SearchUsersController < ApplicationController
  before_filter :authenticate_user! 
  layout :page_layout

  def index
    query = params[:search]
    page  = params[:page] || 1
    @users = User.search query
  end
  
  def page_layout 
    mobile_device? ? 'list' : "users"
  end    
  
end
