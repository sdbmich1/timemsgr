class CalendarsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :js, :mobile, :json
  layout :page_layout
  
  def index
    @events = Event.cal_events enddt, @user.ssid, sdt
    render :json => @events.to_json
  end

  def show
    @enddate ||= Date.today+7.days
  end
  
  private

  def page_layout 
    mobile_device? ? 'noscroll' : "events"
  end    

  def location
    @location.city
  end   
  
  def sdt
    sdt = Time.at(params[:startdt].to_i).utc.to_date if params[:startdt]
    sdt ||= Date.today    
  end

  def enddt
    enddt = Time.at(params[:enddt].to_i).utc.to_date if params[:enddt]
    enddt ||= Date.today+7.days
  end
end
