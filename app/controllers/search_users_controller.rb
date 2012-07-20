class SearchUsersController < ApplicationController
  before_filter :authenticate_user! 
  layout :page_layout

  def index
    @rel_type, query, page = params[:rtype], params[:search], params[:page] || 1
    @users = User.search query
  end
  
  def page_layout 
    mobile_device? ? 'list' : "users"
  end    
  
end
