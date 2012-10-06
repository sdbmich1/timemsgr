class CalendarsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :js, :mobile, :json
  layout :page_layout
  
  def index
#    @events = CalendarEvent.cal_events enddt 
    @events = Event.cal_events enddt, @user.ssid
    respond_with(@events)
  end

  def show
    @enddate ||= Date.today+7.days
  end
  
  private

  def page_layout 
    "events"
  end    

  def location
    @location.city
  end   

  def enddt
    enddt = Time.at(params[:enddt].to_i).utc.to_date if params[:enddt]
    enddt ||= Date.today+7.days
  end
end
