class SearchUsersController < ApplicationController
  before_filter :authenticate_user! 
  layout :page_layout

  def index
    @rel_type, page = params[:rtype], params[:page] || 1
    @users = User.search query
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'list' : "users"
  end    
  
  def query
    @query = params[:search]
  end   
  
end
