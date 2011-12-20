class EventNoticesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @notices = EventNotice.get_notices(params[:sid])
  end
end
