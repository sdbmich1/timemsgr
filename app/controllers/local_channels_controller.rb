class LocalChannelsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  respond_to :html, :json, :xml, :js, :mobile

  def index
    @channels = LocalChannel.get_channel_by_loc(@location.city).paginate(:page => params[:page], :per_page => 15) 
    respond_with(@channels)   
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'list' : "users"
  end   
end
