class MapsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :js, :mobile
  layout :page_layout  
  
  def index
    @id, @etype, @eid, @sdt, @loc, @title, @lnglat = params[:id], params[:etype], params[:eid], params[:sdt], params[:loc], params[:title], params[:lnglat]
  end
  
  def directions
    @id, @etype, @eid, @sdt, @loc, @title, @lnglat, @mode = params[:id], params[:etype], params[:eid], params[:sdt], params[:loc], params[:title], params[:lnglat], params[:mode]    
  end
  
  def details
    @id, @etype, @eid, @sdt, @loc, @title, @lnglat, @mode = params[:id], params[:etype], params[:eid], params[:sdt], params[:loc], params[:title], params[:lnglat], params[:mode]    
  end

  protected
  
  def page_layout 
    mobile_device? ? 'map' : "application"
  end    

end