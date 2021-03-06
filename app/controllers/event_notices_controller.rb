class EventNoticesController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @notices = EventNotice.get_notices(params[:sid])
    EventNotice.mark_as_read! :all, :for => @user    
  end
  
  def show
    @notice = EventNotice.find(params[:id])
  end
  
  private
  
  def page_layout 
    mobile_device? ? 'list' : "events"
  end   
end
