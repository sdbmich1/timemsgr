class MapsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :js, :mobile
  layout :page_layout  
  
  def index
    @loc, @title, @lnglat = params[:loc], params[:title], params[:lnglat]
  end
  
  protected
  
  def page_layout 
    mobile_device? ? 'map' : "application"
  end    

end