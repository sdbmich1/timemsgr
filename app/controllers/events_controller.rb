class EventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  respond_to :html, :xml, :js, :mobile
  layout :page_layout
	
	def show
 		@event = Event.find_event(params[:id], params[:etype])
 		@sponsor_pages = @event.try(:sponsor_pages)
 		@notification = Notification.new
    mobile_device? ? @presenters = @event.presenters : @presenters = @event.presenters.paginate(:page => params[:presenter_page], :per_page => 15)
	end
	
	def index
    @events = Event.find_events(@enddate, @user.profile)
    @notices = EventNotice.get_notices(@user.ssid)
  end
  
  def notify
    @event_type = params[:etype]
  end
  
  def notice
    EventNotice.mark_as_read! :all, :for => @user    
  end
 	
 	private
 	
 	def page_layout 
    mobile_device? ? action_name == 'show' ? 'showitem' : 'list' : "events"
  end    
 	
 	def load_data
 	  @quote = Promo.random
 	  @notice_types = NoticeType.find_types(params[:etype]) if params[:etype]
    params[:end_date] ? @enddate = Date.today+params[:end_date].to_i.days : @enddate = Date.today+7.days #@events.last.eventenddate
	end

end
